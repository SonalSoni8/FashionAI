import 'package:flutter/material.dart';
import '../../../../core/theme/aura_colors.dart';
import '../../../../core/theme/aura_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class ScoreGaugeCard extends StatelessWidget {
  final int overallScore;
  final String verdict;

  const ScoreGaugeCard({
    super.key,
    required this.overallScore,
    required this.verdict,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      isGlowing: true,
      glowColor: AuraColors.auraEmerald,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AuraColors.auraEmerald.withOpacity(0.15),
              border: Border.all(color: AuraColors.auraEmerald, width: 2.5),
            ),
            child: Center(
              child: Text(
                '$overallScore',
                style: AuraTypography.displayHero(isDark: true).copyWith(
                  color: AuraColors.auraEmerald,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Text(
                  "OVERALL STYLE VERDICT",
                  style: AuraTypography.caption(isDark: true).copyWith(
                    letterSpacing: 1.5,
                    color: AuraColors.textMutedDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  verdict,
                  style: AuraTypography.headingMedium(isDark: true).copyWith(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
