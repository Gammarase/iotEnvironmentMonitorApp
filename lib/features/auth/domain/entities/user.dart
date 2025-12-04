import 'package:equatable/equatable.dart';

/// User entity (domain model)
class User extends Equatable {
  final int id;
  final String email;
  final String name;
  final String timezone;
  final String language;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.timezone,
    required this.language,
  });

  @override
  List<Object?> get props => [id, email, name, timezone, language];
}
