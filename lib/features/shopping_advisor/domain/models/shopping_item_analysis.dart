import 'package:flutter/foundation.dart';

enum VerdictType { buy, skip }

@immutable
class ShoppingItemAnalysis {
  final String itemName;
  final String category;
  final String brandName;
  final String priceEstimate;
  final VerdictType verdict;
  final double verdictScore; // 0 to 100%

  // Explanations
  final bool matchesSkinTone;
  final String skinToneExplanation;

  final bool matchesWardrobe;
  final String wardrobeExplanation;

  final int newOutfitsCreatedCount;
  final String newOutfitsExplanation;

  final double valueForMoneyScore; // 0.0 to 10.0
  final String valueForMoneyExplanation;

  final String alternativeColourName;
  final String alternativeColourHex;
  final String alternativeColourExplanation;

  final String alternativeBrandName;
  final String alternativeBrandExplanation;

  const ShoppingItemAnalysis({
    required this.itemName,
    required this.category,
    required this.brandName,
    required this.priceEstimate,
    required this.verdict,
    required this.verdictScore,
    required this.matchesSkinTone,
    required this.skinToneExplanation,
    required this.matchesWardrobe,
    required this.wardrobeExplanation,
    required this.newOutfitsCreatedCount,
    required this.newOutfitsExplanation,
    required this.valueForMoneyScore,
    required this.valueForMoneyExplanation,
    required this.alternativeColourName,
    required this.alternativeColourHex,
    required this.alternativeColourExplanation,
    required this.alternativeBrandName,
    required this.alternativeBrandExplanation,
  });

  bool get isBuy => verdict == VerdictType.buy;
}
