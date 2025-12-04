// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequestModel _$RegisterRequestModelFromJson(
  Map<String, dynamic> json,
) => RegisterRequestModel(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  timezone: json['timezone'] as String?,
  language: json['language'] as String?,
);

Map<String, dynamic> _$RegisterRequestModelToJson(
  RegisterRequestModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'timezone': instance.timezone,
  'language': instance.language,
};
