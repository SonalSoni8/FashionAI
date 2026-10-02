import 'package:flutter/foundation.dart';
import 'ai_learning_vector.dart';
import 'fashion_history_log.dart';

@immutable
class AuraDnaEntity {
  final String userName;
  final String twinId;
  final double heightCm;
  final String bodyShape;
  final String skinToneName;
  final String skinToneHex;
  final String seasonalPalette;
  final int wardrobeItemCount;
  final double closetVersatilityScore;
  final List<String> favouriteBrands;
  final List<String> favouriteColours;
  final List<String> favouriteFits;
  final String shoppingBehaviour;
  final String stylePersonality;
  final int confidenceScore;
  final String fashionEvolutionStage;
  final List<FashionHistoryLog> outfitHistory;
  final List<FashionHistoryLog> shoppingHistory;
  final AiLearningVector aiLearning;

  const AuraDnaEntity({
    required this.userName,
    required this.twinId,
    required this.heightCm,
    required this.bodyShape,
    required this.skinToneName,
    required this.skinToneHex,
    required this.seasonalPalette,
    required this.wardrobeItemCount,
    required this.closetVersatilityScore,
    required this.favouriteBrands,
    required this.favouriteColours,
    required this.favouriteFits,
    required this.shoppingBehaviour,
    required this.stylePersonality,
    required this.confidenceScore,
    required this.fashionEvolutionStage,
    required this.outfitHistory,
    required this.shoppingHistory,
    required this.aiLearning,
  });
}
