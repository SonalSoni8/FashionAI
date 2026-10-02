import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../../../core/widgets/aura_text_field.dart';
import '../domain/models/shopping_item_analysis.dart';
import '../providers/shopping_advisor_provider.dart';

class ShoppingAdvisorView extends ConsumerStatefulWidget {
  const ShoppingAdvisorView({super.key});

  @override
  ConsumerState<ShoppingAdvisorView> createState() =>
      _ShoppingAdvisorViewState();
}

class _ShoppingAdvisorViewState extends ConsumerState<ShoppingAdvisorView> {
  final _urlController =
      TextEditingController(text: "https://zara.com/item/emerald-silk-blazer");

  void _analyze(String source) {
    final query = _urlController.text.trim();
    ref.read(shoppingAdvisorProvider.notifier).analyzeProduct(
          queryOrUrl: query.isEmpty ? "emerald blazer" : query,
          source: source,
        );
  }

  @override
  Widget build(BuildContext context) {
    final advisorState = ref.watch(shoppingAdvisorProvider);
    final analysis = advisorState.currentAnalysis;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Shopping Link Advisor",
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
                "Evaluate Before Buying",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Paste product link or upload photo to evaluate skin tone match, wardrobe synergy & BUY vs SKIP verdict.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              // Ingestion Bar (3 Sources)
              AuraCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    AuraTextField(
                      controller: _urlController,
                      label: "Product Link URL",
                      hint: "https://www.net-a-porter.com/item/1234",
                      prefixIcon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: AuraButton(
                            text: "Evaluate Link",
                            icon: Icons.auto_awesome_rounded,
                            height: 48,
                            isLoading: advisorState.isAnalyzing,
                            onPressed: () => _analyze('Link'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: AuraButton(
                            text: "Upload Screenshot",
                            icon: Icons.screenshot_monitor_rounded,
                            height: 42,
                            style: AuraButtonStyle.glassOutline,
                            onPressed: () => _analyze('Screenshot'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AuraButton(
                            text: "Product Photo",
                            icon: Icons.add_a_photo_rounded,
                            height: 42,
                            style: AuraButtonStyle.glassOutline,
                            onPressed: () => _analyze('Photo'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Results Verdict Section
              if (advisorState.isAnalyzing)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(
                          color: AuraColors.auraViolet,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Cross-referencing Digital Twin, Closet & Colour Passport...",
                          style: AuraTypography.bodyMedium(isDark: true),
                        ),
                      ],
                    ),
                  ),
                )
              else if (analysis != null) ...[
                // BUY vs SKIP Glowing Verdict Card
                AuraCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(24),
                  isGlowing: true,
                  glowColor: analysis.isBuy
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
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: (analysis.isBuy
                                      ? AuraColors.auraEmerald
                                      : AuraColors.auraRose)
                                  .withOpacity(0.25),
                              border: Border.all(
                                color: analysis.isBuy
                                    ? AuraColors.auraEmerald
                                    : AuraColors.auraRose,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  analysis.isBuy
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: analysis.isBuy
                                      ? AuraColors.auraEmerald
                                      : AuraColors.auraRose,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  analysis.isBuy
                                      ? "VERDICT: BUY (${analysis.verdictScore.toInt()}% MATCH)"
                                      : "VERDICT: SKIP (${analysis.verdictScore.toInt()}% MATCH)",
                                  style: AuraTypography.title(isDark: true)
                                      .copyWith(
                                    color: analysis.isBuy
                                        ? AuraColors.auraEmerald
                                        : AuraColors.auraRose,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            analysis.priceEstimate,
                            style: AuraTypography.headingMedium(isDark: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Text(
                        analysis.itemName,
                        style: AuraTypography.headingLarge(isDark: true)
                            .copyWith(fontSize: 22),
                      ),
                      Text(
                        "${analysis.brandName} · ${analysis.category}",
                        style: AuraTypography.caption(isDark: true),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 6 Detailed Breakdown Cards
                Text(
                  "AI Compatibility Breakdown",
                  style: AuraTypography.title(isDark: true),
                ),
                const SizedBox(height: 14),

                // 1. Matches Skin Tone
                _buildBreakdownTile(
                  title: "Matches Skin Tone & Season",
                  subtitle: analysis.skinToneExplanation,
                  icon: Icons.palette_rounded,
                  color: analysis.matchesSkinTone
                      ? AuraColors.auraEmerald
                      : AuraColors.auraRose,
                  badge: analysis.matchesSkinTone ? "100% Match" : "Clash",
                ),

                // 2. Matches Wardrobe
                _buildBreakdownTile(
                  title: "Matches Digital Closet",
                  subtitle: analysis.wardrobeExplanation,
                  icon: Icons.checkroom_rounded,
                  color: analysis.matchesWardrobe
                      ? AuraColors.auraCyan
                      : AuraColors.auraRose,
                  badge: analysis.matchesWardrobe ? "High Synergy" : "Low Synergy",
                ),

                // 3. Creates New Outfits
                _buildBreakdownTile(
                  title: "New Outfits Unlocked",
                  subtitle: analysis.newOutfitsExplanation,
                  icon: Icons.layers_rounded,
                  color: AuraColors.auraViolet,
                  badge: "+${analysis.newOutfitsCreatedCount} Outfits",
                ),

                // 4. Value for Money
                _buildBreakdownTile(
                  title: "Value for Money Index",
                  subtitle: analysis.valueForMoneyExplanation,
                  icon: Icons.savings_rounded,
                  color: AuraColors.auraAmber,
                  badge: "${analysis.valueForMoneyScore} / 10",
                ),

                // 5. Alternative Colour Suggestion
                _buildBreakdownTile(
                  title: "Alternative Colour Suggestion",
                  subtitle:
                      "${analysis.alternativeColourName} (${analysis.alternativeColourHex}): ${analysis.alternativeColourExplanation}",
                  icon: Icons.color_lens_rounded,
                  color: AuraColors.auraViolet,
                  badge: "Suggested Colour",
                ),

                // 6. Alternative Brand Suggestion
                _buildBreakdownTile(
                  title: "Alternative Brand Recommendation",
                  subtitle:
                      "${analysis.alternativeBrandName}: ${analysis.alternativeBrandExplanation}",
                  icon: Icons.storefront_rounded,
                  color: AuraColors.auraRose,
                  badge: "Better Value Brand",
                ),

                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String badge,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AuraCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AuraTypography.title(isDark: true)
                            .copyWith(fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: color.withOpacity(0.15),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AuraTypography.caption(isDark: true).copyWith(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
