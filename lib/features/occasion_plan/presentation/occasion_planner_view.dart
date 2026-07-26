import 'package:flutter/material.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';

class OccasionItem {
  final String title;
  final IconData icon;
  final String description;
  final Color accent;

  const OccasionItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.accent,
  });
}

class OccasionPlannerView extends StatefulWidget {
  const OccasionPlannerView({super.key});

  @override
  State<OccasionPlannerView> createState() => _OccasionPlannerViewState();
}

class _OccasionPlannerViewState extends State<OccasionPlannerView> {
  String _selectedOccasion = "Job Interview";
  bool _isGenerating = false;
  Map<String, dynamic>? _generatedOutfit;

  final List<OccasionItem> _occasions = const [
    OccasionItem(
      title: "Job Interview",
      icon: Icons.work_outline_rounded,
      description: "Modern professional confidence",
      accent: AuraColors.auraViolet,
    ),
    OccasionItem(
      title: "Summer Wedding",
      icon: Icons.favorite_border_rounded,
      description: "Elevated cocktail formal",
      accent: AuraColors.auraRose,
    ),
    OccasionItem(
      title: "Date Night",
      icon: Icons.nightlife_rounded,
      description: "Refined evening charm",
      accent: AuraColors.auraCyan,
    ),
    OccasionItem(
      title: "Vacation Resort",
      icon: Icons.beach_access_rounded,
      description: "Relaxed luxury linen aesthetic",
      accent: AuraColors.auraAmber,
    ),
    OccasionItem(
      title: "Tech Conference",
      icon: Icons.laptop_mac_rounded,
      description: "Smart casual minimalism",
      accent: AuraColors.auraEmerald,
    ),
    OccasionItem(
      title: "Gym & Athletic",
      icon: Icons.fitness_center_rounded,
      description: "High-performance streetwear",
      accent: AuraColors.auraViolet,
    ),
  ];

  void _generateOutfit() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _generatedOutfit = {
          "occasion": _selectedOccasion,
          "matchScore": 99,
          "vibe": "Refined Smart Executive",
          "top": "Unstructured Italian Navy Blazer over Silk Off-White Knit Tee",
          "bottom": "Tailored Charcoal Trousers (Break at shoe collar)",
          "footwear": "Burnished Espresso Leather Oxfords",
          "accessories": [
            "Brushed Silver Mechanical Watch",
            "Slim Leather Document Sleeve",
            "Minimalist Silver Ring"
          ],
          "whyItWorks":
              "Navy and charcoal create an authoritative yet approachable visual hierarchy. The silk knit tee balances formal structure with contemporary creative polish."
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          "Occasion Outfit Planner",
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
                "Select Event Context",
                style: AuraTypography.headingMedium(isDark: true),
              ),
              const SizedBox(height: 6),
              Text(
                "Aura AI tailor-fits outfit combinations based on dress codes, climate, and your personal color palette.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),
              const SizedBox(height: 24),

              // Occasion selector grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _occasions.length,
                itemBuilder: (context, index) {
                  final occ = _occasions[index];
                  final isSelected = occ.title == _selectedOccasion;
                  return GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    isGlowing: isSelected,
                    glowColor: occ.accent,
                    onTap: () => setState(() => _selectedOccasion = occ.title),
                    child: Column(
                      crossAxisAlignment: CrossAlignment.start,
                      children: [
                        Icon(
                          occ.icon,
                          color: isSelected ? occ.accent : AuraColors.textMutedDark,
                          size: 28,
                        ),
                        const Spacer(),
                        Text(
                          occ.title,
                          style: AuraTypography.title(isDark: true).copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          occ.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AuraTypography.caption(isDark: true),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              MorphingButton(
                text: _isGenerating
                    ? "Generating Perfect Look..."
                    : "Generate $_selectedOccasion Outfit",
                icon: Icons.sparkles,
                isLoading: _isGenerating,
                onPressed: _generateOutfit,
              ),

              if (_generatedOutfit != null) ...[
                const SizedBox(height: 32),
                GlassCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(24),
                  isGlowing: true,
                  glowColor: AuraColors.auraEmerald,
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _generatedOutfit!['occasion'].toUpperCase(),
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraEmerald,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AuraColors.auraEmerald.withOpacity(0.15),
                            ),
                            child: Text(
                              "SCORE ${_generatedOutfit!['matchScore']}%",
                              style: AuraTypography.caption(isDark: true).copyWith(
                                color: AuraColors.auraEmerald,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _generatedOutfit!['vibe'],
                        style: AuraTypography.headingMedium(isDark: true),
                      ),
                      const SizedBox(height: 20),

                      _buildOutfitRow("Top Layer", _generatedOutfit!['top']),
                      _buildOutfitRow("Bottom Layer", _generatedOutfit!['bottom']),
                      _buildOutfitRow("Footwear", _generatedOutfit!['footwear']),

                      const SizedBox(height: 16),
                      Text(
                        "Accessories",
                        style: AuraTypography.caption(isDark: true).copyWith(
                          color: AuraColors.auraCyan,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_generatedOutfit!['accessories'] as List)
                            .map(
                              (acc) => Chip(
                                label: Text(acc),
                                backgroundColor: Colors.white.withOpacity(0.06),
                                labelStyle: AuraTypography.caption(isDark: true).copyWith(
                                  color: Colors.white,
                                ),
                                side: const BorderSide(color: AuraColors.glassBorderDark),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: AuraColors.glassBorderDark),
                      const SizedBox(height: 12),
                      Text(
                        "WHY THIS WORKS",
                        style: AuraTypography.caption(isDark: true).copyWith(
                          color: AuraColors.textMutedDark,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _generatedOutfit!['whyItWorks'],
                        style: AuraTypography.bodyLarge(isDark: true),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Text(title, style: AuraTypography.caption(isDark: true)),
          const SizedBox(height: 2),
          Text(
            detail,
            style: AuraTypography.bodyLarge(isDark: true).copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
