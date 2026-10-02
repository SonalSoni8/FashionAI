import 'package:flutter/foundation.dart';
import 'colour_recommendation_item.dart';

@immutable
class ColourPassportEntity {
  final String skinToneName;
  final String skinToneHex;
  final String undertone;
  final String seasonPalette;
  final String contrastLevel; // High, Medium, Soft
  final String colourHarmonyStrategy;

  final List<ColourRecommendationItem> bestColours;
  final List<ColourRecommendationItem> worstColours;
  final List<ColourRecommendationItem> bestMetals;
  final List<ColourRecommendationItem> bestHairColours;
  final List<ColourRecommendationItem> bestMakeupColours;

  const ColourPassportEntity({
    required this.skinToneName,
    required this.skinToneHex,
    required this.undertone,
    required this.seasonPalette,
    required this.contrastLevel,
    required this.colourHarmonyStrategy,
    required this.bestColours,
    required this.worstColours,
    required this.bestMetals,
    required this.bestHairColours,
    required this.bestMakeupColours,
  });

  Map<String, dynamic> toJson() {
    return {
      'skin_tone_name': skinToneName,
      'skin_tone_hex': skinToneHex,
      'undertone': undertone,
      'season_palette': seasonPalette,
      'contrast_level': contrastLevel,
      'colour_harmony_strategy': colourHarmonyStrategy,
      'best_colours': bestColours.map((e) => e.toJson()).toList(),
      'worst_colours': worstColours.map((e) => e.toJson()).toList(),
      'best_metals': bestMetals.map((e) => e.toJson()).toList(),
      'best_hair_colours': bestHairColours.map((e) => e.toJson()).toList(),
      'best_makeup_colours': bestMakeupColours.map((e) => e.toJson()).toList(),
    };
  }

  factory ColourPassportEntity.fromJson(Map<String, dynamic> json) {
    return ColourPassportEntity(
      skinToneName: json['skin_tone_name'] ?? 'Warm Olive Level 3',
      skinToneHex: json['skin_tone_hex'] ?? '#D4A373',
      undertone: json['undertone'] ?? 'Golden Warm Olive',
      seasonPalette: json['season_palette'] ?? 'Deep Autumn / Cool Winter',
      contrastLevel: json['contrast_level'] ?? 'High Saturation Contrast (88/100)',
      colourHarmonyStrategy: json['colour_harmony_strategy'] ??
          'Split-Complementary & Monochromatic Jewel Tones',
      bestColours: (json['best_colours'] as List? ?? [])
          .map((e) => ColourRecommendationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      worstColours: (json['worst_colours'] as List? ?? [])
          .map((e) => ColourRecommendationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      bestMetals: (json['best_metals'] as List? ?? [])
          .map((e) => ColourRecommendationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      bestHairColours: (json['best_hair_colours'] as List? ?? [])
          .map((e) => ColourRecommendationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      bestMakeupColours: (json['best_makeup_colours'] as List? ?? [])
          .map((e) => ColourRecommendationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
