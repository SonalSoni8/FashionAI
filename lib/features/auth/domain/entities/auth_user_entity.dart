import 'package:flutter/foundation.dart';

@immutable
class AuthUserEntity {
  final String id;
  final String email;
  final String displayName;
  final String handle;
  final String gender; // 'female', 'male', 'unisex'
  final String preferredStylePersona; // 'Quiet Luxury', 'Streetwear', 'Minimalist', 'Classic'
  final double heightCm;
  final String photoUrl;
  final bool isAuthenticated;
  final bool hasCompletedProfile;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    required this.handle,
    required this.gender,
    required this.preferredStylePersona,
    this.heightCm = 180.0,
    required this.photoUrl,
    required this.isAuthenticated,
    required this.hasCompletedProfile,
  });

  AuthUserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? handle,
    String? gender,
    String? preferredStylePersona,
    double? heightCm,
    String? photoUrl,
    bool? isAuthenticated,
    bool? hasCompletedProfile,
  }) {
    return AuthUserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      handle: handle ?? this.handle,
      gender: gender ?? this.gender,
      preferredStylePersona:
          preferredStylePersona ?? this.preferredStylePersona,
      heightCm: heightCm ?? this.heightCm,
      photoUrl: photoUrl ?? this.photoUrl,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasCompletedProfile:
          hasCompletedProfile ?? this.hasCompletedProfile,
    );
  }
}
