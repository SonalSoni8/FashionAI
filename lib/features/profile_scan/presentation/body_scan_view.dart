import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/router/app_router.dart';
import '../providers/user_profile_provider.dart';

class BodyScanView extends ConsumerStatefulWidget {
  const BodyScanView({super.key});

  @override
  ConsumerState<BodyScanView> createState() => _BodyScanViewState();
}

class _BodyScanViewState extends ConsumerState<BodyScanView> {
  String _selectedBodyType = "Athletic V-Shape";
  double _heightCm = 180;
  double _shoulderRatio = 1.25;

  final List<Map<String, String>> _bodyTypes = [
    {"title": "Athletic V-Shape", "sub": "Broad shoulders, slim waist"},
    {"title": "Rectangle / Lean", "sub": "Balanced shoulders and hips"},
    {"title": "Trapezoid", "sub": "Classic balanced athletic frame"},
    {"title": "Inverted Triangle", "sub": "Strong upper torso emphasis"},
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
              // Progress Bar Header (Step 3 of 4)
              Row(
                children: [
                  Text(
                    "STEP 3 OF 4",
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 90,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AuraColors.auraViolet,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "Body Proportions",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Ensures clothing silhouettes, lapel width, and pants rise fit impeccably.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              // Height Slider Card
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Height", style: AuraTypography.title(isDark: true)),
                        Text(
                          "${_heightCm.toInt()} cm / ${(_heightCm / 30.48).toStringAsFixed(1)} ft",
                          style: AuraTypography.title(isDark: true).copyWith(
                            color: AuraColors.auraViolet,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 150,
                      max: 210,
                      activeColor: AuraColors.auraViolet,
                      inactiveColor: AuraColors.glassBorderDark,
                      onChanged: (val) => setState(() => _heightCm = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Shoulder Ratio Slider Card
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Shoulder-to-Waist Ratio", style: AuraTypography.title(isDark: true)),
                        Text(
                          _shoulderRatio.toStringAsFixed(2),
                          style: AuraTypography.title(isDark: true).copyWith(
                            color: AuraColors.auraRose,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _shoulderRatio,
                      min: 1.0,
                      max: 1.6,
                      activeColor: AuraColors.auraRose,
                      inactiveColor: AuraColors.glassBorderDark,
                      onChanged: (val) => setState(() => _shoulderRatio = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text("Select Body Silhouette", style: AuraTypography.title(isDark: true)),
              const SizedBox(height: 14),

              // Body Type Selection Cards
              Column(
                children: _bodyTypes.map((b) {
                  final isSelected = b['title'] == _selectedBodyType;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16),
                      isGlowing: isSelected,
                      glowColor: AuraColors.auraViolet,
                      onTap: () => setState(() => _selectedBodyType = b['title']!),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: isSelected
                                ? AuraColors.auraViolet
                                : AuraColors.textMutedDark,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Text(
                                b['title']!,
                                style: AuraTypography.title(isDark: true).copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                b['sub']!,
                                style: AuraTypography.bodyMedium(isDark: true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              MorphingButton(
                text: "Proceed to Skin Tone Analysis",
                icon: Icons.palette_rounded,
                onPressed: () {
                  ref.read(userProfileProvider.notifier).updateProfile(
                        bodyType: _selectedBodyType,
                      );
                  context.go(AppRoutes.skinTone);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
