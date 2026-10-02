import '../../domain/models/chat_message_entity.dart';
import '../../domain/models/outfit_recommendation_card.dart';
import '../../domain/models/stylist_context_payload.dart';

class GeminiFashionAiService {
  Future<ChatMessageEntity> queryStylist({
    required String prompt,
    required StylistContextPayload contextPayload,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final query = prompt.toLowerCase();

    if (query.contains('wear today') || query.contains('today')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "Based on today's clear 72°F skies and your Athletic V-Shape silhouette, here is your high-confidence curated outfit from your digital wardrobe:",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
        outfitCards: [
          const OutfitRecommendationCard(
            title: "Obsidian Slate & Emerald Linen Layer",
            description:
                "Unstructured Charcoal Linen Blazer paired with your Off-White Supima Tee and Slim Slate Trousers. Crisp, breathable, and perfectly tuned to your Deep Autumn palette.",
            matchPercentage: "99% Match",
            outerwearItem: "Unstructured Charcoal Linen Blazer",
            topItem: "Off-White Supima Crewneck Tee",
            bottomItem: "Slim Slate Tailored Trousers",
            footwearItem: "Minimalist White Leather Low-Tops",
            accessoryItem: "Matte Black Acetate Sunglasses",
            formality: "Smart Casual",
            colorPaletteHexes: ["#1E293B", "#F8FAFC", "#334155", "#0F766E"],
          ),
        ],
      );
    }

    if (query.contains('10 office') || query.contains('office')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "Here is your 10-Outfit Executive Office Matrix built from your digital closet staples:",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
        outfitCards: [
          const OutfitRecommendationCard(
            title: "Look 1: Deep Emerald Silk & Slate Trousers",
            description: "High-contrast silk shirt with crisp tropical wool trousers.",
            matchPercentage: "99% Match",
            topItem: "Deep Emerald Silk Satin Shirt",
            bottomItem: "Slim Slate Tailored Trousers",
            footwearItem: "Minimalist Leather Low-Tops",
            formality: "Business Casual",
            colorPaletteHexes: ["#0F766E", "#334155", "#F1F5F9"],
          ),
          const OutfitRecommendationCard(
            title: "Look 2: Charcoal Blazer & Supima Layer",
            description: "Unstructured blazer tailored for broad shoulders.",
            matchPercentage: "98% Match",
            outerwearItem: "Unstructured Charcoal Blazer",
            topItem: "Off-White Supima Crewneck",
            bottomItem: "Slim Slate Tailored Trousers",
            footwearItem: "Leather Low-Tops",
            formality: "Business Casual",
            colorPaletteHexes: ["#1E293B", "#F8FAFC", "#334155"],
          ),
          const OutfitRecommendationCard(
            title: "Look 3: Monochromatic Obsidian Power Suit",
            description: "Deep charcoal tone-on-tone tailored silhouette.",
            matchPercentage: "97% Match",
            outerwearItem: "Charcoal Blazer",
            topItem: "Deep Charcoal Knit",
            bottomItem: "Slim Slate Trousers",
            footwearItem: "Black Calfskin Loafers",
            formality: "Business Formal",
            colorPaletteHexes: ["#0F172A", "#1E293B", "#334155"],
          ),
        ],
      );
    }

    if (query.contains('wedding')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "For a formal wedding, your Warm Olive skin tone and Deep Autumn palette shine in rich jewel tones:",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
        outfitCards: [
          const OutfitRecommendationCard(
            title: "Royal Mulberry Silk & Crimson Tuxedo Ensemble",
            description:
                "Deep Mulberry Silk structured jacket with subtle contrast lapel, paired with dark tailored trousers and platinum watch accent.",
            matchPercentage: "100% Match",
            outerwearItem: "Mulberry Silk Blazer",
            topItem: "Ivory Silk Formal Shirt",
            bottomItem: "Midnight Obsidian Formal Trousers",
            footwearItem: "Patent Black Dress Shoes",
            accessoryItem: "Brushed Platinum Timepiece",
            formality: "Black-Tie Formal",
            colorPaletteHexes: ["#BE123C", "#F8FAFC", "#0F172A", "#E2E8F0"],
          ),
        ],
      );
    }

    if (query.contains('colour') || query.contains('color')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "Your AI Colour Passport analysis confirms you belong to the **DEEP AUTUMN / COOL WINTER** season.\n\n"
            "• **Best Power Colours**: Deep Emerald Teal (#0F766E), Sapphire Indigo (#4338CA), Charcoal Slate (#1E293B), and Crimson Wine (#BE123C).\n"
            "• **Why**: High-contrast jewel tones balance your golden olive undertones without washing out your facial features.\n"
            "• **Avoid**: Muted Mustard (#D97706) and Pale Neon Salmon (#FB7185) as yellow/pale pigments cause a sallow complexion.",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
      );
    }

    if (query.contains('rate')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "★ **Outfit Rating: 98/100 (Exemplary Quiet Luxury)**\n\n"
            "• **Proportions**: Excellent V-Shape shoulder-to-waist ratio framing.\n"
            "• **Colour Harmony**: Emerald Teal + Charcoal Slate is an optimal split-complementary pairing for your undertone.\n"
            "• **Stylist Tip**: Swap sneakers for dark calfskin loafers to elevate for evening dinners.",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
      );
    }

    if (query.contains('packing') || query.contains('pack')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "Here is your 5-Day Smart Capsule Packing Matrix built from your digital closet:\n\n"
            "1. **Outerwear**: Charcoal Linen Blazer (Versatility score: 98%)\n"
            "2. **Tops**: 2x Supima Cotton Tees, 1x Emerald Silk Shirt\n"
            "3. **Bottoms**: 2x Slim Slate Trousers\n"
            "4. **Footwear**: Minimalist Leather Low-Tops\n"
            "5. **Accessories**: Sunglasses & Platinum Watch",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
      );
    }

    if (query.contains('airport') || query.contains('flight')) {
      return ChatMessageEntity(
        id: DateTime.now().toIso8601String(),
        text:
            "Here is your High-Streetwear Comfort Airport Travel Look:",
        sender: ChatSender.aiStylist,
        timestamp: DateTime.now(),
        outfitCards: [
          const OutfitRecommendationCard(
            title: "Luxe Airport Travel Ensemble",
            description:
                "Breathable Supima Tee under an unbuttoned lightweight linen layer, tailored drawstring trousers, and easy slip-off white leather low-tops.",
            matchPercentage: "99% Match",
            topItem: "Off-White Supima Crewneck Tee",
            bottomItem: "Slim Slate Drawstring Trousers",
            footwearItem: "Minimalist Leather Low-Tops",
            accessoryItem: "Matte Black Acetate Sunglasses",
            formality: "Casual Luxe",
            colorPaletteHexes: ["#F8FAFC", "#334155", "#0F172A"],
          ),
        ],
      );
    }

    return ChatMessageEntity(
      id: DateTime.now().toIso8601String(),
      text:
          "I have analyzed your Digital Twin ($contextPayload.bodyShape), Digital Closet ($contextPayload.wardrobeItemCount items), and $contextPayload.seasonalPalette color profile.\n\nHow else can I assist your styling today?",
      sender: ChatSender.aiStylist,
      timestamp: DateTime.now(),
    );
  }
}
