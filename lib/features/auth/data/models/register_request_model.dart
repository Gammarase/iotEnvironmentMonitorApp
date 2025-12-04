import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

/// Register request model
@JsonSerializable()
class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String? timezone;
  final String? language;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    this.timezone,
    this.language,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
