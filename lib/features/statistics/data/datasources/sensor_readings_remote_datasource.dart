import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/sensor_reading_model.dart';

abstract class SensorReadingsRemoteDataSource {
  Future<SensorReadingModel> getCurrentReading({required int deviceId});
  Future<List<SensorReadingModel>> getReadingsHistory({
    required int deviceId,
    required String startDate,
    required String endDate,
  });
}

class SensorReadingsRemoteDataSourceImpl implements SensorReadingsRemoteDataSource {
  final ApiClient apiClient;

  SensorReadingsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SensorReadingModel> getCurrentReading({required int deviceId}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.currentReadings,
        queryParameters: {'device_id': deviceId},
      );

      return SensorReadingModel.fromJson(response.data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SensorReadingModel>> getReadingsHistory({
    required int deviceId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.readingsHistory,
        queryParameters: {
          'device_id': deviceId,
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      final List<dynamic> data = response.data['data'];
      return data.map((json) => SensorReadingModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
