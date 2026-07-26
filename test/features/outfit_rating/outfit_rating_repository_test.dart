import 'package:flutter_test/flutter_test.dart';
import 'package:aura_ai/core/ai/gemini_stylist_service.dart';
import 'package:aura_ai/features/outfit_rating/data/repositories/outfit_rating_repository.dart';

void main() {
  late OutfitRatingRepository repository;

  setUp(() {
    repository = OutfitRatingRepository(GeminiStylistService());
  });

  group('OutfitRatingRepository Enterprise Unit Tests', () {
    test('analyzeOutfitPhoto returns Result.success with scores and reasoning', () async {
      final result = await repository.analyzeOutfitPhoto(imagePath: 'mock_outfit.jpg');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNotNull);
      expect(result.dataOrNull!.overallScore, greaterThan(80));
      expect(result.dataOrNull!.pros, isNotEmpty);
    });
  });
}
