import 'package:flutter/material.dart';

/// Aura AI Design System Color Tokens
/// Inspired by Apple, Notion, Linear, and Arc Browser.
/// Ultra-minimalist obsidian background with radiant neon aura accents and frosted glass effects.
abstract class AuraColors {
  // Dark Mode Canvas (Obsidian & Charcoal)
  static const Color backgroundDark = Color(0xFF090A0F);
  static const Color surfaceDark = Color(0xFF12141C);
  static const Color surfaceDarkElevated = Color(0xFF1A1D29);
  static const Color surfaceGlassDark = Color(0x1F222736); // ~12% opacity glass
  
  // Light Mode Canvas (Silk White & Warm Alabaster)
  static const Color backgroundLight = Color(0xFFF8F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightElevated = Color(0xFFF0F2F7);
  static const Color surfaceGlassLight = Color(0xCCFFFFFF); // ~80% opacity frosted light

  // Brand Aura Accents (Neon Cyber-Chic)
  static const Color auraViolet = Color(0xFF6366F1);   // Electric Indigo / Primary
  static const Color auraRose = Color(0xFFEC4899);     // Luxe Magenta / Secondary
  static const Color auraEmerald = Color(0xFF10B981);  // High-Confidence Green
  static const Color auraAmber = Color(0xFFF59E0B);    // Warm Gold Accent
  static const Color auraCyan = Color(0xFF06B6D4);     // Futuristic Cyan

  // Text Colors Dark Mode
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textMutedDark = Color(0xFF6B7280);

  // Text Colors Light Mode
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF4B5563);
  static const Color textMutedLight = Color(0xFF9CA3AF);

  // Borders & Dividers
  static const Color glassBorderDark = Color(0x26FFFFFF);  // 15% White border line
  static const Color glassBorderLight = Color(0x1F000000); // 12% Dark border line
  static const Color glassGlowBorder = Color(0x806366F1);  // Glowing border accent

  // Gradients
  static const LinearGradient auraGradientPrimary = LinearGradient(
    colors: [auraViolet, auraRose],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auraGradientGlow = LinearGradient(
    colors: [Color(0x996366F1), Color(0x99EC4899), Color(0x0006B6D4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradientDark = LinearGradient(
    colors: [
      Color(0x332A2E3D),
      Color(0x1A181B24),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradientLight = LinearGradient(
    colors: [
      Color(0xE6FFFFFF),
      Color(0xB3F0F2F7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
