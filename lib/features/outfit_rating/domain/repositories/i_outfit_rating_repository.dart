import '../../../../core/errors/failure.dart';
import '../models/outfit_rating_entity.dart';

abstract class IOutfitRatingRepository {
  Future<Result<OutfitRatingEntity>> analyzeOutfitPhoto({
    required String imagePath,
    String? occasion,
  });

  Future<Result<List<OutfitRatingEntity>>> getRecentRatings();
}
