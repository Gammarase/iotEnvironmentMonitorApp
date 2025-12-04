import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendations_repository.dart';

class DismissRecommendationUseCase {
  final RecommendationsRepository repository;

  DismissRecommendationUseCase(this.repository);

  Future<Either<Failure, Recommendation>> call(int id) async {
    return await repository.dismissRecommendation(id);
  }
}
