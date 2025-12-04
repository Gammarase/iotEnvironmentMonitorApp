import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

/// Auth remote data source
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(Map<String, dynamic> data);
}

/// Implementation of auth remote data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is ValidationException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is ValidationException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await apiClient.delete(ApiEndpoints.logout);

      if (response.statusCode != 204) {
        throw ServerException(
          message: 'Logout failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiEndpoints.getUser);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get user',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.patch(
        ApiEndpoints.updateUser,
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update user',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is ValidationException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
}
