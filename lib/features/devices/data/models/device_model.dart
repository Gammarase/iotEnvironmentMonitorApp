import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/device.dart';

part 'device_model.g.dart';

/// Device model (data layer)
@JsonSerializable()
class DeviceModel extends Device {
  @JsonKey(name: 'device_id')
  final String modelDeviceId;
  @JsonKey(name: 'user_id')
  final int modelUserId;
  @JsonKey(name: 'is_active')
  final bool modelIsActive;
  @JsonKey(name: 'last_seen_at')
  final int? modelLastSeenAt;

  const DeviceModel({
    required super.id,
    required this.modelDeviceId,
    required this.modelUserId,
    required super.name,
    super.latitude,
    super.longitude,
    super.description,
    required this.modelIsActive,
    this.modelLastSeenAt,
  }) : super(
          deviceId: modelDeviceId,
          userId: modelUserId,
          isActive: modelIsActive,
          lastSeenAt: modelLastSeenAt,
        );

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  Device toEntity() {
    return Device(
      id: id,
      deviceId: deviceId,
      userId: userId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      description: description,
      isActive: isActive,
      lastSeenAt: lastSeenAt,
    );
  }
}
