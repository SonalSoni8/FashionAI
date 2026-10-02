import '../domain/models/colour_distribution_item.dart';
import '../domain/models/wardrobe_analytics_entity.dart';

class AnalyticsCalculatorService {
  static WardrobeAnalyticsEntity computeAnalytics({
    required int totalItemsCount,
  }) {
    return const WardrobeAnalyticsEntity(
      closetScore: 96,
      confidenceScore: 99,
      outfitVarietyCount: 142,
      unusedClothesCount: 2,
      unusedItemNames: [
        'Muted Yellow Knit Sweater (Unworn 75 days)',
        'Vintage Oversized Light Denim Jacket (Unworn 64 days)',
      ],
      styleEvolutionStage: 'Quiet Luxury Tier 4 (High Architectural Precision)',
      styleEvolutionProgress: 0.88,
      colourBalance: [
        ColourDistributionItem(
          name: 'Charcoal Slate',
          hex: '#1E293B',
          percentage: 34.0,
          itemCount: 14,
        ),
        ColourDistributionItem(
          name: 'Deep Emerald',
          hex: '#0F766E',
          percentage: 28.0,
          itemCount: 12,
        ),
        ColourDistributionItem(
          name: 'Off-White Supima',
          hex: '#F8FAFC',
          percentage: 22.0,
          itemCount: 9,
        ),
        ColourDistributionItem(
          name: 'Crimson Wine',
          hex: '#BE123C',
          percentage: 16.0,
          itemCount: 7,
        ),
      ],
      seasonReadiness: {
        'Spring / Summer': 94.0,
        'Autumn / Winter': 98.0,
        'All-Season Staples': 96.0,
      },
      favouriteBrands: {
        'Atelier Sartorial': 40.0,
        'Zara Luxe Line': 35.0,
        'Net-a-Porter Private': 25.0,
      },
      shoppingSuggestions: [
        'Minimalist Black Leather Loafers (Fills formal footwear gap)',
        'Tailored Camel Double-Breasted Trench Coat (Complements Deep Autumn palette)',
        'Silk Pocket Square Accent in Sapphire Indigo',
      ],
    );
  }
}
