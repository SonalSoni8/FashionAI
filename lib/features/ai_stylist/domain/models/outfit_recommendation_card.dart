import 'package:flutter/foundation.dart';

@immutable
class OutfitRecommendationCard {
  final String title;
  final String description;
  final String matchPercentage; // e.g. "98% Match"
  final String topItem;
  final String bottomItem;
  final String outerwearItem;
  final String footwearItem;
  final String accessoryItem;
  final String formality; // Casual, Smart Casual, Business Formal, Black Tie
  final List<String> colorPaletteHexes;

  const OutfitRecommendationCard({
    required this.title,
    required this.description,
    required this.matchPercentage,
    required this.topItem,
    required this.bottomItem,
    this.outerwearItem = '',
    required this.footwearItem,
    this.accessoryItem = '',
    required this.formality,
    required this.colorPaletteHexes,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'matchPercentage': matchPercentage,
      'topItem': topItem,
      'bottomItem': bottomItem,
      'outerwearItem': outerwearItem,
      'footwearItem': footwearItem,
      'accessoryItem': accessoryItem,
      'formality': formality,
      'colorPaletteHexes': colorPaletteHexes,
    };
  }

  factory OutfitRecommendationCard.fromJson(Map<String, dynamic> json) {
    return OutfitRecommendationCard(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      matchPercentage: json['matchPercentage'] ?? '98% Match',
      topItem: json['topItem'] ?? '',
      bottomItem: json['bottomItem'] ?? '',
      outerwearItem: json['outerwearItem'] ?? '',
      footwearItem: json['footwearItem'] ?? '',
      accessoryItem: json['accessoryItem'] ?? '',
      formality: json['formality'] ?? 'Smart Casual',
      colorPaletteHexes: (json['colorPaletteHexes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
