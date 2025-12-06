import 'package:json_annotation/json_annotation.dart';
import '../../../../core/utils/converters.dart';
import '../../domain/entities/sensor_reading.dart';

part 'sensor_reading_model.g.dart';

@JsonSerializable()
class SensorReadingModel extends SensorReading {
  @JsonKey(name: 'device_id')
  final int modelDeviceId;
  @JsonKey(name: 'reading_timestamp')
  final int modelReadAt;
  @JsonKey(name: 'tvoc_ppm')
  final double modelTvoc;
  @JsonKey(name: 'temperature', fromJson: Converters.decimalStringToFloat)
  final double modelTemperature;
  @JsonKey(name: 'humidity', fromJson: Converters.decimalStringToFloat)
  final double modelHumidity;

  const SensorReadingModel({
    required super.id,
    required this.modelDeviceId,
    required this.modelReadAt,
    required this.modelTvoc,
    required this.modelTemperature,
    required this.modelHumidity,
    required super.light,
    required super.noise,

  }) : super(
          deviceId: modelDeviceId,
          readAt: modelReadAt,
          tvoc: modelTvoc,
          temperature: modelTemperature,
          humidity: modelHumidity
        );

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) =>
      _$SensorReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SensorReadingModelToJson(this);

  SensorReading toEntity() {
    return SensorReading(
      id: id,
      deviceId: deviceId,
      readAt: readAt,
      temperature: temperature,
      humidity: humidity,
      light: light,
      noise: noise,
      tvoc: tvoc,
    );
  }
}
