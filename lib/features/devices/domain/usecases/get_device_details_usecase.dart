import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device.dart';
import '../repositories/devices_repository.dart';

/// Get device details use case
class GetDeviceDetailsUseCase {
  final DevicesRepository repository;

  GetDeviceDetailsUseCase(this.repository);

  Future<Either<Failure, Device>> call(int id) async {
    return await repository.getDeviceById(id);
  }
}
