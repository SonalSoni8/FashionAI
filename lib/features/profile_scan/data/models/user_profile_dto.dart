import '../../domain/models/user_profile_entity.dart';

class UserProfileDto {
  final String name;
  final String stylePreference;
  final String faceShape;
  final String skinTone;
  final String undertone;
  final String seasonPalette;
  final List<String> bestColors;
  final List<String> worstColors;
  final String bodyType;
  final double heightCm;
  final double shoulderRatio;
  final bool isProfileComplete;

  UserProfileDto({
    required this.name,
    required this.stylePreference,
    required this.faceShape,
    required this.skinTone,
    required this.undertone,
    required this.seasonPalette,
    required this.bestColors,
    required this.worstColors,
    required this.bodyType,
    required this.heightCm,
    required this.shoulderRatio,
    required this.isProfileComplete,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      name: json['name'] ?? 'Alex Morgan',
      stylePreference: json['style_preference'] ?? 'Quiet Luxury',
      faceShape: json['face_shape'] ?? 'Angular Oval',
      skinTone: json['skin_tone'] ?? 'Warm Olive Level 3',
      undertone: json['undertone'] ?? 'Golden Warm',
      seasonPalette: json['season_palette'] ?? 'Deep Autumn / Cool Winter',
      bestColors: List<String>.from(json['best_colors'] ?? []),
      worstColors: List<String>.from(json['worst_colors'] ?? []),
      bodyType: json['body_type'] ?? 'Athletic V-Shape',
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 180.0,
      shoulderRatio: (json['shoulder_ratio'] as num?)?.toDouble() ?? 1.25,
      isProfileComplete: json['is_profile_complete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'style_preference': stylePreference,
      'face_shape': faceShape,
      'skin_tone': skinTone,
      'undertone': undertone,
      'season_palette': seasonPalette,
      'best_colors': bestColors,
      'worst_colors': worstColors,
      'body_type': bodyType,
      'height_cm': heightCm,
      'shoulder_ratio': shoulderRatio,
      'is_profile_complete': isProfileComplete,
    };
  }

  UserProfileEntity toDomain() {
    return UserProfileEntity(
      name: name,
      stylePreference: stylePreference,
      faceShape: faceShape,
      skinTone: skinTone,
      undertone: undertone,
      seasonPalette: seasonPalette,
      bestColors: bestColors,
      worstColors: worstColors,
      bodyType: bodyType,
      heightCm: heightCm,
      shoulderRatio: shoulderRatio,
      isProfileComplete: isProfileComplete,
    );
  }

  factory UserProfileDto.fromDomain(UserProfileEntity entity) {
    return UserProfileDto(
      name: entity.name,
      stylePreference: entity.stylePreference,
      faceShape: entity.faceShape,
      skinTone: entity.skinTone,
      undertone: entity.undertone,
      seasonPalette: entity.seasonPalette,
      bestColors: entity.bestColors,
      worstColors: entity.worstColors,
      bodyType: entity.bodyType,
      heightCm: entity.heightCm,
      shoulderRatio: entity.shoulderRatio,
      isProfileComplete: entity.isProfileComplete,
    );
  }
}
