import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/aura_colors.dart';
import '../theme/aura_typography.dart';
import '../widgets/glass_card.dart';
import '../router/app_router.dart';
import 'responsive_breakpoints.dart';

class ResponsiveLayoutShell extends StatelessWidget {
  final Widget child;

  const ResponsiveLayoutShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > AuraBreakpoints.tabletMax;
        final isTablet = constraints.maxWidth >= AuraBreakpoints.mobileMax &&
            constraints.maxWidth <= AuraBreakpoints.tabletMax;

        if (isDesktop) {
          return _buildDesktopLayout(context);
        } else if (isTablet) {
          return _buildTabletLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: Row(
        children: [
          // Left Obsidian Glass Sidebar
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: AuraColors.surfaceDark,
              border: Border(
                right: BorderSide(color: AuraColors.glassBorderDark, width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: AuraColors.auraGradientPrimary,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AURA AI',
                      style: AuraTypography.title(isDark: true).copyWith(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                _buildSidebarItem(
                  context,
                  label: "Dashboard",
                  icon: Icons.dashboard_rounded,
                  route: AppRoutes.dashboard,
                ),
                _buildSidebarItem(
                  context,
                  label: "Rate Outfit",
                  icon: Icons.camera_alt_rounded,
                  route: AppRoutes.outfitRating,
                ),
                _buildSidebarItem(
                  context,
                  label: "AI Stylist Chat",
                  icon: Icons.sparkles,
                  route: AppRoutes.aiStylist,
                ),
                _buildSidebarItem(
                  context,
                  label: "Digital Closet",
                  icon: Icons.checkroom_rounded,
                  route: AppRoutes.wardrobe,
                ),
                _buildSidebarItem(
                  context,
                  label: "Occasion Planner",
                  icon: Icons.event_seat_rounded,
                  route: AppRoutes.occasionPlanner,
                ),
                _buildSidebarItem(
                  context,
                  label: "Packing Assistant",
                  icon: Icons.luggage_rounded,
                  route: AppRoutes.packingAssistant,
                ),
                _buildSidebarItem(
                  context,
                  label: "Shopping Advisor",
                  icon: Icons.shopping_bag_outlined,
                  route: AppRoutes.shoppingAdvisor,
                ),

                const Spacer(),
                GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.keyboard_command_key_rounded,
                          color: AuraColors.auraViolet, size: 18),
                      const SizedBox(width: 8),
                      Text("Cmd + K Quick AI",
                          style: AuraTypography.caption(isDark: true)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main View Content
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        hoverColor: AuraColors.auraViolet.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AuraColors.textSecondaryDark, size: 20),
              const SizedBox(width: 14),
              Text(
                label,
                style: AuraTypography.bodyMedium(isDark: true).copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AuraColors.surfaceDark,
            selectedIndex: 0,
            onDestinationSelected: (index) {},
            labelType: NavigationRailLabelType.none,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AuraColors.auraGradientPrimary,
                ),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_rounded, color: Colors.white70),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.camera_alt_rounded, color: Colors.white70),
                label: Text('Rate'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sparkles, color: Colors.white70),
                label: Text('Stylist'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.checkroom_rounded, color: Colors.white70),
                label: Text('Wardrobe'),
              ),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return child;
  }
}
