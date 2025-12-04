import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/models/paginated_response.dart';
import '../entities/device.dart';

/// Devices repository interface
abstract class DevicesRepository {
  /// Get paginated list of devices
  Future<Either<Failure, PaginatedResponse<Device>>> getDevices({
    int page = 1,
  });

  /// Get device details by ID
  Future<Either<Failure, Device>> getDeviceById(int id);

  /// Create new device
  Future<Either<Failure, Device>> createDevice({
    required String deviceId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
  });

  /// Update device
  Future<Either<Failure, Device>> updateDevice({
    required int id,
    required String name,
    required bool isActive,
    double? latitude,
    double? longitude,
    String? description,
  });

  /// Delete device
  Future<Either<Failure, void>> deleteDevice(int id);
}
