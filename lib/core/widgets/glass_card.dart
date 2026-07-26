import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/aura_colors.dart';

/// Premium Frosted Glass Card with subtle border shimmer & optional neon glow
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? glowColor;
  final bool isGlowing;
  final BorderGradient? borderGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 16.0,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
    this.glowColor,
    this.isGlowing = false,
    this.borderGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget glassBox = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: isDark
                ? AuraColors.glassGradientDark
                : AuraColors.glassGradientLight,
            border: Border.all(
              color: isGlowing
                  ? (glowColor ?? AuraColors.auraViolet).withOpacity(0.5)
                  : (isDark
                      ? AuraColors.glassBorderDark
                      : AuraColors.glassBorderLight),
              width: isGlowing ? 1.5 : 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (isGlowing) {
      glassBox = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: (glowColor ?? AuraColors.auraViolet).withOpacity(0.25),
              blurRadius: 24,
              spreadRadius: -2,
            ),
          ],
        ),
        child: glassBox,
      );
    } else if (margin != null) {
      glassBox = Padding(padding: margin!, child: glassBox);
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: glassBox,
      );
    }

    return glassBox;
  }
}
