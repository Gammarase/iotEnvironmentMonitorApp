import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/models/paginated_response.dart';
import '../entities/recommendation.dart';

/// Recommendations repository interface
abstract class RecommendationsRepository {
  Future<Either<Failure, PaginatedResponse<Recommendation>>> getRecommendations({int page = 1});
  Future<Either<Failure, PaginatedResponse<Recommendation>>> getPendingRecommendations({int page = 1});
  Future<Either<Failure, Recommendation>> getRecommendationById(int id);
  Future<Either<Failure, Recommendation>> acknowledgeRecommendation(int id);
  Future<Either<Failure, Recommendation>> dismissRecommendation(int id);
}
