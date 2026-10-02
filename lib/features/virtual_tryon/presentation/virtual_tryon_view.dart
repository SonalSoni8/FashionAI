import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../../digital_twin/providers/digital_twin_provider.dart';
import '../../wardrobe/providers/wardrobe_provider.dart';
import '../domain/models/tryon_layer_item.dart';
import '../domain/models/tryon_render_result.dart';
import '../providers/virtual_tryon_provider.dart';

class VirtualTryOnView extends ConsumerStatefulWidget {
  const VirtualTryOnView({super.key});

  @override
  ConsumerState<VirtualTryOnView> createState() => _VirtualTryOnViewState();
}

class _VirtualTryOnViewState extends ConsumerState<VirtualTryOnView> {
  String _selectedCategoryTab = "Tops";

  final List<String> _categoryTabs = ["Outerwear", "Tops", "Bottoms", "Shoes"];

  @override
  Widget build(BuildContext context) {
    final tryOnState = ref.watch(virtualTryOnProvider);
    final twinState = ref.watch(digitalTwinProvider);
    final wardrobeState = ref.watch(wardrobeProvider);

    final twin = twinState.activeTwin;
    final activeGarments = wardrobeState.items
        .where((i) =>
            _selectedCategoryTab == "Tops" && i.category == "Tops" ||
            _selectedCategoryTab == "Bottoms" && i.category == "Bottoms" ||
            _selectedCategoryTab == "Shoes" && i.category == "Shoes" ||
            _selectedCategoryTab == "Outerwear" && i.category == "Outerwear")
        .toList();

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Virtual Try-On Studio",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              tryOnState.showPoseMesh
                  ? Icons.grain_rounded
                  : Icons.blur_off_rounded,
              color: tryOnState.showPoseMesh
                  ? AuraColors.auraEmerald
                  : Colors.white70,
            ),
            onPressed: () {
              ref.read(virtualTryOnProvider.notifier).togglePoseMesh();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Engine Mode Switcher Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                children: [
                  _buildEngineTab(
                    mode: RenderEngineMode.landmarkMesh,
                    label: "3D Landmark Mesh",
                    icon: Icons.hub_rounded,
                    isSelected: tryOnState.selectedEngineMode ==
                        RenderEngineMode.landmarkMesh,
                  ),
                  const SizedBox(width: 8),
                  _buildEngineTab(
                    mode: RenderEngineMode.cloudDiffusion,
                    label: "Cloud Diffusion AI",
                    icon: Icons.auto_awesome_rounded,
                    isSelected: tryOnState.selectedEngineMode ==
                        RenderEngineMode.cloudDiffusion,
                  ),
                  const SizedBox(width: 8),
                  _buildEngineTab(
                    mode: RenderEngineMode.arMesh,
                    label: "Future AR Core",
                    icon: Icons.view_in_ar_rounded,
                    isSelected: tryOnState.selectedEngineMode ==
                        RenderEngineMode.arMesh,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Mannequin Canvas Viewport
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AuraCard(
                  borderRadius: 32,
                  isGlowing: true,
                  glowColor: tryOnState.selectedEngineMode ==
                          RenderEngineMode.cloudDiffusion
                      ? AuraColors.auraViolet
                      : AuraColors.auraEmerald,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base Aura Twin Mannequin Graphic
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.accessibility_new_rounded,
                            size: 190,
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ],
                      ),

                      // Equipped Layer Overlay Cards
                      ...tryOnState.sortedLayers.map((layer) {
                        final color = Color(
                          int.parse(
                            layer.primaryColorHex.replaceFirst('#', '0xFF'),
                          ),
                        );
                        return AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          top: _getLayerTopOffset(layer.category),
                          child: Container(
                            width: 140 * layer.scaleX,
                            height: 60 * layer.scaleY,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                layer.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      // 3D Pose Mesh Overlay Points
                      if (tryOnState.showPoseMesh)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black.withOpacity(0.6),
                              border:
                                  Border.all(color: AuraColors.auraEmerald),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.radar_rounded,
                                  color: AuraColors.auraEmerald,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "33 3D Joints Active (${twin?.bodyShape ?? 'Athletic V-Shape'})",
                                  style: AuraTypography.caption(isDark: true)
                                      .copyWith(
                                    fontSize: 10,
                                    color: AuraColors.auraEmerald,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Processing Spinner Indicator
                      if (tryOnState.isRendering)
                        Container(
                          color: Colors.black45,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AuraColors.auraViolet,
                            ),
                          ),
                        ),

                      // Active Twin Badge (Zero Re-Captures Confirmation)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.black.withOpacity(0.7),
                            border:
                                Border.all(color: AuraColors.glassBorderDark),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mannequin ID: ${twin?.twinId ?? 'TWIN_PRIMARY'}",
                                style: AuraTypography.caption(isDark: true)
                                    .copyWith(fontFamily: 'monospace'),
                              ),
                              Text(
                                tryOnState.lastRenderResult?.styleFeedback ??
                                    "✓ Render Complete",
                                style: AuraTypography.caption(isDark: true)
                                    .copyWith(
                                  color: AuraColors.auraEmerald,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Garment Category Selector Bar
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categoryTabs.length,
                itemBuilder: (context, index) {
                  final cat = _categoryTabs[index];
                  final isSelected = cat == _selectedCategoryTab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategoryTab = cat);
                      },
                      selectedColor: AuraColors.auraViolet,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color: isSelected
                            ? Colors.white
                            : AuraColors.textSecondaryDark,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Garment List with Sequential Wear Action Buttons
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: activeGarments.length,
                itemBuilder: (context, index) {
                  final item = activeGarments[index];
                  final itemColor = Color(
                    int.parse(
                      item.primaryColorHex.replaceFirst('#', '0xFF'),
                    ),
                  );

                  return Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 12),
                    child: GlassCard(
                      borderRadius: 18,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: itemColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white38),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AuraTypography.caption(isDark: true)
                                      .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Sequential Wear Button Trigger
                          AuraButton(
                            text: "Wear",
                            icon: Icons.checkroom_rounded,
                            height: 34,
                            style: AuraButtonStyle.primary,
                            onPressed: () {
                              ref
                                  .read(virtualTryOnProvider.notifier)
                                  .wearGarment(
                                    garmentId: item.id,
                                    name: item.name,
                                    category: _mapCategoryToEnum(item.category),
                                    colorHex: item.primaryColorHex,
                                    zIndex: _getZIndex(item.category),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEngineTab({
    required RenderEngineMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(virtualTryOnProvider.notifier).setEngineMode(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? AuraColors.auraViolet.withOpacity(0.25)
                : Colors.white.withOpacity(0.04),
            border: Border.all(
              color: isSelected
                  ? AuraColors.auraViolet
                  : AuraColors.glassBorderDark,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AuraColors.auraViolet : Colors.white60,
                size: 16,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AuraTypography.caption(isDark: true).copyWith(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AuraColors.textMutedDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getLayerTopOffset(TryOnLayerCategory category) {
    switch (category) {
      case TryOnLayerCategory.outerwear:
        return 70;
      case TryOnLayerCategory.top:
        return 95;
      case TryOnLayerCategory.bottom:
        return 175;
      case TryOnLayerCategory.footwear:
        return 270;
      case TryOnLayerCategory.accessory:
        return 20;
    }
  }

  TryOnLayerCategory _mapCategoryToEnum(String category) {
    switch (category) {
      case 'Outerwear':
        return TryOnLayerCategory.outerwear;
      case 'Tops':
        return TryOnLayerCategory.top;
      case 'Bottoms':
        return TryOnLayerCategory.bottom;
      case 'Shoes':
        return TryOnLayerCategory.footwear;
      default:
        return TryOnLayerCategory.top;
    }
  }

  int _getZIndex(String category) {
    switch (category) {
      case 'Outerwear':
        return 4;
      case 'Tops':
        return 3;
      case 'Bottoms':
        return 2;
      case 'Shoes':
        return 1;
      default:
        return 1;
    }
  }
}
