import '../domain/models/ai_learning_vector.dart';
import '../domain/models/aura_dna_entity.dart';
import '../domain/models/fashion_history_log.dart';

class AuraDnaEngine {
  static AuraDnaEntity synthesizeGenome() {
    return AuraDnaEntity(
      userName: 'Alex Morgan',
      twinId: 'TWIN_PRIMARY_33J',
      heightCm: 180.0,
      bodyShape: 'Athletic V-Shape (Broad Shoulders, Slim Waist)',
      skinToneName: 'Warm Olive Level 3',
      skinToneHex: '#A37854',
      seasonalPalette: 'Deep Autumn / Cool Winter Split-Palette',
      wardrobeItemCount: 42,
      closetVersatilityScore: 96.4,
      favouriteBrands: const [
        'Atelier Sartorial (40%)',
        'Zara Luxe Line (35%)',
        'Net-a-Porter Private (25%)',
      ],
      favouriteColours: const [
        'Charcoal Slate (#1E293B)',
        'Deep Emerald Teal (#0F766E)',
        'Off-White Supima (#F8FAFC)',
        'Crimson Wine (#BE123C)',
      ],
      favouriteFits: const [
        'Unstructured Shoulder Blazer',
        'Slim Tailored Trousers',
        'Minimalist Low-Profile Footwear',
      ],
      shoppingBehaviour:
          'Quiet Luxury Value Investor (High cost-per-wear efficiency)',
      stylePersonality: 'Modern Architectural Quiet Luxury',
      confidenceScore: 99,
      fashionEvolutionStage:
          'Tier 4 Architectural Precision (98% Proportion Harmony)',
      outfitHistory: [
        FashionHistoryLog(
          id: 'log_1',
          eventType: 'Outfit Worn',
          title: 'Charcoal Linen Blazer & Slate Trousers',
          description: 'Executive Office & Evening Dinner ensemble',
          ratingOrVerdict: '98/100 Rating',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        FashionHistoryLog(
          id: 'log_2',
          eventType: 'Outfit Worn',
          title: 'Deep Emerald Silk Shirt & White Sneakers',
          description: 'Resort Casual Luxe look',
          ratingOrVerdict: '99/100 Rating',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      shoppingHistory: [
        FashionHistoryLog(
          id: 'shop_1',
          eventType: 'Shopping Decision',
          title: 'Unstructured Deep Emerald Silk Blazer',
          description: 'Zara Product Link Evaluation',
          ratingOrVerdict: 'BUY Verdict (98% Match)',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        FashionHistoryLog(
          id: 'shop_2',
          eventType: 'Shopping Decision',
          title: 'Muted Mustard Knit Sweater',
          description: 'Screenshot Upload Evaluation',
          ratingOrVerdict: 'SKIP Verdict (Color Clash)',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
      aiLearning: const AiLearningVector(),
    );
  }
}
