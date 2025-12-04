import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? timezone,
    required String language,
  });
}
