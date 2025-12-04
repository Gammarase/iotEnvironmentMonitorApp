import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

/// Auth repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final request = LoginRequestModel(email: email, password: password);
      final response = await remoteDataSource.login(request);

      // Save token
      await secureStorage.saveToken(response.token);
      await secureStorage.saveUserId(response.user.id);
      await secureStorage.saveUserEmail(response.user.email);
      await secureStorage.saveUserName(response.user.name);

      return Right({
        'user': response.user.toEntity(),
        'token': response.token,
      });
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
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    String? timezone,
    String? language,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final request = RegisterRequestModel(
        name: name,
        email: email,
        password: password,
        timezone: timezone,
        language: language,
      );
      final response = await remoteDataSource.register(request);

      // Save token
      await secureStorage.saveToken(response.token);
      await secureStorage.saveUserId(response.user.id);
      await secureStorage.saveUserEmail(response.user.email);
      await secureStorage.saveUserName(response.user.name);

      return Right({
        'user': response.user.toEntity(),
        'token': response.token,
      });
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
  Future<Either<Failure, void>> logout() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.logout();
      await secureStorage.clearAll();
      return const Right(null);
    } on UnauthorizedException {
      // Even if unauthorized, clear local storage
      await secureStorage.clearAll();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on UnauthorizedException catch (e) {
      await secureStorage.clearAll();
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
  Future<Either<Failure, User>> updateUser({
    String? name,
    String? email,
    String? timezone,
    String? language,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (timezone != null) data['timezone'] = timezone;
      if (language != null) data['language'] = language;

      final userModel = await remoteDataSource.updateUser(data);

      // Update local storage
      if (email != null) await secureStorage.saveUserEmail(email);
      if (name != null) await secureStorage.saveUserName(name);

      return Right(userModel.toEntity());
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
  Future<bool> isLoggedIn() async {
    return await secureStorage.hasToken();
  }
}
