import 'package:flutter/foundation.dart';

@immutable
class OutfitRatingEntity {
  final int overallScore;
  final int colorScore;
  final int fitScore;
  final int occasionScore;
  final int styleScore;
  final int confidenceScore;
  final String verdict;
  final String reasoning;
  final List<String> pros;
  final List<String> cons;
  final List<String> improvementTips;
  final List<String> recommendedAccessories;
  final DateTime createdAt;

  const OutfitRatingEntity({
    required this.overallScore,
    required this.colorScore,
    required this.fitScore,
    required this.occasionScore,
    required this.styleScore,
    required this.confidenceScore,
    required this.verdict,
    required this.reasoning,
    required this.pros,
    required this.cons,
    required this.improvementTips,
    required this.recommendedAccessories,
    required this.createdAt,
  });

  static OutfitRatingEntity mock = OutfitRatingEntity(
    overallScore: 94,
    colorScore: 96,
    fitScore: 91,
    occasionScore: 95,
    styleScore: 93,
    confidenceScore: 92,
    verdict: "Sophisticated Quiet Luxury",
    reasoning:
        "The monochromatic dark charcoal blazer paired with off-white linen creates high visual elongation. The unstructured shoulder contour balances your athletic V-shape profile seamlessly.",
    pros: [
      "High color contrast elevates facial focal point",
      "Monochromatic trousers create vertical elongation",
      "Linen texture adds dimensional richness",
    ],
    cons: [
      "Trouser hem length sits slightly low near shoe collar",
    ],
    improvementTips: [
      "Swap belt for a silver-buckle minimalist leather piece",
      "Roll jacket cuffs slightly to show wrist bone and watch accent",
    ],
    recommendedAccessories: [
      "Brushed silver mechanical chronograph watch",
      "Matte black acetate sunglasses",
      "Leather slim document pouch",
    ],
    createdAt: DateTime.now(),
  );
}
