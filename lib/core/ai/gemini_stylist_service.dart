import '../errors/failure.dart';
import 'i_ai_stylist_service.dart';

class GeminiStylistService implements IAiStylistService {
  @override
  AiProviderType get providerType => AiProviderType.gemini;

  @override
  Future<Result<Map<String, dynamic>>> analyzeOutfit({
    required String imagePath,
    String? occasion,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    return Result.success({
      "overallScore": 94,
      "colorScore": 96,
      "fitScore": 91,
      "occasionScore": 95,
      "confidenceScore": 92,
      "verdict": "Quiet Luxury Minimalist",
      "reasoning":
          "The monochromatic charcoal blazer paired with off-white linen creates high visual harmony. The unstructured shoulder aligns with your athletic V-shape profile.",
      "pros": [
        "Monochromatic dark top creates vertical elongation",
        "High contrast with soft cream accessories highlights face focal point",
      ],
      "cons": [
        "Pant hem length sits slightly low near shoe collar"
      ],
      "accessories": [
        "Brushed silver chronograph watch",
        "Minimalist matte black acetate sunglasses"
      ],
    });
  }

  @override
  Future<Result<String>> askStylist({
    required String query,
    Map<String, dynamic>? userContext,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final q = query.toLowerCase();

    if (q.contains("interview")) {
      return "For a modern interview, pair an unstructured navy blazer over an off-white silk crewneck shirt, slim charcoal trousers, and clean dress sneakers.";
    } else if (q.contains("wedding")) {
      return "For a summer wedding, opt for a double-breasted beige suit with an open-collar linen shirt and espresso suede loafers.";
    }

    return "Aura AI Recommendation: Focus on fit and color contrast first. Charcoal, emerald, and dark navy pair best with your warm olive undertone.";
  }

  @override
  Future<Result<Map<String, dynamic>>> analyzeColorimetry({
    required String faceImagePath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return Result.success({
      "undertone": "Golden Warm Olive",
      "palette": "Deep Autumn / Cool Winter",
      "powerColors": ["#0F766E", "#4338CA", "#1E293B", "#BE123C"],
      "avoidColors": ["#D97706", "#FB7185"],
    });
  }
}
