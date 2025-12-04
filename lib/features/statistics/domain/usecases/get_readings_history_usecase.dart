import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sensor_reading.dart';
import '../repositories/sensor_readings_repository.dart';

class GetReadingsHistoryUseCase {
  final SensorReadingsRepository repository;

  GetReadingsHistoryUseCase(this.repository);

  Future<Either<Failure, List<SensorReading>>> call({
    required int deviceId,
    required String startDate,
    required String endDate,
  }) async {
    return await repository.getReadingsHistory(
      deviceId: deviceId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
