import 'package:flutter/foundation.dart';
import 'colour_distribution_item.dart';

@immutable
class WardrobeAnalyticsEntity {
  final int closetScore; // 0 to 100
  final int confidenceScore; // 0 to 100%
  final int outfitVarietyCount; // e.g. 142 unique outfits
  final int unusedClothesCount;
  final List<String> unusedItemNames;
  final String styleEvolutionStage; // e.g. "Quiet Luxury Tier 4"
  final double styleEvolutionProgress; // 0.0 to 1.0

  final List<ColourDistributionItem> colourBalance;
  final Map<String, double> seasonReadiness; // 'Spring/Summer': 94%, etc.
  final Map<String, double> favouriteBrands; // 'Atelier Sartorial': 40%, etc.
  final List<String> shoppingSuggestions;

  const WardrobeAnalyticsEntity({
    required this.closetScore,
    required this.confidenceScore,
    required this.outfitVarietyCount,
    required this.unusedClothesCount,
    required this.unusedItemNames,
    required this.styleEvolutionStage,
    required this.styleEvolutionProgress,
    required this.colourBalance,
    required this.seasonReadiness,
    required this.favouriteBrands,
    required this.shoppingSuggestions,
  });
}
