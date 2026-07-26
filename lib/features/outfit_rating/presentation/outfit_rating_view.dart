import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/widgets/real_camera_preview_widget.dart';
import '../../../core/services/real_gemini_vision_service.dart';

class OutfitRatingView extends StatefulWidget {
  const OutfitRatingView({super.key});

  @override
  State<OutfitRatingView> createState() => _OutfitRatingViewState();
}

class _OutfitRatingViewState extends State<OutfitRatingView> {
  final RealGeminiVisionService _geminiVisionService = RealGeminiVisionService();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedImagePath;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _ratingResult;
  bool _useLiveCamera = false;

  Future<void> _pickFromGallery() async {
    final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedImagePath = file.path;
        _useLiveCamera = false;
      });
    }
  }

  Future<void> _analyzeRealPhoto() async {
    if (_selectedImagePath == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final bytes = await File(_selectedImagePath!).readAsBytes();
      final result = await _geminiVisionService.analyzeOutfitImage(imageBytes: bytes);

      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _ratingResult = result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          "Real AI Outfit Rating",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            // Real Hardware Camera or Photo Picker Frame
            GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(20),
              isGlowing: _ratingResult != null,
              glowColor: AuraColors.auraEmerald,
              child: Column(
                children: [
                  if (_useLiveCamera)
                    RealCameraPreviewWidget(
                      onPictureTaken: (path) {
                        setState(() {
                          _selectedImagePath = path;
                          _useLiveCamera = false;
                        });
                      },
                    )
                  else if (_selectedImagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(_selectedImagePath!),
                        height: 320,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 220,
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
                              Icons.camera_enhance_rounded,
                              size: 54,
                              color: AuraColors.auraViolet.withOpacity(0.8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Capture or Choose Outfit Image",
                              style: AuraTypography.bodyMedium(isDark: true),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Pick source controls
                  Row(
                    children: [
                      Expanded(
                        child: MorphingButton(
                          text: "Live Camera",
                          icon: Icons.camera_alt_rounded,
                          style: MorphingButtonStyle.glassOutline,
                          onPressed: () => setState(() => _useLiveCamera = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MorphingButton(
                          text: "Gallery Photo",
                          icon: Icons.photo_library_rounded,
                          style: MorphingButtonStyle.glassOutline,
                          onPressed: _pickFromGallery,
                        ),
                      ),
                    ],
                  ),

                  if (_selectedImagePath != null) ...[
                    const SizedBox(height: 16),
                    MorphingButton(
                      text: _isAnalyzing
                          ? "Gemini AI Vision Analyzing Image..."
                          : "Analyze Real Outfit Photo",
                      icon: Icons.auto_awesome_rounded,
                      isLoading: _isAnalyzing,
                      onPressed: _analyzeRealPhoto,
                    ),
                  ],
                ],
              ),
            ),

            if (_ratingResult != null) ...[
              const SizedBox(height: 28),

              // Overall Verdict & Scores Grid
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAlignment.start,
                          children: [
                            Text(
                              "DETECTED OUTFIT SCORE",
                              style: AuraTypography.caption(isDark: true).copyWith(
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${_ratingResult!['overallScore']}/100",
                              style: AuraTypography.displayHero(isDark: true).copyWith(
                                color: AuraColors.auraEmerald,
                                fontSize: 42,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AuraColors.auraEmerald.withOpacity(0.15),
                            border: Border.all(color: AuraColors.auraEmerald),
                          ),
                          child: Text(
                            _ratingResult!['verdict'] ?? 'Analyzed Aesthetic',
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraEmerald,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: AuraColors.glassBorderDark),
                    const SizedBox(height: 16),

                    // Sub-Scores
                    Row(
                      children: [
                        _buildSubScore("Color", _ratingResult!['colorScore'] ?? 90),
                        _buildSubScore("Fit", _ratingResult!['fitScore'] ?? 90),
                        _buildSubScore("Occasion", _ratingResult!['occasionScore'] ?? 90),
                        _buildSubScore("Confidence", _ratingResult!['confidenceScore'] ?? 90),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AI Vision Reasoning Explanation Card
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text("GEMINI VISION ANALYSIS", style: AuraTypography.caption(isDark: true)),
                    const SizedBox(height: 8),
                    Text(
                      _ratingResult!['reasoning'] ?? '',
                      style: AuraTypography.bodyLarge(isDark: true),
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

  Widget _buildSubScore(String label, int score) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "$score",
            style: AuraTypography.title(isDark: true).copyWith(
              color: AuraColors.auraViolet,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AuraTypography.caption(isDark: true)),
        ],
      ),
    );
  }
}
