/// Base exception for server errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    this.message = 'Server error',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Network connectivity exception
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Unauthorized/authentication exception (401)
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = 'Unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Validation exception (422)
class ValidationException implements Exception {
  final Map<String, dynamic> errors;

  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}

/// Not found exception (404)
class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Forbidden exception (403)
class ForbiddenException implements Exception {
  final String message;

  ForbiddenException([this.message = 'Access forbidden']);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Cache exception
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error']);

  @override
  String toString() => 'CacheException: $message';
}
