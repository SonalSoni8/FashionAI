import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';

class WardrobeItem {
  final String name;
  final String category;
  final Color color;
  final String tag;

  const WardrobeItem({
    required this.name,
    required this.category,
    required this.color,
    required this.tag,
  });
}

class WardrobeView extends StatefulWidget {
  const WardrobeView({super.key});

  @override
  State<WardrobeView> createState() => _WardrobeViewState();
}

class _WardrobeViewState extends State<WardrobeView> {
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Outerwear",
    "Tops",
    "Bottoms",
    "Shoes",
    "Accessories"
  ];

  final List<WardrobeItem> _items = const [
    WardrobeItem(
      name: "Unstructured Charcoal Blazer",
      category: "Outerwear",
      color: Color(0xFF1E293B),
      tag: "Wool Blend",
    ),
    WardrobeItem(
      name: "Off-White Supima Crewneck",
      category: "Tops",
      color: Color(0xFFF8FAFC),
      tag: "100% Cotton",
    ),
    WardrobeItem(
      name: "Deep Emerald Silk Shirt",
      category: "Tops",
      color: Color(0xFF0F766E),
      tag: "Silk Satin",
    ),
    WardrobeItem(
      name: "Slim Slate Tailored Trousers",
      category: "Bottoms",
      color: Color(0xFF334155),
      tag: "Tailored Fit",
    ),
    WardrobeItem(
      name: "Minimalist White Leather Low-Tops",
      category: "Shoes",
      color: Color(0xFFF1F5F9),
      tag: "Calfskin",
    ),
    WardrobeItem(
      name: "Matte Black Acetate Sunglasses",
      category: "Accessories",
      color: Color(0xFF0F172A),
      tag: "UV400",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == "All"
        ? _items
        : _items.where((i) => i.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
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
            icon: const Icon(Icons.add_a_photo_rounded, color: AuraColors.auraViolet),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Bar
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedCategory = cat);
                      },
                      selectedColor: AuraColors.auraViolet,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      labelStyle: AuraTypography.caption(isDark: true).copyWith(
                        color: isSelected ? Colors.white : AuraColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Grid of Wardrobe Items
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AuraColors.glassBorderDark),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.checkroom_rounded,
                              color: item.color.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white70,
                              size: 32,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AuraTypography.title(isDark: true).copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.category,
                              style: AuraTypography.caption(isDark: true),
                            ),
                            Text(
                              item.tag,
                              style: AuraTypography.caption(isDark: true).copyWith(
                                color: AuraColors.auraCyan,
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
    );
  }
}
