import 'package:json_annotation/json_annotation.dart';

part 'device_create_model.g.dart';

/// Device create request model
@JsonSerializable()
class DeviceCreateModel {
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String name;
  final double? longitude;
  final double? latitude;
  final String? description;

  const DeviceCreateModel({
    required this.deviceId,
    required this.name,
    this.longitude,
    this.latitude,
    this.description,
  });

  factory DeviceCreateModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCreateModelToJson(this);
}
