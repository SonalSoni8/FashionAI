import '../../domain/models/colour_passport_entity.dart';
import '../../domain/models/colour_recommendation_item.dart';

class ColourAnalysisEngine {
  static ColourPassportEntity generatePassportFromTwin({
    required String skinToneName,
    required String skinToneHex,
    required String undertone,
    required String seasonalPalette,
  }) {
    return ColourPassportEntity(
      skinToneName: skinToneName,
      skinToneHex: skinToneHex,
      undertone: undertone,
      seasonPalette: seasonalPalette,
      contrastLevel: 'High Saturation Contrast (88/100)',
      colourHarmonyStrategy:
          'Split-Complementary & Monochromatic Jewel Tones',
      bestColours: const [
        ColourRecommendationItem(
          name: 'Deep Emerald Teal',
          hex: '#0F766E',
          category: 'Power Color',
          explanation:
              'High contrast teal balances golden olive undertones without washing out facial highlights, accentuating natural eye depth.',
        ),
        ColourRecommendationItem(
          name: 'Sapphire Indigo',
          hex: '#4338CA',
          category: 'Power Color',
          explanation:
              'Deep blue undertones create sharp jawline definition against warm skin, projecting effortless sartorial authority.',
        ),
        ColourRecommendationItem(
          name: 'Charcoal Slate',
          hex: '#1E293B',
          category: 'Power Color',
          explanation:
              'A sophisticated dark neutral anchor that maintains high contrast without the stark harshness of flat jet black.',
        ),
        ColourRecommendationItem(
          name: 'Crimson Wine',
          hex: '#BE123C',
          category: 'Power Color',
          explanation:
              'Rich berry crimson reflects warm radiance onto cheeks, giving a vibrant, healthy complexion boost.',
        ),
        ColourRecommendationItem(
          name: 'Midnight Obsidian',
          hex: '#0F172A',
          category: 'Power Color',
          explanation:
              'Darkest architectural anchor matching dark espresso hair contrast, perfect for evening tailoring.',
        ),
        ColourRecommendationItem(
          name: 'Ivory Silk',
          hex: '#F8FAFC',
          category: 'Power Color',
          explanation:
              'Soft ivory hue provides crisp contrast against skin without triggering optical glare or ashiness.',
        ),
      ],
      worstColours: const [
        ColourRecommendationItem(
          name: 'Muted Mustard',
          hex: '#D97706',
          category: 'Avoid Color',
          explanation:
              'Excessive yellow pigment blends directly into olive skin, causing a sallow and fatigued facial complexion.',
        ),
        ColourRecommendationItem(
          name: 'Pale Neon Salmon',
          hex: '#FB7185',
          category: 'Avoid Color',
          explanation:
              'Low-saturation warm pink clashes aggressively with high-contrast hair and eyes, overwhelming facial harmony.',
        ),
        ColourRecommendationItem(
          name: 'Dusty Beige',
          hex: '#D6C7B2',
          category: 'Avoid Color',
          explanation:
              'Lacks contrast structure, washing out natural skin radiance and muting jawline sharpness.',
        ),
      ],
      bestMetals: const [
        ColourRecommendationItem(
          name: 'Brushed Platinum',
          hex: '#E2E8F0',
          category: 'Metal',
          explanation:
              'Cool brushed luster provides refined contrast against golden undertones for timepieces and eyewear.',
        ),
        ColourRecommendationItem(
          name: 'Brushed White Gold',
          hex: '#CBD5E1',
          category: 'Metal',
          explanation:
              'Subtle metallic warmth complements skin surface luminosity without reflecting harsh glare.',
        ),
        ColourRecommendationItem(
          name: 'Matte Anodized Black',
          hex: '#0F172A',
          category: 'Metal',
          explanation:
              'Architectural dark metal that echoes high hair contrast for minimalist accessories.',
        ),
      ],
      bestHairColours: const [
        ColourRecommendationItem(
          name: 'Espresso Black',
          hex: '#1C1917',
          category: 'Hair',
          explanation:
              'Preserves primary high-contrast ratio between eyes, brows, and facial structure.',
        ),
        ColourRecommendationItem(
          name: 'Deep Chestnut Brown',
          hex: '#291D18',
          category: 'Hair',
          explanation:
              'Warm reddish undertones in chestnut highlight subtle golden tones in olive skin.',
        ),
        ColourRecommendationItem(
          name: 'Dark Mocha Burgundy',
          hex: '#3B171E',
          category: 'Hair',
          explanation:
              'Deep plum tint adds dimensional depth under bright natural sunlight without washing out facial tones.',
        ),
      ],
      bestMakeupColours: const [
        ColourRecommendationItem(
          name: 'Terracotta Lip Accent',
          hex: '#C2410C',
          category: 'Makeup',
          explanation:
              'Earthy warm terracotta enhances natural lip pigment with effortless quiet luxury sophistication.',
        ),
        ColourRecommendationItem(
          name: 'Warm Bronze Eyeshadow',
          hex: '#78350F',
          category: 'Makeup',
          explanation:
              'Reflective bronze pigments frame dark charcoal hazel eyes with warm dimensional shading.',
        ),
        ColourRecommendationItem(
          name: 'Deep Berry Blush',
          hex: '#9F1239',
          category: 'Makeup',
          explanation:
              'Muted berry pigment mimics natural post-workout blood flow flush across cheekbones.',
        ),
      ],
    );
  }
}
