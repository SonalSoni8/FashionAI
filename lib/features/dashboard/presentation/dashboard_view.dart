import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/widgets/spring_slide.dart';
import '../../../core/router/app_router.dart';
import '../../profile_scan/providers/user_profile_provider.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Top Header with User Greeting & Profile Avatar Glow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        "GOOD MORNING",
                        style: AuraTypography.caption(isDark: true).copyWith(
                          letterSpacing: 2.0,
                          color: AuraColors.textMutedDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.name,
                        style: AuraTypography.headingMedium(isDark: true),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AuraColors.auraGradientPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: AuraColors.auraViolet.withOpacity(0.4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weather & Daily Recommendation Main Hero Card
              SpringSlide(
                child: GlassCard(
                  borderRadius: 32,
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
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.wb_sunny_rounded,
                                  color: AuraColors.auraAmber,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "72°F · Clear Skies",
                                  style: AuraTypography.caption(isDark: true).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "98% MATCH",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraEmerald,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Today's Curated Outfit",
                        style: AuraTypography.headingLarge(isDark: true).copyWith(
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Unstructured Charcoal Linen Blazer + Off-White Supima Tee + Slim Dark Trousers + Minimalist Leather Sneakers.",
                        style: AuraTypography.bodyLarge(isDark: true),
                      ),
                      const SizedBox(height: 20),
                      MorphingButton(
                        text: "Ask AI Stylist to Modify",
                        icon: Icons.auto_awesome_rounded,
                        style: MorphingButtonStyle.glassOutline,
                        height: 48,
                        onPressed: () => context.push(AppRoutes.aiStylist),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Core Feature Navigation Grid
              Text("Stylist Workspaces", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(18),
                      onTap: () => context.push(AppRoutes.outfitRating),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraRose.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AuraColors.auraRose,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Rate Outfit",
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text("AI Score & Pros/Cons", style: AuraTypography.caption(isDark: true)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(18),
                      onTap: () => context.push(AppRoutes.wardrobe),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraCyan.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.checkroom_rounded,
                              color: AuraColors.auraCyan,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Digital Closet",
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text("42 Owned Items", style: AuraTypography.caption(isDark: true)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(18),
                      onTap: () => context.push(AppRoutes.occasionPlanner),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraViolet.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.event_seat_rounded,
                              color: AuraColors.auraViolet,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Occasions",
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text("Weddings & Office", style: AuraTypography.caption(isDark: true)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(18),
                      onTap: () => context.push(AppRoutes.packingAssistant),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuraColors.auraAmber.withOpacity(0.15),
                            ),
                            child: const Icon(
                              Icons.luggage_rounded,
                              color: AuraColors.auraAmber,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Packing List",
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text("Smart Trip Checklist", style: AuraTypography.caption(isDark: true)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Shopping Link Advisor Action Banner
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(18),
                onTap: () => context.push(AppRoutes.shoppingAdvisor),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AuraColors.auraEmerald.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AuraColors.auraEmerald,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Text(
                            "Shopping Link Advisor",
                            style: AuraTypography.title(isDark: true).copyWith(fontSize: 16),
                          ),
                          Text(
                            "Paste item URL to evaluate Buy vs Skip before purchasing.",
                            style: AuraTypography.bodyMedium(isDark: true),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AuraColors.textMutedDark,
                      size: 16,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // Floating AI Stylist FAB Trigger
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AuraColors.auraViolet,
        onPressed: () => context.push(AppRoutes.aiStylist),
        icon: const Icon(Icons.sparkles, color: Colors.white),
        label: Text(
          "Ask Aura AI",
          style: AuraTypography.labelButton(isDark: true).copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
