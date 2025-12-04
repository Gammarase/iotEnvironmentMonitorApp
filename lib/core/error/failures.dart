import 'package:equatable/equatable.dart';

/// Base failure class for all domain-level errors
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
      : super(message);
}

/// Authentication-related failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed'])
      : super(message);
}

/// Validation failures with field-specific errors
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure(
    this.errors, [
    String message = 'Validation failed',
  ]) : super(message);

  @override
  List<Object> get props => [message, errors];
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

/// Not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
}

/// Forbidden failures (403)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([String message = 'Access forbidden']) : super(message);
}
