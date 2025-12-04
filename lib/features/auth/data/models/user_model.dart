import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model (data layer) - JSON serializable
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.timezone,
    required super.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      timezone: timezone,
      language: language,
    );
  }
}
