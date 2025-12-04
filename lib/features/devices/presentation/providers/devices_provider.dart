import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/device.dart';
import '../../domain/usecases/get_devices_usecase.dart';
import '../../domain/usecases/create_device_usecase.dart';
import '../../domain/usecases/update_device_usecase.dart';
import '../../domain/usecases/delete_device_usecase.dart';

/// Devices provider for managing devices list state
class DevicesProvider extends ChangeNotifier {
  final GetDevicesUseCase getDevicesUseCase;
  final CreateDeviceUseCase createDeviceUseCase;
  final UpdateDeviceUseCase updateDeviceUseCase;
  final DeleteDeviceUseCase deleteDeviceUseCase;

  DevicesProvider({
    required this.getDevicesUseCase,
    required this.createDeviceUseCase,
    required this.updateDeviceUseCase,
    required this.deleteDeviceUseCase,
  });

  List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMorePages = true;

  // Getters
  List<Device> get devices => _devices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMorePages => _hasMorePages;

  /// Load devices (first page)
  Future<void> loadDevices() async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    final result = await getDevicesUseCase(page: _currentPage);

    result.fold(
      (failure) {
        _isLoading = false;
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (response) {
        _devices = response.data;
        _hasMorePages = response.meta.hasMorePages;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Load more devices (pagination)
  Future<void> loadMoreDevices() async {
    if (!_hasMorePages || _isLoading) return;

    _currentPage++;
    final result = await getDevicesUseCase(page: _currentPage);

    result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (response) {
        _devices.addAll(response.data);
        _hasMorePages = response.meta.hasMorePages;
        notifyListeners();
      },
    );
  }

  /// Create device
  Future<bool> createDevice({
    required String deviceId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    _error = null;

    final result = await createDeviceUseCase(
      deviceId: deviceId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (device) {
        // Reload devices to show new device
        loadDevices();
        return true;
      },
    );
  }

  /// Update device
  Future<bool> updateDevice({
    required int id,
    required String name,
    required bool isActive,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    _error = null;

    final result = await updateDeviceUseCase(
      id: id,
      name: name,
      isActive: isActive,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (device) {
        // Update device in list
        final index = _devices.indexWhere((d) => d.id == id);
        if (index != -1) {
          _devices[index] = device;
          notifyListeners();
        }
        return true;
      },
    );
  }

  /// Delete device
  Future<bool> deleteDevice(int id) async {
    _error = null;

    final result = await deleteDeviceUseCase(id);

    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        notifyListeners();
        return false;
      },
      (_) {
        // Remove device from list
        _devices.removeWhere((d) => d.id == id);
        notifyListeners();
        return true;
      },
    );
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is AuthenticationFailure) {
      return 'Authentication failed. Please login again.';
    } else if (failure is ValidationFailure) {
      final firstError = failure.errors.values.first.first;
      return firstError;
    } else if (failure is NotFoundFailure) {
      return 'Device not found.';
    } else if (failure is ForbiddenFailure) {
      return 'You don\'t have permission to access this device.';
    } else if (failure is ServerFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
