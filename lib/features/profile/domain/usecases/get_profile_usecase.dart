import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.getProfile();
  }
}
