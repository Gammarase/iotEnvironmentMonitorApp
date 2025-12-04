import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device.dart';
import '../repositories/devices_repository.dart';

/// Create device use case
class CreateDeviceUseCase {
  final DevicesRepository repository;

  CreateDeviceUseCase(this.repository);

  Future<Either<Failure, Device>> call({
    required String deviceId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    return await repository.createDevice(
      deviceId: deviceId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );
  }
}
