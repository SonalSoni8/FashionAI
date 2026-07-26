import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aura_colors.dart';

/// Aura AI Typography Hierarchy
/// Uses Outfit & Plus Jakarta Sans with fallbacks for crisp, luxury feel.
abstract class AuraTypography {
  static TextStyle displayHero({bool isDark = true}) => GoogleFonts.outfit(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
        height: 1.1,
        color: isDark ? AuraColors.textPrimaryDark : AuraColors.textPrimaryLight,
      );

  static TextStyle headingLarge({bool isDark = true}) => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.8,
        height: 1.2,
        color: isDark ? AuraColors.textPrimaryDark : AuraColors.textPrimaryLight,
      );

  static TextStyle headingMedium({bool isDark = true}) => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
        color: isDark ? AuraColors.textPrimaryDark : AuraColors.textPrimaryLight,
      );

  static TextStyle title({bool isDark = true}) => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: isDark ? AuraColors.textPrimaryDark : AuraColors.textPrimaryLight,
      );

  static TextStyle bodyLarge({bool isDark = true}) => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.2,
        height: 1.5,
        color: isDark ? AuraColors.textSecondaryDark : AuraColors.textSecondaryLight,
      );

  static TextStyle bodyMedium({bool isDark = true}) => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.45,
        color: isDark ? AuraColors.textSecondaryDark : AuraColors.textSecondaryLight,
      );

  static TextStyle caption({bool isDark = true}) => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: isDark ? AuraColors.textMutedDark : AuraColors.textMutedLight,
      );

  static TextStyle labelButton({bool isDark = true}) => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );
}
