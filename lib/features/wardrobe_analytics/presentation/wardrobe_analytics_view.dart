import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/wardrobe_analytics_provider.dart';

class WardrobeAnalyticsView extends ConsumerWidget {
  const WardrobeAnalyticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(wardrobeAnalyticsProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Fashion Intelligence Analytics",
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
              // Top Score & Confidence Meter Hero Header
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      borderRadius: 28,
                      padding: const EdgeInsets.all(20),
                      isGlowing: true,
                      glowColor: AuraColors.auraViolet,
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.health_and_safety_rounded,
                                color: AuraColors.auraViolet,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "CLOSET SCORE",
                                style: AuraTypography.caption(isDark: true).copyWith(
                                  letterSpacing: 1.2,
                                  color: AuraColors.auraViolet,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${analytics.closetScore} / 100",
                            style: AuraTypography.displayHero(isDark: true).copyWith(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "High Versatility Rating",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraEmerald,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: GlassCard(
                      borderRadius: 28,
                      padding: const EdgeInsets.all(20),
                      isGlowing: true,
                      glowColor: AuraColors.auraEmerald,
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: AuraColors.auraEmerald,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "CONFIDENCE SCORE",
                                style: AuraTypography.caption(isDark: true).copyWith(
                                  letterSpacing: 1.2,
                                  color: AuraColors.auraEmerald,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${analytics.confidenceScore}%",
                            style: AuraTypography.displayHero(isDark: true).copyWith(
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Aligned to Digital Twin",
                            style: AuraTypography.caption(isDark: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Outfit Variety & Style Evolution Metric Tiles
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      borderRadius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraCyan.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.layers_rounded,
                              color: AuraColors.auraCyan,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Text(
                                "Outfit Variety",
                                style: AuraTypography.caption(isDark: true),
                              ),
                              Text(
                                "${analytics.outfitVarietyCount} Outfits",
                                style: AuraTypography.title(isDark: true).copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      borderRadius: 22,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraRose.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.trending_up_rounded,
                              color: AuraColors.auraRose,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                Text(
                                  "Style Evolution",
                                  style: AuraTypography.caption(isDark: true),
                                ),
                                Text(
                                  "Quiet Luxury",
                                  overflow: TextOverflow.ellipsis,
                                  style: AuraTypography.title(isDark: true).copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Colour Balance Spectrum Chart
              Text("Colour Balance & Most Worn Colours", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    // Horizontal Color Spectrum Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 20,
                        child: Row(
                          children: analytics.colourBalance.map((item) {
                            final color = Color(int.parse(item.hex.replaceFirst('#', '0xFF')));
                            return Expanded(
                              flex: item.percentage.toInt(),
                              child: Container(color: color),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Swatch Breakdown List
                    Column(
                      children: analytics.colourBalance.map((item) {
                        final color = Color(int.parse(item.hex.replaceFirst('#', '0xFF')));
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white24),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item.name,
                                style: AuraTypography.title(isDark: true).copyWith(fontSize: 14),
                              ),
                              const Spacer(),
                              Text(
                                "${item.percentage.toInt()}% (${item.itemCount} items)",
                                style: AuraTypography.caption(isDark: true).copyWith(
                                  color: AuraColors.auraEmerald,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Season Readiness Progress Bars
              Text("Season Readiness Coverage", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: analytics.seasonReadiness.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key, style: AuraTypography.title(isDark: true).copyWith(fontSize: 14)),
                              Text(
                                "${entry.value.toInt()}% Ready",
                                style: AuraTypography.caption(isDark: true).copyWith(
                                  color: AuraColors.auraViolet,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: entry.value / 100.0,
                              minHeight: 8,
                              backgroundColor: Colors.white.withOpacity(0.08),
                              valueColor: const AlwaysStoppedAnimation<Color>(AuraColors.auraViolet),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // Favourite Brands Share
              Text("Favourite Brands Share", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: analytics.favouriteBrands.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.storefront_rounded, color: AuraColors.auraRose, size: 18),
                          const SizedBox(width: 10),
                          Text(entry.key, style: AuraTypography.title(isDark: true).copyWith(fontSize: 14)),
                          const Spacer(),
                          Text(
                            "${entry.value.toInt()}% of closet",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraRose,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              // Unused Clothes Recycling Alert
              Text("Unused Clothes Alert (>60 Days)", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                isGlowing: true,
                glowColor: AuraColors.auraAmber,
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AuraColors.auraAmber, size: 22),
                        const SizedBox(width: 10),
                        Text(
                          "${analytics.unusedClothesCount} Items Unworn",
                          style: AuraTypography.title(isDark: true).copyWith(color: AuraColors.auraAmber),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: analytics.unusedItemNames
                          .map((name) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "• $name",
                                  style: AuraTypography.bodyMedium(isDark: true),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // AI Shopping Gap Suggestions
              Text("AI Shopping Gap Suggestions", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: analytics.shoppingSuggestions
                      .map((suggestion) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAlignment.start,
                              children: [
                                const Icon(Icons.lightbulb_outline_rounded, color: AuraColors.auraEmerald, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    suggestion,
                                    style: AuraTypography.bodyMedium(isDark: true),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
