import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/models/garment_item_entity.dart';
import '../domain/models/wardrobe_collection_entity.dart';
import '../providers/wardrobe_provider.dart';
import 'add_garment_sources_dialog.dart';

class WardrobeView extends ConsumerStatefulWidget {
  const WardrobeView({super.key});

  @override
  ConsumerState<WardrobeView> createState() => _WardrobeViewState();
}

class _WardrobeViewState extends ConsumerState<WardrobeView> {
  final _searchController = TextEditingController();

  final List<String> _categories = [
    "All",
    "Outerwear",
    "Tops",
    "Bottoms",
    "Shoes",
    "Accessories"
  ];

  void _openAddGarmentModal() {
    showDialog(
      context: context,
      builder: (context) => const AddGarmentSourcesDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wardrobeState = ref.watch(wardrobeProvider);
    final items = wardrobeState.filteredItems;

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Digital Closet",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              wardrobeState.showFavoritesOnly
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: wardrobeState.showFavoritesOnly
                  ? AuraColors.auraAmber
                  : Colors.white70,
            ),
            onPressed: () {
              ref.read(wardrobeProvider.notifier).toggleFavoritesOnly();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded, color: AuraColors.auraViolet),
            onPressed: _openAddGarmentModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input & Versatility Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref.read(wardrobeProvider.notifier).setSearchQuery(val);
                    },
                    style: AuraTypography.bodyMedium(isDark: true),
                    decoration: InputDecoration(
                      hintText: 'Search by item, pattern, fabric or sleeve...',
                      hintStyle: AuraTypography.caption(isDark: true),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AuraColors.textMutedDark,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  color: Colors.white70),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(wardrobeProvider.notifier)
                                    .setSearchQuery('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Capsule Versatility & Favourites Filter Pill
                  GlassCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome_rounded,
                              color: AuraColors.auraEmerald,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Wardrobe Capsule Score",
                              style: AuraTypography.caption(isDark: true),
                            ),
                          ],
                        ),
                        Text(
                          "${items.length} Items · 96% Versatility",
                          style: AuraTypography.caption(isDark: true).copyWith(
                            color: AuraColors.auraEmerald,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Collections Bar
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: WardrobeCollectionEntity.presets.length,
                itemBuilder: (context, index) {
                  final col = WardrobeCollectionEntity.presets[index];
                  final isSelected =
                      col.id == wardrobeState.selectedCollectionId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(col.name),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          ref
                              .read(wardrobeProvider.notifier)
                              .setCollectionFilter(col.id);
                        }
                      },
                      selectedColor: AuraColors.auraViolet,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color:
                            isSelected ? Colors.white : AuraColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 6),

            // Category Filter Bar
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == wardrobeState.selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          ref.read(wardrobeProvider.notifier).setCategoryFilter(cat);
                        }
                      },
                      selectedColor: AuraColors.auraRose,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color:
                            isSelected ? Colors.white : AuraColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Grid of Wardrobe Items
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.checkroom_rounded,
                            size: 48,
                            color: AuraColors.textMutedDark,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No garments match your filters",
                            style: AuraTypography.bodyLarge(isDark: true),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.76,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final cardColor = Color(
                          int.parse(
                            item.primaryColorHex.replaceFirst('#', '0xFF'),
                          ),
                        );

                        return GlassCard(
                          borderRadius: 22,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              // Visual Garment Render Box
                              Container(
                                height: 85,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: cardColor.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AuraColors.glassBorderDark,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        _getCategoryIcon(item.category),
                                        color: cardColor.computeLuminance() > 0.5
                                            ? Colors.black87
                                            : Colors.white70,
                                        size: 34,
                                      ),
                                    ),

                                    // Match Score Badge
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.auraTwinMatchScore,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: AuraColors.auraEmerald,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Heart Favourite Button
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: IconButton(
                                        icon: Icon(
                                          item.isFavorite
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: item.isFavorite
                                              ? AuraColors.auraRose
                                              : Colors.white70,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(wardrobeProvider.notifier)
                                              .toggleFavorite(item.id);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),

                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    AuraTypography.title(isDark: true).copyWith(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item.category} · ${item.pattern}",
                                    style: AuraTypography.caption(isDark: true)
                                        .copyWith(fontSize: 10),
                                  ),
                                  Text(
                                    item.fabric,
                                    style: AuraTypography.caption(isDark: true)
                                        .copyWith(
                                      color: AuraColors.auraCyan,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // FAB for digitizing new clothing item
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AuraColors.auraViolet,
        onPressed: _openAddGarmentModal,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        label: Text(
          "Add Clothes",
          style: AuraTypography.labelButton(isDark: true).copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Outerwear':
        return Icons.dry_cleaning_rounded;
      case 'Tops':
        return Icons.checkroom_rounded;
      case 'Bottoms':
        return Icons.view_day_rounded;
      case 'Shoes':
        return Icons.roller_skating_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      default:
        return Icons.checkroom_rounded;
    }
  }
}
