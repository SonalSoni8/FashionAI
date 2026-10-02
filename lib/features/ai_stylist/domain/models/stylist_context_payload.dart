import 'package:flutter/foundation.dart';

@immutable
class StylistContextPayload {
  final String userName;
  final String bodyShape;
  final double heightCm;
  final int wardrobeItemCount;
  final String skinToneName;
  final String seasonalPalette;
  final String weatherCondition;
  final String temperature;
  final String occasion;
  final String budgetTier;

  const StylistContextPayload({
    required this.userName,
    required this.bodyShape,
    required this.heightCm,
    required this.wardrobeItemCount,
    required this.skinToneName,
    required this.seasonalPalette,
    required this.weatherCondition,
    required this.temperature,
    required this.occasion,
    required this.budgetTier,
  });

  String buildSystemPrompt() {
    return '''
System Context:
User Name: $userName
Body Silhouette: $bodyShape (${heightCm.toInt()} cm height)
Wardrobe Inventory: $wardrobeItemCount digitized owned items
Colour Passport: $skinToneName · Seasonal Palette: $seasonalPalette
Real-Time Weather: $temperature, $weatherCondition
Active Context: $occasion | Budget Tier: $budgetTier

Role: You are Aura AI, the world's leading Personal AI Stylist. Always provide tailored, high-fashion, architecturally sound outfit recommendations using the user's specific context.
''';
  }
}
