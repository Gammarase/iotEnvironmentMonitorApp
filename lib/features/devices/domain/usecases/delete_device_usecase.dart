import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/devices_repository.dart';

/// Delete device use case
class DeleteDeviceUseCase {
  final DevicesRepository repository;

  DeleteDeviceUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteDevice(id);
  }
}
