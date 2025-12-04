import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    String? timezone,
    required String language,
  }) async {
    return await repository.updateProfile(
      name: name,
      timezone: timezone,
      language: language,
    );
  }
}
