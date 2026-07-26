import 'package:flutter/foundation.dart';

@immutable
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isProfileComplete;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.isProfileComplete = false,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isProfileComplete,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
