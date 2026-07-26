import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/router/app_router.dart';
import '../providers/user_profile_provider.dart';

class CreateProfileView extends ConsumerStatefulWidget {
  const CreateProfileView({super.key});

  @override
  ConsumerState<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends ConsumerState<CreateProfileView> {
  final _nameController = TextEditingController(text: "Alex Morgan");
  String _selectedStyle = "Quiet Luxury";

  final List<String> _styles = [
    "Quiet Luxury",
    "Minimalist Tech",
    "Modern Tailored",
    "High Streetwear",
    "Casual Luxe",
    "Avant-Garde",
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
              // Progress Bar Header (Step 1 of 4)
              Row(
                children: [
                  Text(
                    "STEP 1 OF 4",
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
                        width: 30,
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
              const SizedBox(height: 28),

              Text(
                "Personal Baseline",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 8),
              Text(
                "Tell Aura AI your fashion goal and preferred style aesthetic.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 32),

              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Your Name or Alias',
                        labelStyle: AuraTypography.bodyMedium(isDark: true),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AuraColors.textMutedDark,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      "Target Fashion Aesthetic",
                      style: AuraTypography.title(isDark: true),
                    ),
                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _styles.map((style) {
                        final isSelected = style == _selectedStyle;
                        return ChoiceChip(
                          label: Text(style),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedStyle = style);
                          },
                          labelStyle: AuraTypography.bodyMedium(isDark: true).copyWith(
                            color: isSelected ? Colors.white : AuraColors.textSecondaryDark,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          selectedColor: AuraColors.auraViolet,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AuraColors.auraViolet
                                  : AuraColors.glassBorderDark,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              MorphingButton(
                text: "Proceed to AI Face Scan",
                icon: Icons.camera_front_rounded,
                onPressed: () {
                  ref.read(userProfileProvider.notifier).updateProfile(
                        name: _nameController.text.trim(),
                        stylePreference: _selectedStyle,
                      );
                  context.go(AppRoutes.faceScan);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
