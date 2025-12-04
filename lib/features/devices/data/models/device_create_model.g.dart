// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceCreateModel _$DeviceCreateModelFromJson(Map<String, dynamic> json) =>
    DeviceCreateModel(
      deviceId: json['device_id'] as String,
      name: json['name'] as String,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DeviceCreateModelToJson(DeviceCreateModel instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'name': instance.name,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'description': instance.description,
    };
