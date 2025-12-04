import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/sensor_reading.dart';

abstract class SensorReadingsRepository {
  Future<Either<Failure, SensorReading>> getCurrentReading({required int deviceId});
  Future<Either<Failure, List<SensorReading>>> getReadingsHistory({
    required int deviceId,
    required String startDate,
    required String endDate,
  });
}
