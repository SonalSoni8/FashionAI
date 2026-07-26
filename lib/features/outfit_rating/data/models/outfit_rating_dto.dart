import '../../domain/models/outfit_rating_entity.dart';

class OutfitRatingDto {
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
  final String createdAt;

  OutfitRatingDto({
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

  factory OutfitRatingDto.fromJson(Map<String, dynamic> json) {
    return OutfitRatingDto(
      overallScore: json['overall_score'] ?? 90,
      colorScore: json['color_score'] ?? 90,
      fitScore: json['fit_score'] ?? 90,
      occasionScore: json['occasion_score'] ?? 90,
      styleScore: json['style_score'] ?? 90,
      confidenceScore: json['confidence_score'] ?? 90,
      verdict: json['verdict'] ?? 'Quiet Luxury',
      reasoning: json['reasoning'] ?? '',
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      improvementTips: List<String>.from(json['improvement_tips'] ?? []),
      recommendedAccessories: List<String>.from(json['recommended_accessories'] ?? []),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  OutfitRatingEntity toDomain() {
    return OutfitRatingEntity(
      overallScore: overallScore,
      colorScore: colorScore,
      fitScore: fitScore,
      occasionScore: occasionScore,
      styleScore: styleScore,
      confidenceScore: confidenceScore,
      verdict: verdict,
      reasoning: reasoning,
      pros: pros,
      cons: cons,
      improvementTips: improvementTips,
      recommendedAccessories: recommendedAccessories,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
