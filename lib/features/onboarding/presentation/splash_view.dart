import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/router/app_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2400));
    if (!mounted) return;

    final isOnboarded = HiveService.isOnboardingCompleted;
    final isLoggedIn = HiveService.isLoggedIn;

    if (!isOnboarded) {
      context.go(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      context.go(AppRoutes.auth);
    } else {
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient aura glow
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) => Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AuraColors.auraViolet.withOpacity(_glowAnimation.value * 0.5),
                    AuraColors.auraRose.withOpacity(_glowAnimation.value * 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Central Logo Icon & Typography
          ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: AuraColors.auraGradientPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: AuraColors.auraViolet.withOpacity(0.5),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'AURA AI',
                  style: AuraTypography.displayHero(isDark: true).copyWith(
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PERSONAL AI STYLIST & FASHION INTELLIGENCE',
                  style: AuraTypography.caption(isDark: true).copyWith(
                    letterSpacing: 2.2,
                    color: AuraColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
