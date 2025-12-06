// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorReadingModel _$SensorReadingModelFromJson(Map<String, dynamic> json) =>
    SensorReadingModel(
      id: (json['id'] as num).toInt(),
      modelDeviceId: (json['device_id'] as num).toInt(),
      modelReadAt: (json['reading_timestamp'] as num).toInt(),
      modelTvoc: (json['tvoc_ppm'] as num).toDouble(),
      modelTemperature: Converters.decimalStringToFloat(json['temperature']),
      modelHumidity: Converters.decimalStringToFloat(json['humidity']),
      light: (json['light'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
    );

Map<String, dynamic> _$SensorReadingModelToJson(SensorReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'light': instance.light,
      'noise': instance.noise,
      'device_id': instance.modelDeviceId,
      'reading_timestamp': instance.modelReadAt,
      'tvoc_ppm': instance.modelTvoc,
      'temperature': instance.modelTemperature,
      'humidity': instance.modelHumidity,
    };
