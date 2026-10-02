import '../../domain/models/shopping_item_analysis.dart';

class ShoppingAdvisorAiEngine {
  Future<ShoppingItemAnalysis> analyzeItem({
    required String queryOrUrl,
    required String source, // 'Link', 'Screenshot', 'Photo'
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final input = queryOrUrl.toLowerCase();

    // If item is a mustard or neon salmon garment -> SKIP verdict
    if (input.contains('mustard') || input.contains('salmon') || input.contains('yellow')) {
      return const ShoppingItemAnalysis(
        itemName: 'Muted Mustard Knit Sweater',
        category: 'Tops',
        brandName: 'Fast Fashion Retailer',
        priceEstimate: '\$89',
        verdict: VerdictType.skip,
        verdictScore: 42.0,
        matchesSkinTone: false,
        skinToneExplanation:
            'FAIL: Excessive yellow pigments blend directly into your Warm Olive skin, creating a sallow complexion and muting natural facial radiance.',
        matchesWardrobe: false,
        wardrobeExplanation:
            'POOR: Color clashes with 80% of your existing capsule wardrobe (Charcoal Blazers & Slate Trousers).',
        newOutfitsCreatedCount: 1,
        newOutfitsExplanation:
            'Unlocks only 1 limited combination. High risk of becoming unworn closet clutter.',
        valueForMoneyScore: 3.2,
        valueForMoneyExplanation:
            'Poor cost-per-wear ratio (\$89 / 2 wears = \$44.50 per wear).',
        alternativeColourName: 'Deep Emerald Teal',
        alternativeColourHex: '#0F766E',
        alternativeColourExplanation:
            'Switch to Deep Emerald Teal to balance golden olive undertones and sharpen jawline definition.',
        alternativeBrandName: 'Luxe Tailored Knitwear Co.',
        alternativeBrandExplanation:
            'Consider 100% Organic Supima Cotton or Mulberry Silk for superior drape and longevity.',
      );
    }

    // Default high-synergy item -> BUY verdict
    return const ShoppingItemAnalysis(
      itemName: 'Unstructured Deep Emerald Silk Blazer',
      category: 'Outerwear',
      brandName: 'Atelier Sartorial',
      priceEstimate: '\$240',
      verdict: VerdictType.buy,
      verdictScore: 98.4,
      matchesSkinTone: true,
      skinToneExplanation:
          'PERFECT: Deep Emerald Teal (#0F766E) is a primary Power Colour in your Deep Autumn palette, highlighting cheekbone warmth.',
      matchesWardrobe: true,
      wardrobeExplanation:
          'HIGH SYNERGY: Pairs seamlessly with 8 existing items in your closet (Off-White Tee, Slate Trousers, White Leather Sneakers).',
      newOutfitsCreatedCount: 8,
      newOutfitsExplanation:
          'Unlocks +8 NEW high-confidence outfit combinations across Workwear, Resort, and Evening Luxe.',
      valueForMoneyScore: 9.6,
      valueForMoneyExplanation:
          'Exceptional cost-per-wear efficiency (\$240 / 20 estimated wears = \$12.00 per wear).',
      alternativeColourName: 'Sapphire Indigo',
      alternativeColourHex: '#4338CA',
      alternativeColourExplanation:
          'Sapphire Indigo is a great secondary power option if you desire an evening-focused alternative.',
      alternativeBrandName: 'Minimalist Sartorial House',
      alternativeBrandExplanation:
          'High-end sustainable alternative offering Italian Tropical Wool-Silk blends.',
    );
  }
}
