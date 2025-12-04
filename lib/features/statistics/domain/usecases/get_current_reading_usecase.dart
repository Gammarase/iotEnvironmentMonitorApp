import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sensor_reading.dart';
import '../repositories/sensor_readings_repository.dart';

class GetCurrentReadingUseCase {
  final SensorReadingsRepository repository;

  GetCurrentReadingUseCase(this.repository);

  Future<Either<Failure, SensorReading>> call({required int deviceId}) async {
    return await repository.getCurrentReading(deviceId: deviceId);
  }
}
