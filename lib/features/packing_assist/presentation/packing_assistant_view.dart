import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';

class PackingItem {
  final String name;
  final String category;
  bool isPacked;

  PackingItem({
    required this.name,
    required this.category,
    this.isPacked = false,
  });
}

class PackingAssistantView extends StatefulWidget {
  const PackingAssistantView({super.key});

  @override
  State<PackingAssistantView> createState() => _PackingAssistantViewState();
}

class _PackingAssistantViewState extends State<PackingAssistantView> {
  final _destinationController = TextEditingController(text: "Tokyo & Kyoto, Japan");
  int _days = 5;
  bool _isGenerating = false;
  List<PackingItem>? _checklist;

  void _generatePackingList() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _checklist = [
          PackingItem(name: "Unstructured Charcoal Blazer", category: "Outerwear"),
          PackingItem(name: "Packable Rain Shell / Windbreaker", category: "Outerwear"),
          PackingItem(name: "3x Supima Cotton Crewneck Tees", category: "Tops"),
          PackingItem(name: "1x Silk Off-White Knit Shirt", category: "Tops"),
          PackingItem(name: "2x Tailored Stretch Trousers", category: "Bottoms"),
          PackingItem(name: "1x Dark Indigo Selvedge Denim", category: "Bottoms"),
          PackingItem(name: "Walking Leather Sneakers", category: "Shoes"),
          PackingItem(name: "Minimalist Dress Oxfords", category: "Shoes"),
          PackingItem(name: "UV400 Matte Black Acetate Sunglasses", category: "Accessories"),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          "Smart Packing Assistant",
          style: AuraTypography.title(isDark: true),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              Text(
                "Vacation & Trip Checklist",
                style: AuraTypography.headingMedium(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Aura AI analyzes local weather forecasts and trip duration to assemble a zero-waste capsule wardrobe checklist.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    TextField(
                      controller: _destinationController,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Destination City',
                        labelStyle: AuraTypography.bodyMedium(isDark: true),
                        prefixIcon: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: AuraColors.auraViolet,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Trip Duration", style: AuraTypography.title(isDark: true)),
                        Text(
                          "$_days Days",
                          style: AuraTypography.title(isDark: true).copyWith(
                            color: AuraColors.auraRose,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _days.toDouble(),
                      min: 1,
                      max: 14,
                      divisions: 13,
                      activeColor: AuraColors.auraRose,
                      inactiveColor: AuraColors.glassBorderDark,
                      onChanged: (val) => setState(() => _days = val.toInt()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              MorphingButton(
                text: _isGenerating ? "Analyzing Climate & Days..." : "Generate Capsule Packing List",
                icon: Icons.luggage_rounded,
                isLoading: _isGenerating,
                onPressed: _generatePackingList,
              ),

              if (_checklist != null) ...[
                const SizedBox(height: 28),
                Text(
                  "Capsule Packing Checklist",
                  style: AuraTypography.title(isDark: true),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _checklist!.length,
                  itemBuilder: (context, index) {
                    final item = _checklist![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        onTap: () {
                          setState(() => item.isPacked = !item.isPacked);
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isPacked,
                              activeColor: AuraColors.auraEmerald,
                              onChanged: (val) {
                                setState(() => item.isPacked = val ?? false);
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.name,
                                style: AuraTypography.bodyLarge(isDark: true).copyWith(
                                  color: item.isPacked
                                      ? AuraColors.textMutedDark
                                      : Colors.white,
                                  decoration: item.isPacked
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            Text(
                              item.category,
                              style: AuraTypography.caption(isDark: true).copyWith(
                                color: AuraColors.auraViolet,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
