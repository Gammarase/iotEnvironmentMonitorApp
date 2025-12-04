import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? timezone;
  final String language;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.timezone,
    required this.language,
  });

  @override
  List<Object?> get props => [id, name, email, timezone, language];
}
