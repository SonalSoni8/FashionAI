import 'package:flutter/foundation.dart';

@immutable
class UserProfileEntity {
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

  const UserProfileEntity({
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

  static const empty = UserProfileEntity(
    name: 'Alex Morgan',
    stylePreference: 'Quiet Luxury',
    faceShape: 'Angular Oval',
    skinTone: 'Warm Olive Level 3',
    undertone: 'Golden Warm',
    seasonPalette: 'Deep Autumn / Cool Winter',
    bestColors: ['#0F766E', '#4338CA', '#1E293B', '#BE123C'],
    worstColors: ['#D97706', '#FB7185'],
    bodyType: 'Athletic V-Shape',
    heightCm: 180.0,
    shoulderRatio: 1.25,
    isProfileComplete: true,
  );

  UserProfileEntity copyWith({
    String? name,
    String? stylePreference,
    String? faceShape,
    String? skinTone,
    String? undertone,
    String? seasonPalette,
    List<String>? bestColors,
    List<String>? worstColors,
    String? bodyType,
    double? heightCm,
    double? shoulderRatio,
    bool? isProfileComplete,
  }) {
    return UserProfileEntity(
      name: name ?? this.name,
      stylePreference: stylePreference ?? this.stylePreference,
      faceShape: faceShape ?? this.faceShape,
      skinTone: skinTone ?? this.skinTone,
      undertone: undertone ?? this.undertone,
      seasonPalette: seasonPalette ?? this.seasonPalette,
      bestColors: bestColors ?? this.bestColors,
      worstColors: worstColors ?? this.worstColors,
      bodyType: bodyType ?? this.bodyType,
      heightCm: heightCm ?? this.heightCm,
      shoulderRatio: shoulderRatio ?? this.shoulderRatio,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
