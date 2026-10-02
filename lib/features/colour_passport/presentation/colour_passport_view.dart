import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/models/colour_recommendation_item.dart';
import '../providers/colour_passport_provider.dart';

class ColourPassportView extends ConsumerStatefulWidget {
  const ColourPassportView({super.key});

  @override
  ConsumerState<ColourPassportView> createState() =>
      _ColourPassportViewState();
}

class _ColourPassportViewState extends ConsumerState<ColourPassportView> {
  void _showExplanationModal(ColourRecommendationItem item) {
    final color = Color(int.parse(item.hex.replaceFirst('#', '0xFF')));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassCard(
          borderRadius: 32,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AuraTypography.title(isDark: true),
                      ),
                      Text(
                        "${item.category} · ${item.hex}",
                        style: AuraTypography.caption(isDark: true).copyWith(
                          color: AuraColors.auraViolet,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "WHY THIS COLOUR MATCHES YOUR DIGITAL TWIN",
                style: AuraTypography.caption(isDark: true).copyWith(
                  letterSpacing: 1.5,
                  color: AuraColors.auraEmerald,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                item.explanation,
                style: AuraTypography.bodyLarge(isDark: true).copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final passport = ref.watch(colourPassportProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AI Colour Passport",
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
              // Hero Seasonal Palette Banner
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AuraColors.auraViolet.withOpacity(0.2),
                          ),
                          child: Text(
                            passport.seasonPalette.toUpperCase(),
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraViolet,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.verified_rounded,
                          color: AuraColors.auraEmerald,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Undertone: ${passport.undertone}",
                      style: AuraTypography.headingMedium(isDark: true),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Contrast: ${passport.contrastLevel}",
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: AuraColors.auraCyan,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Strategy: ${passport.colourHarmonyStrategy}",
                      style: AuraTypography.bodyMedium(isDark: true),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Best Power Colours
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Best Power Colours", style: AuraTypography.title(isDark: true)),
                  Text(
                    "Tap for explanation",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraEmerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: passport.bestColours.length,
                itemBuilder: (context, index) {
                  final item = passport.bestColours[index];
                  return _buildInteractiveSwatchCard(item);
                },
              ),

              const SizedBox(height: 28),

              // Colours to Avoid Near Face
              Text("Colours to Avoid Near Face", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: passport.worstColours.length,
                itemBuilder: (context, index) {
                  final item = passport.worstColours[index];
                  return _buildInteractiveSwatchCard(item, isAvoid: true);
                },
              ),

              const SizedBox(height: 28),

              // Recommended Metals
              Text("Best Metal Accessories", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),
              Column(
                children: passport.bestMetals
                    .map((m) => _buildDetailListTile(m, Icons.watch_rounded, AuraColors.auraAmber))
                    .toList(),
              ),

              const SizedBox(height: 28),

              // Best Hair Colours
              Text("Best Hair Colours", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),
              Column(
                children: passport.bestHairColours
                    .map((h) => _buildDetailListTile(h, Icons.face_retouching_natural_rounded, AuraColors.auraRose))
                    .toList(),
              ),

              const SizedBox(height: 28),

              // Best Makeup Colours
              Text("Best Makeup Palette", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),
              Column(
                children: passport.bestMakeupColours
                    .map((mk) => _buildDetailListTile(mk, Icons.palette_rounded, AuraColors.auraCyan))
                    .toList(),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveSwatchCard(ColourRecommendationItem item, {bool isAvoid = false}) {
    final color = Color(int.parse(item.hex.replaceFirst('#', '0xFF')));

    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.all(12),
      onTap: () => _showExplanationModal(item),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: isAvoid
                ? const Center(
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AuraTypography.caption(isDark: true).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                Text(
                  item.hex,
                  style: AuraTypography.caption(isDark: true).copyWith(
                    fontSize: 10,
                    color: AuraColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailListTile(ColourRecommendationItem item, IconData icon, Color iconColor) {
    final color = Color(int.parse(item.hex.replaceFirst('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        onTap: () => _showExplanationModal(item),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30),
              ),
              child: Icon(icon, color: Colors.white70, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AuraTypography.title(isDark: true).copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.explanation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AuraTypography.caption(isDark: true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.info_outline_rounded,
              color: AuraColors.textMutedDark,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
