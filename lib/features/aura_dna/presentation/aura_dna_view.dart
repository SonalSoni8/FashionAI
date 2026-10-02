import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/aura_dna_provider.dart';

class AuraDnaView extends ConsumerWidget {
  const AuraDnaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dna = ref.watch(auraDnaProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: AuraColors.auraGradientPrimary,
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Aura DNA™ Master Passport",
              style: AuraTypography.title(isDark: true),
            ),
          ],
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
              // Hero Passport Header Card
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AuraColors.auraGradientPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: AuraColors.auraViolet.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dna.userName,
                                style: AuraTypography.headingLarge(isDark: true).copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AuraColors.auraEmerald.withOpacity(0.2),
                                ),
                                child: Text(
                                  "${dna.confidenceScore}% CONFIDENCE",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AuraColors.auraEmerald,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ID: ${dna.twinId} · ${dna.stylePersonality}",
                            style: AuraTypography.caption(isDark: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text("Master Genome Profile", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              // 1. Digital Twin & Body Shape
              _buildSectionCard(
                icon: Icons.accessibility_new_rounded,
                color: AuraColors.auraViolet,
                title: "Digital Twin & Body Profile",
                children: [
                  _buildMetricRow("Mannequin ID", dna.twinId),
                  _buildMetricRow("Height", "${dna.heightCm.toInt()} cm"),
                  _buildMetricRow("Body Shape Archetype", dna.bodyShape),
                  _buildMetricRow("3D Joints", "33 Pose Landmarks Synced"),
                ],
              ),

              // 2. Skin Tone & Colour Passport
              _buildSectionCard(
                icon: Icons.palette_rounded,
                color: AuraColors.auraRose,
                title: "Skin Tone & Colour Passport",
                children: [
                  _buildMetricRow("Skin Tone Classification", dna.skinToneName),
                  _buildMetricRow("Skin RGB Hex", dna.skinToneHex),
                  _buildMetricRow("Seasonal Palette", dna.seasonalPalette),
                ],
              ),

              // 3. Digital Closet Summary
              _buildSectionCard(
                icon: Icons.checkroom_rounded,
                color: AuraColors.auraCyan,
                title: "Digital Closet & Versatility",
                children: [
                  _buildMetricRow("Total Owned Items", "${dna.wardrobeItemCount} Items"),
                  _buildMetricRow("Capsule Versatility Score", "${dna.closetVersatilityScore}%"),
                ],
              ),

              // 4. Favourite Brands, Colours & Fits
              _buildSectionCard(
                icon: Icons.star_rounded,
                color: AuraColors.auraAmber,
                title: "Favourite Brands, Colours & Fits",
                children: [
                  _buildMetricRow("Sartorial Houses", dna.favouriteBrands.join(', ')),
                  _buildMetricRow("Primary Swatches", dna.favouriteColours.join(', ')),
                  _buildMetricRow("Preferred Fits", dna.favouriteFits.join(', ')),
                ],
              ),

              // 5. Shopping Behaviour & Style Personality
              _buildSectionCard(
                icon: Icons.psychology_rounded,
                color: AuraColors.auraEmerald,
                title: "Shopping Behaviour & Personality",
                children: [
                  _buildMetricRow("Shopping Archetype", dna.shoppingBehaviour),
                  _buildMetricRow("Style Personality", dna.stylePersonality),
                  _buildMetricRow("Fashion Evolution", dna.fashionEvolutionStage),
                ],
              ),

              // 6. AI Learning Engine Vector
              _buildSectionCard(
                icon: Icons.auto_awesome_rounded,
                color: AuraColors.auraViolet,
                title: "AI Learning Engine Vector",
                children: [
                  _buildMetricRow("Fit Preference Weight", "${(dna.aiLearning.fitWeight * 100).toInt()}%"),
                  _buildMetricRow("Colour Preference Weight", "${(dna.aiLearning.colorWeight * 100).toInt()}%"),
                  _buildMetricRow("Brand Preference Weight", "${(dna.aiLearning.brandWeight * 100).toInt()}%"),
                  _buildMetricRow("Status", dna.aiLearning.learningModelStatus),
                ],
              ),

              // 7. Outfit History Logs
              _buildSectionCard(
                icon: Icons.history_rounded,
                color: AuraColors.auraCyan,
                title: "Outfit History Log",
                children: dna.outfitHistory
                    .map((log) => _buildLogTile(log.title, "${log.description} · ${log.ratingOrVerdict}"))
                    .toList(),
              ),

              // 8. Shopping History Logs
              _buildSectionCard(
                icon: Icons.shopping_bag_rounded,
                color: AuraColors.auraRose,
                title: "Shopping Decision History",
                children: dna.shoppingHistory
                    .map((log) => _buildLogTile(log.title, "${log.description} · ${log.ratingOrVerdict}"))
                    .toList(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color color,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: AuraTypography.title(isDark: true).copyWith(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(children: children),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Text(
            "$label: ",
            style: AuraTypography.caption(isDark: true).copyWith(
              color: AuraColors.textMutedDark,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: AuraColors.auraViolet),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Text(
                  title,
                  style: AuraTypography.caption(isDark: true).copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: AuraTypography.caption(isDark: true).copyWith(
                    fontSize: 10,
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
