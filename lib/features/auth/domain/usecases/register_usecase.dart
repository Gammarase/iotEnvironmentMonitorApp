import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Register use case
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String name,
    required String email,
    required String password,
    String? timezone,
    String? language,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      password: password,
      timezone: timezone,
      language: language,
    );
  }
}
