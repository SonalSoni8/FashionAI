import '../errors/failure.dart';

enum AiProviderType { gemini, openAi, claude, localLlama }

abstract class IAiStylistService {
  AiProviderType get providerType;

  Future<Result<Map<String, dynamic>>> analyzeOutfit({
    required String imagePath,
    String? occasion,
  });

  Future<Result<String>> askStylist({
    required String query,
    Map<String, dynamic>? userContext,
  });

  Future<Result<Map<String, dynamic>>> analyzeColorimetry({
    required String faceImagePath,
  });
}
