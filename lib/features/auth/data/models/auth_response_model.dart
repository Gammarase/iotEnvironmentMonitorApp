import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

/// Auth response model (for login and register)
@JsonSerializable()
class AuthResponseModel {
  final UserModel user;
  final String token;

  const AuthResponseModel({
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
