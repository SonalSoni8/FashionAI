import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/splash_view.dart';
import '../../features/onboarding/presentation/onboarding_view.dart';
import '../../features/onboarding/presentation/auth_view.dart';
import '../../features/profile_scan/presentation/create_profile_view.dart';
import '../../features/profile_scan/presentation/face_scan_view.dart';
import '../../features/profile_scan/presentation/body_scan_view.dart';
import '../../features/profile_scan/presentation/skin_tone_view.dart';
import '../../features/dashboard/presentation/dashboard_view.dart';
import '../../features/outfit_rating/presentation/outfit_rating_view.dart';
import '../../features/ai_stylist/presentation/ai_stylist_view.dart';
import '../../features/wardrobe/presentation/wardrobe_view.dart';
import '../../features/occasion_plan/presentation/occasion_planner_view.dart';
import '../../features/packing_assist/presentation/packing_assistant_view.dart';
import '../../features/shopping_advisor/presentation/shopping_advisor_view.dart';
import '../../features/virtual_tryon/presentation/virtual_tryon_view.dart';
import '../../features/digital_twin/presentation/digital_twin_onboarding_view.dart';
import '../../features/colour_passport/presentation/colour_passport_view.dart';
import '../../features/wardrobe_analytics/presentation/wardrobe_analytics_view.dart';
import '../../features/social_fashion/presentation/social_fashion_view.dart';
import '../../features/aura_dna/presentation/aura_dna_view.dart';
import '../../features/dashboard/presentation/dashboard_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String digitalTwinOnboarding = '/digital-twin-onboarding';
  static const String colourPassport = '/colour-passport';
  static const String wardrobeAnalytics = '/wardrobe-analytics';
  static const String socialFashion = '/social-fashion';
  static const String auraDna = '/aura-dna';
  static const String createProfile = '/create-profile';

  static const String faceScan = '/face-scan';
  static const String bodyScan = '/body-scan';
  static const String skinTone = '/skin-tone';
  static const String dashboard = '/dashboard';
  static const String outfitRating = '/outfit-rating';
  static const String aiStylist = '/ai-stylist';
  static const String wardrobe = '/wardrobe';
  static const String occasionPlanner = '/occasion-planner';
  static const String packingAssistant = '/packing-assistant';
  static const String shoppingAdvisor = '/shopping-advisor';
  static const String virtualTryOn = '/virtual-tryon';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const OnboardingView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const AuthView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.digitalTwinOnboarding,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const DigitalTwinOnboardingView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.colourPassport,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const ColourPassportView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.wardrobeAnalytics,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const WardrobeAnalyticsView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.socialFashion,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const SocialFashionView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.auraDna,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const AuraDnaView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.createProfile,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const CreateProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.faceScan,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const FaceScanView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.bodyScan,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const BodyScanView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.skinTone,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const SkinToneView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const DashboardView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.outfitRating,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const OutfitRatingView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.aiStylist,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const AiStylistView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.wardrobe,
      pageBuilder: (context, state) => _buildFadeTransition(
        context,
        state,
        const WardrobeView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.occasionPlanner,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const OccasionPlannerView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.packingAssistant,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const PackingAssistantView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.shoppingAdvisor,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const ShoppingAdvisorView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.virtualTryOn,
      pageBuilder: (context, state) => _buildSlideUpTransition(
        context,
        state,
        const VirtualTryOnView(),
      ),
    ),
  ],
);

CustomTransitionPage _buildFadeTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

CustomTransitionPage _buildSlideUpTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn = Tween<Offset>(
        begin: const Offset(0.0, 0.08),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slideIn, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}
