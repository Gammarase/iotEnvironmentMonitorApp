import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/sensor_reading.dart';

part 'sensor_reading_model.g.dart';

@JsonSerializable()
class SensorReadingModel extends SensorReading {
  @JsonKey(name: 'device_id')
  final int modelDeviceId;
  @JsonKey(name: 'read_at')
  final int modelReadAt;

  const SensorReadingModel({
    required super.id,
    required this.modelDeviceId,
    required this.modelReadAt,
    required super.temperature,
    required super.humidity,
    required super.light,
    required super.noise,
    required super.tvoc,
  }) : super(
          deviceId: modelDeviceId,
          readAt: modelReadAt,
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
