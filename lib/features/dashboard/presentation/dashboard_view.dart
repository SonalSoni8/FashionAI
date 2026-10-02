import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../aura_dna/providers/aura_dna_provider.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dna = ref.watch(auraDnaProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              // Hero User Header Card
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(22),
                isGlowing: true,
                glowColor: AuraColors.auraViolet,
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AuraColors.auraGradientPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: AuraColors.auraViolet.withOpacity(0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "AM",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dna.userName,
                                style: AuraTypography.headingMedium(isDark: true),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AuraColors.auraEmerald.withOpacity(0.2),
                                ),
                                child: Text(
                                  "${dna.confidenceScore}% CONFIDENCE",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AuraColors.auraEmerald,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Mannequin ID: ${dna.twinId} · ${dna.bodyShape.split(' ')[0]}",
                            style: AuraTypography.caption(isDark: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Aura Fashion OS Workspace",
                style: AuraTypography.title(isDark: true),
              ),
              const SizedBox(height: 14),

              // Feature Launcher Cards Grid (All 10 Core Features)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildLauncherCard(
                    title: "Aura DNA™ Master",
                    subtitle: "Unified 16-point genome",
                    icon: Icons.fingerprint_rounded,
                    color: AuraColors.auraViolet,
                    route: AppRoutes.auraDna,
                  ),
                  _buildLauncherCard(
                    title: "Digital Twin",
                    subtitle: "3-Angle 3D Pose Mesh",
                    icon: Icons.camera_alt_rounded,
                    color: AuraColors.auraCyan,
                    route: AppRoutes.digitalTwinOnboarding,
                  ),
                  _buildLauncherCard(
                    title: "Colour Passport",
                    subtitle: "Deep Autumn Palette",
                    icon: Icons.palette_rounded,
                    color: AuraColors.auraRose,
                    route: AppRoutes.colourPassport,
                  ),
                  _buildLauncherCard(
                    title: "Digital Closet",
                    subtitle: "42 Owned Garments",
                    icon: Icons.checkroom_rounded,
                    color: AuraColors.auraEmerald,
                    route: AppRoutes.wardrobe,
                  ),
                  _buildLauncherCard(
                    title: "Virtual Try-On",
                    subtitle: "Landmark Fitting Studio",
                    icon: Icons.accessibility_new_rounded,
                    color: AuraColors.auraViolet,
                    route: AppRoutes.virtualTryOn,
                  ),
                  _buildLauncherCard(
                    title: "AI Stylist Chat",
                    subtitle: "Gemini Fashion AI",
                    icon: Icons.sparkles,
                    color: AuraColors.auraRose,
                    route: AppRoutes.aiStylist,
                  ),
                  _buildLauncherCard(
                    title: "Shopping Advisor",
                    subtitle: "BUY vs SKIP Verdict",
                    icon: Icons.shopping_bag_rounded,
                    color: AuraColors.auraAmber,
                    route: AppRoutes.shoppingAdvisor,
                  ),
                  _buildLauncherCard(
                    title: "Outfit Calendar",
                    subtitle: "8 Occasion Slots",
                    icon: Icons.calendar_month_rounded,
                    color: AuraColors.auraCyan,
                    route: AppRoutes.occasionPlanner,
                  ),
                  _buildLauncherCard(
                    title: "Closet Analytics",
                    subtitle: "96 / 100 Closet Score",
                    icon: Icons.bar_chart_rounded,
                    color: AuraColors.auraEmerald,
                    route: AppRoutes.wardrobeAnalytics,
                  ),
                  _buildLauncherCard(
                    title: "Social Network",
                    subtitle: "Creator & Celebrity Hub",
                    icon: Icons.explore_rounded,
                    color: AuraColors.auraViolet,
                    route: AppRoutes.socialFashion,
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Glassmorphic Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          border: const Border(
            top: BorderSide(color: AuraColors.glassBorderDark),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedBottomNavIndex,
          onTap: (index) {
            setState(() => _selectedBottomNavIndex = index);
            if (index == 0) context.push(AppRoutes.virtualTryOn);
            if (index == 1) context.push(AppRoutes.wardrobe);
            if (index == 2) context.push(AppRoutes.aiStylist);
            if (index == 3) context.push(AppRoutes.socialFashion);
            if (index == 4) context.push(AppRoutes.auraDna);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AuraColors.auraViolet,
          unselectedItemColor: Colors.white54,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new_rounded),
              label: "Try-On",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checkroom_rounded),
              label: "Closet",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sparkles),
              label: "AI Stylist",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: "Social",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fingerprint_rounded),
              label: "Aura DNA",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLauncherCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.18),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AuraTypography.title(isDark: true).copyWith(
                    fontSize: 13,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AuraTypography.caption(isDark: true).copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
