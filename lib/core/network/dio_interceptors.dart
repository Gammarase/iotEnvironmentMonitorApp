import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../error/exceptions.dart';

/// Auth interceptor to add Bearer token to requests
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    final token = await _secureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Clear stored token
      _secureStorage.deleteToken();
    }

    handler.next(err);
  }
}

/// Error interceptor to convert HTTP errors to custom exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = NetworkException('Connection timeout');
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;

        if (statusCode == 401) {
          exception = UnauthorizedException(
            responseData?['message'] ?? 'Unauthorized',
          );
        } else if (statusCode == 403) {
          exception = ForbiddenException(
            responseData?['message'] ?? 'Access forbidden',
          );
        } else if (statusCode == 404) {
          exception = NotFoundException(
            responseData?['message'] ?? 'Resource not found',
          );
        } else if (statusCode == 422) {
          exception = ValidationException(
            responseData?['errors'] ?? {},
          );
        } else if (statusCode != null && statusCode >= 500) {
          exception = ServerException(
            message: responseData?['message'] ?? 'Server error',
            statusCode: statusCode,
          );
        } else {
          exception = ServerException(
            message: responseData?['message'] ?? 'An error occurred',
            statusCode: statusCode,
          );
        }
        break;

      case DioExceptionType.cancel:
        exception = Exception('Request cancelled');
        break;

      case DioExceptionType.unknown:
        if (err.error?.toString().contains('SocketException') ?? false) {
          exception = NetworkException('No internet connection');
        } else {
          exception = NetworkException('Unknown network error');
        }
        break;

      default:
        exception = Exception('Unexpected error occurred');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }
}
