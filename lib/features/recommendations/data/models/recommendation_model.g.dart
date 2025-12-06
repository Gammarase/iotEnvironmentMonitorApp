// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationModel _$RecommendationModelFromJson(Map<String, dynamic> json) =>
    RecommendationModel(
      id: (json['id'] as num).toInt(),
      modelDeviceId: (json['device_id'] as num).toInt(),
      modelUserId: (json['user_id'] as num).toInt(),
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      modelAcknowledgedAt: (json['acknowledged_at'] as num?)?.toInt(),
      modelDismissedAt: (json['dismissed_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommendationModelToJson(
  RecommendationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'message': instance.message,
  'priority': instance.priority,
  'status': instance.status,
  'metadata': instance.metadata,
  'device_id': instance.modelDeviceId,
  'user_id': instance.modelUserId,
  'acknowledged_at': instance.modelAcknowledgedAt,
  'dismissed_at': instance.modelDismissedAt,
};
