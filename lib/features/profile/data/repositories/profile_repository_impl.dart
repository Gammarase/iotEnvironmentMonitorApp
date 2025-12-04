import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthRepository authRepository;

  ProfileRepositoryImpl({required this.authRepository});

  @override
  Future<Either<Failure, User>> getProfile() async {
    return await authRepository.getCurrentUser();
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? timezone,
    required String language,
  }) async {
    return await authRepository.updateUser(
      name: name,
      timezone: timezone,
      language: language,
    );
  }
}
