import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../../../core/widgets/aura_text_field.dart';

class CreateProfileView extends ConsumerStatefulWidget {
  const CreateProfileView({super.key});

  @override
  ConsumerState<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends ConsumerState<CreateProfileView> {
  final _nameController = TextEditingController(text: "Alex Morgan");
  final _handleController = TextEditingController(text: "@alexmorgan");
  String _selectedGender = "female";
  String _selectedStylePersona = "Quiet Luxury";
  double _heightCm = 180.0;
  bool _isLoading = false;

  final List<String> _stylePersonas = [
    "Quiet Luxury",
    "High-Streetwear",
    "Classic Sartorial",
    "Minimalist Capsule"
  ];

  void _finishProfileSetup() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);

    if (mounted) {
      context.push(AppRoutes.digitalTwinOnboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile Setup · Step 2 of 2",
          style: AuraTypography.title(isDark: true),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                "Personalize Your Identity",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "This metadata initializes your permanent Aura DNA™ genome and Digital Twin measurements.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              AuraCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    // Profile Photo Avatar
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AuraColors.auraGradientPrimary,
                            ),
                            child: const Center(
                              child: Text(
                                "AM",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AuraColors.auraViolet,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    AuraTextField(
                      controller: _nameController,
                      label: "Full Display Name",
                      hint: "Alex Morgan",
                      prefixIcon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 14),

                    AuraTextField(
                      controller: _handleController,
                      label: "Social Handle",
                      hint: "@alexmorgan",
                      prefixIcon: Icons.alternate_email_rounded,
                    ),
                    const SizedBox(height: 20),

                    // Gender Preference Selection
                    Text(
                      "Gender Preference",
                      style: AuraTypography.caption(isDark: true).copyWith(
                        color: AuraColors.textMutedDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _buildGenderChip("Female", "female"),
                        const SizedBox(width: 10),
                        _buildGenderChip("Male", "male"),
                        const SizedBox(width: 10),
                        _buildGenderChip("Unisex", "unisex"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Style Persona Archetype Selection
                    Text(
                      "Preferred Style Persona",
                      style: AuraTypography.caption(isDark: true).copyWith(
                        color: AuraColors.textMutedDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _stylePersonas.map((persona) {
                        final isSelected = _selectedStylePersona == persona;
                        return ChoiceChip(
                          label: Text(persona),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedStylePersona = persona);
                          },
                          selectedColor: AuraColors.auraViolet,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          labelStyle: AuraTypography.caption(isDark: true).copyWith(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Height Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Height",
                          style: AuraTypography.caption(isDark: true).copyWith(
                            color: AuraColors.textMutedDark,
                          ),
                        ),
                        Text(
                          "${_heightCm.toInt()} cm",
                          style: AuraTypography.title(isDark: true).copyWith(
                            color: AuraColors.auraEmerald,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 140,
                      max: 220,
                      activeColor: AuraColors.auraViolet,
                      inactiveColor: Colors.white.withOpacity(0.1),
                      onChanged: (val) => setState(() => _heightCm = val),
                    ),
                    const SizedBox(height: 24),

                    AuraButton(
                      text: "Save Profile & Create Digital Twin",
                      icon: Icons.arrow_forward_rounded,
                      isLoading: _isLoading,
                      onPressed: _finishProfileSetup,
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

  Widget _buildGenderChip(String label, String value) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? AuraColors.auraViolet.withOpacity(0.2)
                : Colors.white.withOpacity(0.04),
            border: Border.all(
              color: isSelected
                  ? AuraColors.auraViolet
                  : AuraColors.glassBorderDark,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AuraTypography.caption(isDark: true).copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
