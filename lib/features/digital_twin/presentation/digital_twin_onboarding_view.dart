import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../providers/digital_twin_provider.dart';

class DigitalTwinOnboardingView extends ConsumerStatefulWidget {
  const DigitalTwinOnboardingView({super.key});

  @override
  ConsumerState<DigitalTwinOnboardingView> createState() =>
      _DigitalTwinOnboardingViewState();
}

class _DigitalTwinOnboardingViewState
    extends ConsumerState<DigitalTwinOnboardingView> {
  int _currentStep = 0; // 0: Front, 1: Left Side, 2: Right Side, 3: Processing & Result

  void _simulatedCaptureAngle() async {
    final notifier = ref.read(digitalTwinProvider.notifier);

    if (_currentStep == 0) {
      await notifier.captureFrontAngle('front_angle_capture.png');
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      await notifier.captureLeftAngle('left_side_angle_capture.png');
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      await notifier.captureRightAngle('right_side_angle_capture.png');
      setState(() => _currentStep = 3);
      await notifier.generateAndSaveTwin('usr_obsidian_101');
    }
  }

  @override
  Widget build(BuildContext context) {
    final twinState = ref.watch(digitalTwinProvider);
    final twin = twinState.activeTwin;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Step Header Progress Indicator
              Row(
                children: [
                  Text(
                    "DIGITAL TWIN ONBOARDING",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraViolet,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "STEP ${_currentStep + 1} OF 4",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraEmerald,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                _currentStep == 3
                    ? "Your Permanent Mannequin"
                    : "Create Digital Twin",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                _currentStep == 3
                    ? "This Digital Twin is your permanent fitting mannequin stored in Supabase."
                    : "Follow the camera reticle to capture Front, Left Side & Right Side profiles.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              if (_currentStep < 3) ...[
                // Viewfinder Framing Card
                AuraCard(
                  borderRadius: 32,
                  isGlowing: true,
                  glowColor: AuraColors.auraViolet,
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Viewfinder Framing Outline
                        Icon(
                          _currentStep == 0
                              ? Icons.person_rounded
                              : (_currentStep == 1
                                  ? Icons.subdirectory_arrow_right_rounded
                                  : Icons.subdirectory_arrow_left_rounded),
                          size: 180,
                          color: AuraColors.auraViolet.withOpacity(0.35),
                        ),

                        Positioned(
                          top: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black.withOpacity(0.6),
                              border:
                                  Border.all(color: AuraColors.glassBorderDark),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.center_focus_strong_rounded,
                                  color: AuraColors.auraCyan,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _currentStep == 0
                                      ? "CAPTURE FRONT PHOTO"
                                      : (_currentStep == 1
                                          ? "CAPTURE LEFT SIDE PROFILE"
                                          : "CAPTURE RIGHT SIDE PROFILE"),
                                  style: AuraTypography.caption(isDark: true)
                                      .copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (twinState.currentQualityReport != null)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AuraColors.auraEmerald.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AuraColors.auraEmerald,
                                ),
                              ),
                              child: Text(
                                twinState.currentQualityReport!.feedbackMessage,
                                textAlign: TextAlign.center,
                                style: AuraTypography.caption(isDark: true)
                                    .copyWith(
                                  color: AuraColors.auraEmerald,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                AuraButton(
                  text: _currentStep == 0
                      ? "Capture Front Angle"
                      : (_currentStep == 1
                          ? "Capture Left Side Profile"
                          : "Capture Right Side Profile"),
                  icon: Icons.camera_alt_rounded,
                  isLoading: twinState.isProcessing,
                  onPressed: _simulatedCaptureAngle,
                ),
              ] else if (twin != null) ...[
                // Permanent Mannequin Result Card
                AuraCard(
                  borderRadius: 28,
                  isGlowing: true,
                  glowColor: AuraColors.auraEmerald,
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AuraColors.auraEmerald.withOpacity(0.2),
                            ),
                            child: Text(
                              "PERMANENT MANNEQUIN VAULT",
                              style: AuraTypography.caption(isDark: true)
                                  .copyWith(
                                color: AuraColors.auraEmerald,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            twin.twinId,
                            style: AuraTypography.caption(isDark: true)
                                .copyWith(fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text(
                        "Silhouette: ${twin.bodyShape}",
                        style: AuraTypography.title(isDark: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Height ${twin.heightCm.toInt()} cm · Shoulder ${twin.shoulderWidthCm} cm · Chest ${twin.chestWidthCm} cm · Waist ${twin.waistWidthCm} cm · Hip ${twin.hipWidthCm} cm",
                        style: AuraTypography.bodyMedium(isDark: true),
                      ),

                      const SizedBox(height: 20),

                      // Feature Color Palette Swatches
                      Row(
                        children: [
                          _buildSwatchBadge("Skin Tone", twin.skinToneHex, twin.skinToneName),
                          const SizedBox(width: 10),
                          _buildSwatchBadge("Hair Color", twin.hairColourHex, twin.hairColourName),
                          const SizedBox(width: 10),
                          _buildSwatchBadge("Eye Color", twin.eyeColourHex, twin.eyeColourName),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.04),
                          border: Border.all(color: AuraColors.glassBorderDark),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cloud_done_rounded,
                              color: AuraColors.auraEmerald,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Synced to Supabase table digital_twins & local Hive vault.",
                                style: AuraTypography.caption(isDark: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                AuraButton(
                  text: "Open Fitting Studio Dashboard",
                  icon: Icons.checkroom_rounded,
                  onPressed: () => context.go(AppRoutes.dashboard),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwatchBadge(String label, String hex, String name) {
    final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: AuraColors.glassBorderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: AuraTypography.caption(isDark: true).copyWith(
                      fontSize: 10,
                      color: AuraColors.textMutedDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
