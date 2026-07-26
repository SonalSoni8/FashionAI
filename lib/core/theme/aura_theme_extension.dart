import 'package:flutter/material.dart';
import 'aura_colors.dart';

@immutable
class AuraThemeExtension extends ThemeExtension<AuraThemeExtension> {
  final Color backgroundCanvas;
  final Color surfaceGlass;
  final Color glassBorder;
  final Color auraViolet;
  final Color auraRose;
  final Color auraCyan;
  final Color auraEmerald;
  final double glassBlur;
  final double cardRadius;

  const AuraThemeExtension({
    required this.backgroundCanvas,
    required this.surfaceGlass,
    required this.glassBorder,
    required this.auraViolet,
    required this.auraRose,
    required this.auraCyan,
    required this.auraEmerald,
    required this.glassBlur,
    required this.cardRadius,
  });

  static const dark = AuraThemeExtension(
    backgroundCanvas: AuraColors.backgroundDark,
    surfaceGlass: AuraColors.surfaceGlassDark,
    glassBorder: AuraColors.glassBorderDark,
    auraViolet: AuraColors.auraViolet,
    auraRose: AuraColors.auraRose,
    auraCyan: AuraColors.auraCyan,
    auraEmerald: AuraColors.auraEmerald,
    glassBlur: 18.0,
    cardRadius: 24.0,
  );

  static const light = AuraThemeExtension(
    backgroundCanvas: AuraColors.backgroundLight,
    surfaceGlass: AuraColors.surfaceGlassLight,
    glassBorder: AuraColors.glassBorderLight,
    auraViolet: AuraColors.auraViolet,
    auraRose: AuraColors.auraRose,
    auraCyan: AuraColors.auraCyan,
    auraEmerald: AuraColors.auraEmerald,
    glassBlur: 14.0,
    cardRadius: 24.0,
  );

  @override
  AuraThemeExtension copyWith({
    Color? backgroundCanvas,
    Color? surfaceGlass,
    Color? glassBorder,
    Color? auraViolet,
    Color? auraRose,
    Color? auraCyan,
    Color? auraEmerald,
    double? glassBlur,
    double? cardRadius,
  }) {
    return AuraThemeExtension(
      backgroundCanvas: backgroundCanvas ?? this.backgroundCanvas,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      glassBorder: glassBorder ?? this.glassBorder,
      auraViolet: auraViolet ?? this.auraViolet,
      auraRose: auraRose ?? this.auraRose,
      auraCyan: auraCyan ?? this.auraCyan,
      auraEmerald: auraEmerald ?? this.auraEmerald,
      glassBlur: glassBlur ?? this.glassBlur,
      cardRadius: cardRadius ?? this.cardRadius,
    );
  }

  @override
  AuraThemeExtension lerp(ThemeExtension<AuraThemeExtension>? other, double t) {
    if (other is! AuraThemeExtension) return this;
    return AuraThemeExtension(
      backgroundCanvas: Color.lerp(backgroundCanvas, other.backgroundCanvas, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      auraViolet: Color.lerp(auraViolet, other.auraViolet, t)!,
      auraRose: Color.lerp(auraRose, other.auraRose, t)!,
      auraCyan: Color.lerp(auraCyan, other.auraCyan, t)!,
      auraEmerald: Color.lerp(auraEmerald, other.auraEmerald, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
      cardRadius: lerpDouble(cardRadius, other.cardRadius, t)!,
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

extension AuraThemeContext on BuildContext {
  AuraThemeExtension get auraTheme =>
      Theme.of(this).extension<AuraThemeExtension>() ?? AuraThemeExtension.dark;
}
