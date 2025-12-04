import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/devices_repository.dart';
import '../datasources/devices_remote_datasource.dart';
import '../models/device_create_model.dart';
import '../models/device_update_model.dart';

/// Devices repository implementation
class DevicesRepositoryImpl implements DevicesRepository {
  final DevicesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DevicesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedResponse<Device>>> getDevices({
    int page = 1,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.getDevices(page: page);

      final devices = PaginatedResponse<Device>(
        data: response.data.map((model) => model.toEntity()).toList(),
        links: response.links,
        meta: response.meta,
      );

      return Right(devices);
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Device>> getDeviceById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final deviceModel = await remoteDataSource.getDeviceById(id);
      return Right(deviceModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Device>> createDevice({
    required String deviceId,
    required String name,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = DeviceCreateModel(
        deviceId: deviceId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        description: description,
      );

      final deviceModel = await remoteDataSource.createDevice(model);
      return Right(deviceModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        e.errors.map((key, value) => MapEntry(key, List<String>.from(value))),
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Device>> updateDevice({
    required int id,
    required String name,
    required bool isActive,
    double? latitude,
    double? longitude,
    String? description,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = DeviceUpdateModel(
        name: name,
        isActive: isActive.toString(),
        latitude: latitude,
        longitude: longitude,
        description: description,
      );

      final deviceModel = await remoteDataSource.updateDevice(id, model);
      return Right(deviceModel.toEntity());
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        e.errors.map((key, value) => MapEntry(key, List<String>.from(value))),
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDevice(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteDevice(id);
      return const Right(null);
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
