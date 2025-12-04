import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/models/paginated_response.dart';
import '../entities/device.dart';
import '../repositories/devices_repository.dart';

/// Get devices use case
class GetDevicesUseCase {
  final DevicesRepository repository;

  GetDevicesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<Device>>> call({
    int page = 1,
  }) async {
    return await repository.getDevices(page: page);
  }
}
