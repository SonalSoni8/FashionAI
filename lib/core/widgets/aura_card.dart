import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/aura_colors.dart';

class AuraCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isGlowing;
  final Color glowColor;

  const AuraCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding,
    this.onTap,
    this.isGlowing = false,
    this.glowColor = AuraColors.auraViolet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AuraColors.glassGradientDark,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isGlowing
                    ? glowColor.withOpacity(0.5)
                    : AuraColors.glassBorderDark,
                width: isGlowing ? 1.5 : 1.0,
              ),
              boxShadow: isGlowing
                  ? [
                      BoxShadow(
                        color: glowColor.withOpacity(0.25),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
