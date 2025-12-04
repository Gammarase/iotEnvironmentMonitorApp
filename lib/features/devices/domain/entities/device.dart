import 'package:equatable/equatable.dart';

/// Device entity
class Device extends Equatable {
  final int id;
  final String deviceId;
  final int userId;
  final String name;
  final String? latitude;
  final String? longitude;
  final String? description;
  final bool isActive;
  final int? lastSeenAt;

  const Device({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.name,
    this.latitude,
    this.longitude,
    this.description,
    required this.isActive,
    this.lastSeenAt,
  });

  @override
  List<Object?> get props => [
        id,
        deviceId,
        userId,
        name,
        latitude,
        longitude,
        description,
        isActive,
        lastSeenAt,
      ];
}
