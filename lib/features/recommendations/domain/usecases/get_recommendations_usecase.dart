import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/models/paginated_response.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendations_repository.dart';

class GetRecommendationsUseCase {
  final RecommendationsRepository repository;

  GetRecommendationsUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<Recommendation>>> call({int page = 1}) async {
    return await repository.getRecommendations(page: page);
  }
}
