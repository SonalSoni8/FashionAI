import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../domain/models/garment_item_entity.dart';
import '../providers/wardrobe_provider.dart';

class AddGarmentDialog extends ConsumerStatefulWidget {
  const AddGarmentDialog({super.key});

  @override
  ConsumerState<AddGarmentDialog> createState() => _AddGarmentDialogState();
}

class _AddGarmentDialogState extends ConsumerState<AddGarmentDialog> {
  final _nameController = TextEditingController();
  final _fabricController = TextEditingController(text: "100% Organic Cotton");

  String _selectedCategory = "Tops";
  String _selectedSubCategory = "Crewneck Tee";
  String _selectedColorHex = "#0F766E";
  double _formalityScore = 6;
  String _seasonality = "All-Season";
  bool _isAnalyzing = false;
  bool _aiAnalysisComplete = false;

  final List<String> _categories = [
    "Outerwear",
    "Tops",
    "Bottoms",
    "Shoes",
    "Accessories",
  ];

  final List<Map<String, String>> _paletteSwatches = [
    {"name": "Emerald Teal", "hex": "#0F766E"},
    {"name": "Obsidian Slate", "hex": "#1E293B"},
    {"name": "Indigo Sapphire", "hex": "#4338CA"},
    {"name": "Crimson Wine", "hex": "#BE123C"},
    {"name": "Charcoal Black", "hex": "#0F172A"},
    {"name": "Ivory Cream", "hex": "#F8FAFC"},
  ];

  void _runAiVisionAnalysis() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _aiAnalysisComplete = true;
        if (_nameController.text.isEmpty) {
          _nameController.text = "Deep Emerald Tailored Garment";
        }
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final newGarment = GarmentItemEntity(
      id: const Uuid().v4(),
      name: name,
      category: _selectedCategory,
      subCategory: _selectedSubCategory,
      primaryColorHex: _selectedColorHex,
      fabric: _fabricController.text.trim(),
      formalityScore: _formalityScore.toInt(),
      seasonality: _seasonality,
      imagePath: '',
      auraTwinMatchScore: '98% Match',
      createdAt: DateTime.now(),
    );

    ref.read(wardrobeProvider.notifier).addGarment(newGarment);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuraColors.auraViolet.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.add_a_photo_rounded,
                          color: AuraColors.auraViolet,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "AI Garment Ingestion",
                        style: AuraTypography.title(isDark: true),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Vision AI Photo Capture Mock Card
              GestureDetector(
                onTap: _runAiVisionAnalysis,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.04),
                    border: Border.all(
                      color: _aiAnalysisComplete
                          ? AuraColors.auraEmerald
                          : AuraColors.glassBorderDark,
                    ),
                  ),
                  child: Center(
                    child: _isAnalyzing
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: AuraColors.auraViolet,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Extracting Color Palette & Fabric Mesh...",
                                style: AuraTypography.caption(isDark: true),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _aiAnalysisComplete
                                    ? Icons.check_circle_rounded
                                    : Icons.camera_alt_rounded,
                                size: 36,
                                color: _aiAnalysisComplete
                                    ? AuraColors.auraEmerald
                                    : AuraColors.auraViolet,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _aiAnalysisComplete
                                    ? "AI Attributes Extracted (98% Match)"
                                    : "Tap to Scan Item with Gemini Vision AI",
                                style: AuraTypography.caption(isDark: true)
                                    .copyWith(
                                  color: _aiAnalysisComplete
                                      ? AuraColors.auraEmerald
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                style: AuraTypography.bodyMedium(isDark: true),
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  labelStyle: AuraTypography.caption(isDark: true),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category Selector
              Text("Category", style: AuraTypography.caption(isDark: true)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AuraColors.auraViolet,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    labelStyle: AuraTypography.caption(isDark: true).copyWith(
                      color: isSelected ? Colors.white : AuraColors.textSecondaryDark,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Primary Color Swatch Selection
              Text("Primary Color Palette",
                  style: AuraTypography.caption(isDark: true)),
              const SizedBox(height: 8),
              Row(
                children: _paletteSwatches.map((swatch) {
                  final colorHex = swatch['hex']!;
                  final isSelected = _selectedColorHex == colorHex;
                  final color = Color(
                    int.parse(colorHex.replaceFirst('#', '0xFF')),
                  );
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = colorHex),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: color.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Formality Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Formality Score",
                      style: AuraTypography.caption(isDark: true)),
                  Text(
                    "${_formalityScore.toInt()} / 10",
                    style: AuraTypography.caption(isDark: true).copyWith(
                      color: AuraColors.auraCyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _formalityScore,
                min: 1,
                max: 10,
                activeColor: AuraColors.auraCyan,
                inactiveColor: AuraColors.glassBorderDark,
                onChanged: (val) => setState(() => _formalityScore = val),
              ),

              const SizedBox(height: 20),

              MorphingButton(
                text: "Save to Digital Closet",
                icon: Icons.checkroom_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
