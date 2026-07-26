import 'package:flutter/material.dart';
import '../../../../core/theme/aura_colors.dart';
import '../../../../core/theme/aura_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class DesktopAuthHero extends StatelessWidget {
  const DesktopAuthHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AuraColors.surfaceDark,
        gradient: LinearGradient(
          colors: [
            Color(0xFF090A0F),
            Color(0xFF141724),
            Color(0xFF090A0F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: AuraColors.auraGradientPrimary,
              boxShadow: [
                BoxShadow(
                  color: AuraColors.auraViolet.withOpacity(0.5),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 36),

          Text(
            "Precision Personal\nFashion Intelligence",
            style: AuraTypography.displayHero(isDark: true).copyWith(
              fontSize: 44,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "Discover your signature style, skin tone harmony, and body geometry recommendations powered by multi-provider AI.",
            style: AuraTypography.bodyLarge(isDark: true).copyWith(
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 48),

          // Feature highlights pills
          GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            isGlowing: true,
            glowColor: AuraColors.auraViolet,
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: AuraColors.auraEmerald,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      "98.4% Precision Colorimetry",
                      style: AuraTypography.title(isDark: true).copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Automated Undertone & Palette Engine",
                      style: AuraTypography.caption(isDark: true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
