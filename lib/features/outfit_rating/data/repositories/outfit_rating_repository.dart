import '../../../../core/errors/failure.dart';
import '../../../../core/ai/i_ai_stylist_service.dart';
import '../../domain/models/outfit_rating_entity.dart';
import '../../domain/repositories/i_outfit_rating_repository.dart';

class OutfitRatingRepository implements IOutfitRatingRepository {
  final IAiStylistService _aiStylistService;

  OutfitRatingRepository(this._aiStylistService);

  @override
  Future<Result<OutfitRatingEntity>> analyzeOutfitPhoto({
    required String imagePath,
    String? occasion,
  }) async {
    try {
      final aiResult = await _aiStylistService.analyzeOutfit(
        imagePath: imagePath,
        occasion: occasion,
      );

      return aiResult.fold(
        onSuccess: (data) {
          final entity = OutfitRatingEntity(
            overallScore: data['overallScore'] ?? 92,
            colorScore: data['colorScore'] ?? 94,
            fitScore: data['fitScore'] ?? 90,
            occasionScore: data['occasionScore'] ?? 93,
            styleScore: 92,
            confidenceScore: data['confidenceScore'] ?? 90,
            verdict: data['verdict'] ?? 'Quiet Luxury Minimalist',
            reasoning: data['reasoning'] ?? '',
            pros: List<String>.from(data['pros'] ?? []),
            cons: List<String>.from(data['cons'] ?? []),
            improvementTips: [
              'Swap belt for a silver-buckle minimalist piece',
              'Sleeve cuff break should expose wrist bone accent',
            ],
            recommendedAccessories: List<String>.from(data['accessories'] ?? []),
            createdAt: DateTime.now(),
          );
          return Result.success(entity);
        },
        onFailure: (failure) => Result.failure(failure),
      );
    } catch (e) {
      return Result.failure(
        ServerFailure(message: 'Outfit analysis error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<OutfitRatingEntity>>> getRecentRatings() async {
    return Result.success([OutfitRatingEntity.mock]);
  }
}
