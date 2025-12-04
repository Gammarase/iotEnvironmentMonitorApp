import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Update user use case
class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, User>> call({
    String? name,
    String? email,
    String? timezone,
    String? language,
  }) async {
    return await repository.updateUser(
      name: name,
      email: email,
      timezone: timezone,
      language: language,
    );
  }
}
