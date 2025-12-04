import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/device.dart';
import '../../domain/usecases/get_device_details_usecase.dart';

/// Device details provider
class DeviceDetailsProvider extends ChangeNotifier {
  final GetDeviceDetailsUseCase getDeviceDetailsUseCase;

  DeviceDetailsProvider({
    required this.getDeviceDetailsUseCase,
  });

  Device? _device;
  bool _isLoading = false;
  String? _error;

  // Getters
  Device? get device => _device;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load device details
  Future<void> loadDeviceDetails(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getDeviceDetailsUseCase(id);

    result.fold(
      (failure) {
        _isLoading = false;
        _error = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (device) {
        _device = device;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection.';
    } else if (failure is NotFoundFailure) {
      return 'Device not found.';
    } else if (failure is ForbiddenFailure) {
      return 'Access denied.';
    }
    return 'Failed to load device details.';
  }
}
