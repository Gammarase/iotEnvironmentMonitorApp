import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device.dart';
import '../repositories/devices_repository.dart';

/// Update device use case
class UpdateDeviceUseCase {
  final DevicesRepository repository;

  UpdateDeviceUseCase(this.repository);

  Future<Either<Failure, Device>> call({
    required int id,
    required String name,
    required bool isActive,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    return await repository.updateDevice(
      id: id,
      name: name,
      isActive: isActive,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );
  }
}
