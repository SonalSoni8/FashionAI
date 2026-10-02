import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../../../core/widgets/aura_text_field.dart';
import '../../../core/widgets/real_camera_preview_widget.dart';
import '../data/datasources/ai_garment_parser_service.dart';
import '../providers/wardrobe_provider.dart';

class AddGarmentSourcesDialog extends ConsumerStatefulWidget {
  const AddGarmentSourcesDialog({super.key});

  @override
  ConsumerState<AddGarmentSourcesDialog> createState() =>
      _AddGarmentSourcesDialogState();
}

class _AddGarmentSourcesDialogState
    extends ConsumerState<AddGarmentSourcesDialog> {
  final _parserService = AiGarmentParserService();
  final _linkController = TextEditingController();
  final _promptController = TextEditingController();

  bool _isProcessing = false;
  String _activeTab = 'sources'; // 'sources', 'camera', 'link', 'ai_gen'

  void _handlePhotoUpload(String source, {String? imagePath}) async {
    setState(() => _isProcessing = true);
    final path = imagePath ?? 'sample_ingestion_$source.png';
    final garment = await _parserService.parsePhotoOrScreenshot(
      imagePath: path,
      source: source,
    );
    ref.read(wardrobeProvider.notifier).addGarment(garment);
    if (mounted) Navigator.of(context).pop();
  }

  void _handleShoppingLink() async {
    final url = _linkController.text.trim();
    if (url.isEmpty) return;

    setState(() => _isProcessing = true);
    final garment = await _parserService.parseShoppingLink(url);
    ref.read(wardrobeProvider.notifier).addGarment(garment);
    if (mounted) Navigator.of(context).pop();
  }

  void _handleAiGeneration() async {
    final prompt = _promptController.text.trim();
    setState(() => _isProcessing = true);
    final garment = await _parserService.generateAiGarment(prompt);
    ref.read(wardrobeProvider.notifier).addGarment(garment);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AuraCard(
        borderRadius: 28,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAlignment.start,
            children: [
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
                        "Add Clothing Item",
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

              if (_isProcessing)
                Container(
                  height: 180,
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
                        const CircularProgressIndicator(
                          color: AuraColors.auraViolet,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Removing Background & Extracting Attributes...",
                          style: AuraTypography.caption(isDark: true),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_activeTab == 'camera') ...[
                Text(
                  "Capture Garment Photo",
                  style: AuraTypography.title(isDark: true),
                ),
                const SizedBox(height: 6),
                Text(
                  "Position item within reticle for auto background removal.",
                  style: AuraTypography.caption(isDark: true),
                ),
                const SizedBox(height: 16),
                RealCameraPreviewWidget(
                  onPictureTaken: (imagePath) {
                    _handlePhotoUpload('Camera', imagePath: imagePath);
                  },
                ),
                const SizedBox(height: 16),
                AuraButton(
                  text: "Back to Methods",
                  style: AuraButtonStyle.glassOutline,
                  onPressed: () => setState(() => _activeTab = 'sources'),
                ),
              ] else if (_activeTab == 'sources') ...[
                Text(
                  "Choose Ingestion Method",
                  style: AuraTypography.caption(isDark: true).copyWith(
                    color: AuraColors.textMutedDark,
                  ),
                ),
                const SizedBox(height: 14),

                _buildSourceTile(
                  icon: Icons.camera_alt_rounded,
                  color: AuraColors.auraRose,
                  title: "Camera Photo",
                  subtitle: "Take live photo of garment with auto background removal",
                  onTap: () => setState(() => _activeTab = 'camera'),
                ),
                _buildSourceTile(
                  icon: Icons.photo_library_rounded,
                  color: AuraColors.auraViolet,
                  title: "Gallery Photo",
                  subtitle: "Upload existing clothing photo from gallery",
                  onTap: () => _handlePhotoUpload('Gallery'),
                ),
                _buildSourceTile(
                  icon: Icons.screenshot_monitor_rounded,
                  color: AuraColors.auraCyan,
                  title: "Screenshot Ingestion",
                  subtitle: "Auto-crop and isolate garments from screenshot",
                  onTap: () => _handlePhotoUpload('Screenshot'),
                ),
                _buildSourceTile(
                  icon: Icons.link_rounded,
                  color: AuraColors.auraEmerald,
                  title: "Shopping Link URL",
                  subtitle: "Paste product link from Zara, Net-a-Porter, etc.",
                  onTap: () => setState(() => _activeTab = 'link'),
                ),
                _buildSourceTile(
                  icon: Icons.auto_awesome_rounded,
                  color: AuraColors.auraAmber,
                  title: "AI Generated Outfit Studio",
                  subtitle: "Generate synthetic custom clothes from text prompt",
                  onTap: () => setState(() => _activeTab = 'ai_gen'),
                ),
              ] else if (_activeTab == 'link') ...[
                Text(
                  "Paste Shopping Product URL",
                  style: AuraTypography.title(isDark: true),
                ),
                const SizedBox(height: 6),
                Text(
                  "AI will extract garment name, category, fabric & hex colors.",
                  style: AuraTypography.caption(isDark: true),
                ),
                const SizedBox(height: 16),

                AuraTextField(
                  controller: _linkController,
                  label: "Product URL",
                  hint: "https://www.zara.com/item/12345",
                  prefixIcon: Icons.link_rounded,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: AuraButton(
                        text: "Back",
                        style: AuraButtonStyle.glassOutline,
                        onPressed: () => setState(() => _activeTab = 'sources'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AuraButton(
                        text: "Parse Link",
                        icon: Icons.auto_awesome_rounded,
                        onPressed: _handleShoppingLink,
                      ),
                    ),
                  ],
                ),
              ] else if (_activeTab == 'ai_gen') ...[
                Text(
                  "AI Clothing Studio",
                  style: AuraTypography.title(isDark: true),
                ),
                const SizedBox(height: 6),
                Text(
                  "Describe the clothing item you want AI to generate for your wardrobe.",
                  style: AuraTypography.caption(isDark: true),
                ),
                const SizedBox(height: 16),

                AuraTextField(
                  controller: _promptController,
                  label: "Garment Description Prompt",
                  hint: "e.g. Oversized Charcoal Wool Blazer with Peak Lapels",
                  prefixIcon: Icons.sparkles,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: AuraButton(
                        text: "Back",
                        style: AuraButtonStyle.glassOutline,
                        onPressed: () => setState(() => _activeTab = 'sources'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AuraButton(
                        text: "Generate Item",
                        icon: Icons.auto_awesome_rounded,
                        onPressed: _handleAiGeneration,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: AuraColors.glassBorderDark),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.15),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AuraTypography.title(isDark: true)
                          .copyWith(fontSize: 14),
                    ),
                    Text(
                      subtitle,
                      style: AuraTypography.caption(isDark: true),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AuraColors.textMutedDark,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
