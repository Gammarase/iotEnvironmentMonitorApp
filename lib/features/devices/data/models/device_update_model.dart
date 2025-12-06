import 'package:json_annotation/json_annotation.dart';

part 'device_update_model.g.dart';

/// Device update request model
@JsonSerializable()
class DeviceUpdateModel {
  final String name;
  @JsonKey(name: 'is_active')
  final bool isActive; // API expects string "true" or "false"
  final double? longitude;
  final double? latitude;
  final String? description;

  const DeviceUpdateModel({
    required this.name,
    required this.isActive,
    this.longitude,
    this.latitude,
    this.description,
  });

  factory DeviceUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceUpdateModelToJson(this);
}
