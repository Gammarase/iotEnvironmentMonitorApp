import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/models/paginated_response.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_remote_datasource.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RecommendationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedResponse<Recommendation>>> getRecommendations({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getRecommendations(page: page);
      final recommendations = PaginatedResponse<Recommendation>(
        data: result.data.map((model) => model.toEntity()).toList(),
        links: result.links,
        meta: result.meta,
      );
      return Right(recommendations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<Recommendation>>> getPendingRecommendations({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getPendingRecommendations(page: page);
      final recommendations = PaginatedResponse<Recommendation>(
        data: result.data.map((model) => model.toEntity()).toList(),
        links: result.links,
        meta: result.meta,
      );
      return Right(recommendations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recommendation>> getRecommendationById(int id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.getRecommendationById(id);
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
  Future<Either<Failure, Recommendation>> acknowledgeRecommendation(int id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.acknowledgeRecommendation(id);
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
  Future<Either<Failure, Recommendation>> dismissRecommendation(int id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final result = await remoteDataSource.dismissRecommendation(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(AuthenticationFailure('Session expired'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
