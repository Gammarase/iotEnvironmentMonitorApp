import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/repositories/sensor_readings_repository.dart';
import '../datasources/sensor_readings_remote_datasource.dart';

class SensorReadingsRepositoryImpl implements SensorReadingsRepository {
  final SensorReadingsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SensorReadingsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SensorReading>> getCurrentReading({required int deviceId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getCurrentReading(deviceId: deviceId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SensorReading>>> getReadingsHistory({
    required int deviceId,
    required String startDate,
    required String endDate,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getReadingsHistory(
        deviceId: deviceId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
