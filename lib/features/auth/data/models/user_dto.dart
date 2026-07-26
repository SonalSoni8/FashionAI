import '../../domain/models/user_entity.dart';

class UserDto {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
    };
  }

  UserEntity toDomain() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
    );
  }
}
