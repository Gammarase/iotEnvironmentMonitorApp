import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/models/paginated_response.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendations_repository.dart';

class GetPendingRecommendationsUseCase {
  final RecommendationsRepository repository;

  GetPendingRecommendationsUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<Recommendation>>> call({int page = 1}) async {
    return await repository.getPendingRecommendations(page: page);
  }
}
