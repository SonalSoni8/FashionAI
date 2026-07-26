import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/widgets/spring_slide.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/router/app_router.dart';

class OnboardingSlide {
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color accentColor;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.accentColor,
  });
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: "Discover What Truly Suits You",
      subtitle:
          "Unlock personal confidence with an AI personal stylist that decodes your skin undertone, facial structure, and proportions.",
      badgeText: "AI VISION ENGINE",
      icon: Icons.face_retouching_natural_rounded,
      accentColor: AuraColors.auraViolet,
    ),
    OnboardingSlide(
      title: "Instant Outfit Ratings & Deep Reasonings",
      subtitle:
          "Upload any outfit. Receive instant breakdown scores on fit, occasion appropriateness, color balance, and elevation tips.",
      badgeText: "STYLING SCORE 98%",
      icon: Icons.checkroom_rounded,
      accentColor: AuraColors.auraRose,
    ),
    OnboardingSlide(
      title: "Your Digital Wardrobe & Smart Stylist",
      subtitle:
          "Scan owned clothing to assemble flawless daily outfits, vacation packing lists, and occasion ensembles seamlessly.",
      badgeText: "INTELLIGENT CLOSET",
      icon: Icons.auto_awesome_rounded,
      accentColor: AuraColors.auraCyan,
    ),
  ];

  void _onNext() async {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      await HiveService.setOnboardingCompleted(true);
      if (mounted) {
        context.go(AppRoutes.auth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Skip Button Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AuraColors.auraViolet,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AURA AI',
                        style: AuraTypography.title(isDark: true).copyWith(
                          fontSize: 14,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await HiveService.setOnboardingCompleted(true);
                      if (context.mounted) context.go(AppRoutes.auth);
                    },
                    child: Text(
                      'Skip',
                      style: AuraTypography.bodyMedium(isDark: true).copyWith(
                        color: AuraColors.textMutedDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glassmorphic Preview Card
                        SpringSlide(
                          key: ValueKey(index),
                          child: GlassCard(
                            borderRadius: 32,
                            padding: const EdgeInsets.all(32),
                            isGlowing: true,
                            glowColor: slide.accentColor,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: slide.accentColor.withOpacity(0.15),
                                    border: Border.all(
                                      color: slide.accentColor.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Text(
                                    slide.badgeText,
                                    style: AuraTypography.caption(isDark: true).copyWith(
                                      color: slide.accentColor,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 36),
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: slide.accentColor.withOpacity(0.12),
                                  ),
                                  child: Icon(
                                    slide.icon,
                                    size: 46,
                                    color: slide.accentColor,
                                  ),
                                ),
                                const SizedBox(height: 36),
                                Text(
                                  slide.title,
                                  textAlign: TextAlign.center,
                                  style: AuraTypography.headingLarge(isDark: true),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  slide.subtitle,
                                  textAlign: TextAlign.center,
                                  style: AuraTypography.bodyLarge(isDark: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Indicator Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AuraColors.auraViolet,
                      dotColor: Colors.white.withOpacity(0.2),
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  MorphingButton(
                    text: _currentPage == _slides.length - 1
                        ? "Discover Your Aura"
                        : "Continue",
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
