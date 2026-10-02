import 'package:flutter/foundation.dart';

@immutable
class ColourRecommendationItem {
  final String name;
  final String hex;
  final String explanation;
  final String category; // 'Power Color', 'Avoid Color', 'Metal', 'Hair', 'Makeup'

  const ColourRecommendationItem({
    required this.name,
    required this.hex,
    required this.explanation,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hex': hex,
      'explanation': explanation,
      'category': category,
    };
  }

  factory ColourRecommendationItem.fromJson(Map<String, dynamic> json) {
    return ColourRecommendationItem(
      name: json['name'] ?? '',
      hex: json['hex'] ?? '#000000',
      explanation: json['explanation'] ?? '',
      category: json['category'] ?? 'Power Color',
    );
  }
}
