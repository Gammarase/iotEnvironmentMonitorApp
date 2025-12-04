import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Auth repository interface (domain layer)
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    String? timezone,
    String? language,
  });

  /// Logout user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Update user profile
  Future<Either<Failure, User>> updateUser({
    String? name,
    String? email,
    String? timezone,
    String? language,
  });

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
