import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'i_ai_stylist_service.dart';
import 'gemini_stylist_service.dart';

final selectedAiProviderTypeProvider = StateProvider<AiProviderType>((ref) {
  return AiProviderType.gemini;
});

final aiStylistServiceProvider = Provider<IAiStylistService>((ref) {
  final providerType = ref.watch(selectedAiProviderTypeProvider);

  switch (providerType) {
    case AiProviderType.gemini:
      return GeminiStylistService();
    case AiProviderType.openAi:
    case AiProviderType.claude:
    case AiProviderType.localLlama:
      return GeminiStylistService(); // Fallback to Gemini implementation
  }
});
