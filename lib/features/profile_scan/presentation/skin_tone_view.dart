import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/router/app_router.dart';
import '../providers/user_profile_provider.dart';

class SkinToneView extends ConsumerStatefulWidget {
  const SkinToneView({super.key});

  @override
  ConsumerState<SkinToneView> createState() => _SkinToneViewState();
}

class _SkinToneViewState extends ConsumerState<SkinToneView> {
  final List<Color> _bestColors = const [
    Color(0xFF0F766E), // Emerald Teal
    Color(0xFF4338CA), // Deep Sapphire Indigo
    Color(0xFF1E293B), // Charcoal Slate
    Color(0xFFBE123C), // Crimson Wine
  ];

  final List<Color> _worstColors = const [
    Color(0xFFD97706), // Muted Mustard
    Color(0xFFFB7185), // Pale Neon Salmon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Progress Bar Header (Step 4 of 4)
              Row(
                children: [
                  Text(
                    "STEP 4 OF 4",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraViolet,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AuraColors.glassBorderDark,
                    ),
                    child: Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AuraColors.auraEmerald,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "Skin Tone & Undertone",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "AI colorimetry determined your optimal seasonal clothing palette.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              // Season Palette Card
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
                            "DEEP AUTUMN / COOL WINTER",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraViolet,
                              fontWeight: FontWeight.w700,
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
                      "Undertone: Golden Warm Olive",
                      style: AuraTypography.title(isDark: true),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "High contrast saturation compliments deep rich jewel tones and crisp dark neutral staples.",
                      style: AuraTypography.bodyMedium(isDark: true),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Best Colors Section
              Text("Your Best Power Colors", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 12),
              Row(
                children: _bestColors
                    .map(
                      (c) => Expanded(
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Colors to Avoid Section
              Text("Colors to Avoid Near Face", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 12),
              Row(
                children: _worstColors
                    .map(
                      (c) => Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Metals & Accessories Card
              GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const Icon(
                      Icons.watch_rounded,
                      color: AuraColors.auraAmber,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Text(
                          "Recommended Metals",
                          style: AuraTypography.title(isDark: true).copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "Brushed Platinum, Brushed Silver & Matte Black",
                          style: AuraTypography.bodyMedium(isDark: true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              MorphingButton(
                text: "Complete AI Setup & Open Dashboard",
                icon: Icons.sparkles,
                onPressed: () {
                  ref.read(userProfileProvider.notifier).updateProfile(
                        isScanComplete: true,
                      );
                  context.go(AppRoutes.dashboard);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
