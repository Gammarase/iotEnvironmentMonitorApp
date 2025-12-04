// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorReadingModel _$SensorReadingModelFromJson(Map<String, dynamic> json) =>
    SensorReadingModel(
      id: (json['id'] as num).toInt(),
      modelDeviceId: (json['device_id'] as num).toInt(),
      modelReadAt: (json['read_at'] as num).toInt(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
      tvoc: (json['tvoc'] as num).toDouble(),
    );

Map<String, dynamic> _$SensorReadingModelToJson(SensorReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'light': instance.light,
      'noise': instance.noise,
      'tvoc': instance.tvoc,
      'device_id': instance.modelDeviceId,
      'read_at': instance.modelReadAt,
    };
