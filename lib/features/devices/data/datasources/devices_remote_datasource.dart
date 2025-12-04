import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../shared/models/paginated_response.dart';
import '../models/device_model.dart';
import '../models/device_create_model.dart';
import '../models/device_update_model.dart';

/// Devices remote data source
abstract class DevicesRemoteDataSource {
  Future<PaginatedResponse<DeviceModel>> getDevices({int page = 1});
  Future<DeviceModel> getDeviceById(int id);
  Future<DeviceModel> createDevice(DeviceCreateModel model);
  Future<DeviceModel> updateDevice(int id, DeviceUpdateModel model);
  Future<void> deleteDevice(int id);
}

/// Implementation of devices remote data source
class DevicesRemoteDataSourceImpl implements DevicesRemoteDataSource {
  final ApiClient apiClient;

  DevicesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedResponse<DeviceModel>> getDevices({int page = 1}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.devices,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        return PaginatedResponse.fromJson(
          response.data,
          (json) => DeviceModel.fromJson(json),
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get devices',
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
  Future<DeviceModel> getDeviceById(int id) async {
    try {
      final response = await apiClient.get(ApiEndpoints.deviceById(id));

      if (response.statusCode == 200) {
        return DeviceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get device',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is NotFoundException ||
          e is ForbiddenException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DeviceModel> createDevice(DeviceCreateModel model) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.devices,
        data: model.toJson(),
      );

      if (response.statusCode == 201) {
        return DeviceModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create device',
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
  Future<DeviceModel> updateDevice(int id, DeviceUpdateModel model) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.deviceById(id),
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        return DeviceModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update device',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is NotFoundException ||
          e is ForbiddenException ||
          e is ValidationException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDevice(int id) async {
    try {
      final response = await apiClient.delete(ApiEndpoints.deviceById(id));

      if (response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete device',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException ||
          e is UnauthorizedException ||
          e is NotFoundException ||
          e is ForbiddenException ||
          e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
}
