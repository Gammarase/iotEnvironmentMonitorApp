// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  id: (json['id'] as num).toInt(),
  modelDeviceId: json['device_id'] as String,
  modelUserId: (json['user_id'] as num).toInt(),
  name: json['name'] as String,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  description: json['description'] as String?,
  modelIsActive: json['is_active'] as bool,
  modelLastSeenAt: (json['last_seen_at'] as num?)?.toInt(),
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'device_id': instance.modelDeviceId,
      'user_id': instance.modelUserId,
      'is_active': instance.modelIsActive,
      'last_seen_at': instance.modelLastSeenAt,
    };
