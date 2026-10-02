import 'package:flutter/material.dart';

import '../../../../core/theme/aura_colors.dart';
import '../../../../core/theme/aura_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/models/photo_quality_rule.dart';

class PhotoRulesBanner extends StatefulWidget {
  final List<PhotoQualityRule> rules;
  final String title;

  const PhotoRulesBanner({
    super.key,
    this.rules = const [],
    this.title = "Photo Capture & Upload Rules",
  });

  @override
  State<PhotoRulesBanner> createState() => _PhotoRulesBannerState();
}

class _PhotoRulesBannerState extends State<PhotoRulesBanner> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final rulesList = widget.rules.isEmpty
        ? PhotoQualityRule.defaultTwinRules
        : widget.rules;

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      isGlowing: true,
      glowColor: AuraColors.auraCyan,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuraColors.auraCyan.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: AuraColors.auraCyan,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AuraTypography.title(isDark: true).copyWith(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "5 Rules for 99% Pose Mesh Accuracy",
                          style: AuraTypography.caption(isDark: true),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 14),
            const Divider(color: AuraColors.glassBorderDark),
            const SizedBox(height: 10),
            Column(
              children: rulesList.map((rule) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AuraColors.auraEmerald,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(
                              rule.title,
                              style: AuraTypography.caption(isDark: true).copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              rule.description,
                              style: AuraTypography.caption(isDark: true).copyWith(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
