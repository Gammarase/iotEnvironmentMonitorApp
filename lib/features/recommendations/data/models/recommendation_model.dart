import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/recommendation.dart';

part 'recommendation_model.g.dart';

@JsonSerializable()
class RecommendationModel extends Recommendation {
  @JsonKey(name: 'device_id')
  final int modelDeviceId;
  @JsonKey(name: 'user_id')
  final int modelUserId;
  @JsonKey(name: 'acknowledged_at')
  final int? modelAcknowledgedAt;
  @JsonKey(name: 'dismissed_at')
  final int? modelDismissedAt;

  const RecommendationModel({
    required super.id,
    required this.modelDeviceId,
    required this.modelUserId,
    required super.type,
    required super.title,
    required super.message,
    required super.priority,
    required super.status,
    super.metadata,
    this.modelAcknowledgedAt,
    this.modelDismissedAt,
  }) : super(
          deviceId: modelDeviceId,
          userId: modelUserId,
          acknowledgedAt: modelAcknowledgedAt,
          dismissedAt: modelDismissedAt,
        );

  factory RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationModelToJson(this);

  Recommendation toEntity() {
    return Recommendation(
      id: id,
      deviceId: deviceId,
      userId: userId,
      type: type,
      title: title,
      message: message,
      priority: priority,
      status: status,
      metadata: metadata,
      acknowledgedAt: acknowledgedAt,
      dismissedAt: dismissedAt,
    );
  }
}
