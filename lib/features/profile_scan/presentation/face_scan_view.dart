import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/router/app_router.dart';
import '../providers/user_profile_provider.dart';

class FaceScanView extends ConsumerStatefulWidget {
  const FaceScanView({super.key});

  @override
  ConsumerState<FaceScanView> createState() => _FaceScanViewState();
}

class _FaceScanViewState extends ConsumerState<FaceScanView>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanLineAnimation;
  bool _isScanning = false;
  bool _scanComplete = false;

  final List<Map<String, String>> _metrics = [
    {"label": "Face Shape", "value": "Angular Oval (96% symmetry)"},
    {"label": "Eye Color", "value": "Deep Charcoal / Hazel"},
    {"label": "Hair Contrast", "value": "High Contrast Dark Espresso"},
    {"label": "Facial Glasses Fit", "value": "Optimal for Geometric Frames"},
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(_scanController);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _triggerScan() async {
    setState(() {
      _isScanning = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isScanning = false;
        _scanComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Progress Bar Header (Step 2 of 4)
              Row(
                children: [
                  Text(
                    "STEP 2 OF 4",
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
                        width: 60,
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
                "AI Face Analysis",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Scanning geometry for necklines, collar styles & glasses framing.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              // Camera Viewfinder Simulation Frame
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Viewfinder Glass Card Container
                        GlassCard(
                          borderRadius: 32,
                          isGlowing: _isScanning || _scanComplete,
                          glowColor: _scanComplete
                              ? AuraColors.auraEmerald
                              : AuraColors.auraViolet,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Mock face portrait outline
                              Icon(
                                Icons.face_retouching_natural_rounded,
                                size: 160,
                                color: _scanComplete
                                    ? AuraColors.auraEmerald.withOpacity(0.6)
                                    : AuraColors.auraViolet.withOpacity(0.4),
                              ),

                              // Scanning laser beam line animation
                              if (_isScanning)
                                AnimatedBuilder(
                                  animation: _scanLineAnimation,
                                  builder: (context, child) => Positioned(
                                    top: MediaQuery.of(context).size.height *
                                        0.4 *
                                        _scanLineAnimation.value,
                                    left: 20,
                                    right: 20,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: AuraColors.auraCyan,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AuraColors.auraCyan,
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        if (_scanComplete)
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: GlassCard(
                              borderRadius: 20,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _metrics
                                    .map(
                                      (m) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              m['label']!,
                                              style: AuraTypography.caption(isDark: true),
                                            ),
                                            Text(
                                              m['value']!,
                                              style: AuraTypography.caption(isDark: true)
                                                  .copyWith(
                                                color: AuraColors.auraEmerald,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              MorphingButton(
                text: _scanComplete
                    ? "Proceed to Body Analysis"
                    : (_isScanning ? "Analyzing Facial Metrics..." : "Start AI Face Scan"),
                icon: _scanComplete ? Icons.arrow_forward_rounded : Icons.radar_rounded,
                isLoading: _isScanning,
                onPressed: () {
                  if (!_scanComplete) {
                    _triggerScan();
                  } else {
                    ref.read(userProfileProvider.notifier).updateProfile(
                          faceShape: "Angular Oval",
                        );
                    context.go(AppRoutes.bodyScan);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
