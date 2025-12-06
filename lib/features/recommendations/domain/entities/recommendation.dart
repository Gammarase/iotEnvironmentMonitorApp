import 'package:equatable/equatable.dart';

/// Recommendation entity
class Recommendation extends Equatable {
  final int id;
  final int deviceId;
  final int userId;
  final String type; // ventilate, lighting, noise, break, temperature, humidity
  final String title;
  final String message;
  final String priority; // low, medium, high
  final String status; // pending, acknowledged, dismissed
  final Map<String, dynamic>? metadata;
  final int? acknowledgedAt;
  final int? dismissedAt;

  const Recommendation({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    required this.status,
    this.metadata,
    this.acknowledgedAt,
    this.dismissedAt,
  });

  bool get isPending => status == 'pending';
  bool get isAcknowledged => status == 'acknowledged';
  bool get isDismissed => status == 'dismissed';

  @override
  List<Object?> get props => [
        id,
        deviceId,
        userId,
        type,
        title,
        message,
        priority,
        status,
        metadata,
        acknowledgedAt,
        dismissedAt,
      ];
}
