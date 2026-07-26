import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';

class ShoppingAdvisorView extends StatefulWidget {
  const ShoppingAdvisorView({super.key});

  @override
  State<ShoppingAdvisorView> createState() => _ShoppingAdvisorViewState();
}

class _ShoppingAdvisorViewState extends State<ShoppingAdvisorView> {
  final _urlController = TextEditingController(
    text: "https://luxury-store.com/item/linen-double-breasted-blazer",
  );
  bool _isEvaluating = false;
  Map<String, dynamic>? _evaluation;

  void _evaluateLink() async {
    setState(() => _isEvaluating = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      setState(() {
        _isEvaluating = false;
        _evaluation = {
          "verdict": "BUY WITH CONFIDENCE",
          "isBuy": true,
          "versatilityScore": 92,
          "wardrobeSynergy": "Pairs with 84% of your existing owned bottoms and shoes.",
          "reasoning":
              "This neutral linen blazer complements your Warm Olive undertone perfectly. The unstructured shoulder aligns with your athletic V-shape profile without adding bulk.",
          "alternatives": [
            "Consider deep espresso suede loafers for high contrast",
            "Alternative brand offers 100% organic Italian linen at 20% lower price point"
          ]
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          "AI Shopping Advisor",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                "Buy vs. Skip Evaluation",
                style: AuraTypography.headingMedium(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Before buying, let Aura AI evaluate whether an item fits your skin tone, face/body metrics, and owned wardrobe items.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _urlController,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Paste Shopping Link or Item URL',
                        labelStyle: AuraTypography.bodyMedium(isDark: true),
                        prefixIcon: const Icon(
                          Icons.link_rounded,
                          color: AuraColors.auraCyan,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MorphingButton(
                      text: _isEvaluating ? "Evaluating Synergy..." : "Evaluate Purchase",
                      icon: Icons.auto_awesome_rounded,
                      isLoading: _isEvaluating,
                      onPressed: _evaluateLink,
                    ),
                  ],
                ),
              ),

              if (_evaluation != null) ...[
                const SizedBox(height: 28),
                GlassCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(24),
                  isGlowing: true,
                  glowColor: _evaluation!['isBuy']
                      ? AuraColors.auraEmerald
                      : AuraColors.auraRose,
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: (_evaluation!['isBuy']
                                      ? AuraColors.auraEmerald
                                      : AuraColors.auraRose)
                                  .withOpacity(0.2),
                            ),
                            child: Text(
                              _evaluation!['verdict'],
                              style: AuraTypography.caption(isDark: true).copyWith(
                                color: _evaluation!['isBuy']
                                    ? AuraColors.auraEmerald
                                    : AuraColors.auraRose,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            "VERSATILITY ${_evaluation!['versatilityScore']}%",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraCyan,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Wardrobe Synergy",
                        style: AuraTypography.title(isDark: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _evaluation!['wardrobeSynergy'],
                        style: AuraTypography.bodyLarge(isDark: true).copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "WHY THIS ADVICE WAS GIVEN",
                        style: AuraTypography.caption(isDark: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _evaluation!['reasoning'],
                        style: AuraTypography.bodyLarge(isDark: true),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
