// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceUpdateModel _$DeviceUpdateModelFromJson(Map<String, dynamic> json) =>
    DeviceUpdateModel(
      name: json['name'] as String,
      isActive: json['is_active'] as String,
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DeviceUpdateModelToJson(DeviceUpdateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'is_active': instance.isActive,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'description': instance.description,
    };
