import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';

class VirtualTryOnView extends StatelessWidget {
  const VirtualTryOnView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          "AI Virtual Try-On (Beta)",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Column(
                  children: [
                    Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.04),
                        border: Border.all(color: AuraColors.glassBorderDark),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.boy_rounded,
                              size: 72,
                              color: AuraColors.auraViolet.withOpacity(0.8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Modular VTO Pipeline Ready",
                              style: AuraTypography.title(isDark: true),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Renders 3D mesh draped garments over your 3D scan avatar.",
                              textAlign: TextAlign.center,
                              style: AuraTypography.bodyMedium(isDark: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MorphingButton(
                      text: "Simulate Garment Draping",
                      icon: Icons.auto_awesome_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
