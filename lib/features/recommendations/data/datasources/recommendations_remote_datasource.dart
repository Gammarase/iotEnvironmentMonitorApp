import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../models/recommendation_model.dart';

abstract class RecommendationsRemoteDataSource {
  Future<PaginatedResponse<RecommendationModel>> getRecommendations({int page = 1});
  Future<PaginatedResponse<RecommendationModel>> getPendingRecommendations({int page = 1});
  Future<RecommendationModel> getRecommendationById(int id);
  Future<RecommendationModel> acknowledgeRecommendation(int id);
  Future<RecommendationModel> dismissRecommendation(int id);
}

class RecommendationsRemoteDataSourceImpl implements RecommendationsRemoteDataSource {
  final ApiClient apiClient;

  RecommendationsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedResponse<RecommendationModel>> getRecommendations({int page = 1}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.recommendations,
        queryParameters: {'page': page},
      );

      return PaginatedResponse<RecommendationModel>.fromJson(
        response.data,
        (json) => RecommendationModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaginatedResponse<RecommendationModel>> getPendingRecommendations({int page = 1}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.pendingRecommendations,
        queryParameters: {'page': page},
      );

      return PaginatedResponse<RecommendationModel>.fromJson(
        response.data,
        (json) => RecommendationModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RecommendationModel> getRecommendationById(int id) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.recommendations}/$id',
      );

      return RecommendationModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RecommendationModel> acknowledgeRecommendation(int id) async {
    try {
      final response = await apiClient.patch(
        ApiEndpoints.acknowledgeRecommendation,
        data: {'id': id},
      );

      return RecommendationModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RecommendationModel> dismissRecommendation(int id) async {
    try {
      final response = await apiClient.patch(
        ApiEndpoints.dismissRecommendation,
        data: {'id': id},
      );

      return RecommendationModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
