import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/morphing_button.dart';
import '../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _emailController = TextEditingController(text: "alex.fashion@aura.ai");
  final _passwordController = TextEditingController(text: "password123");
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitAuth() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) return;

    final success = await ref.read(authProvider.notifier).login(email, pass);
    if (success && mounted) {
      context.go(AppRoutes.createProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Brand logo header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: AuraColors.auraGradientPrimary,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
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
              const SizedBox(height: 32),

              Text(
                _isSignUp ? "Create Your AI Profile" : "Welcome Back",
                style: AuraTypography.displayHero(isDark: true),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp
                    ? "Enter your details to generate your tailored AI personal stylist workspace."
                    : "Sign in to access your personal color palette, body analysis, and daily outfit scores.",
                style: AuraTypography.bodyLarge(isDark: true),
              ),

              const SizedBox(height: 32),

              // Glassmorphic Auth Form Container
              GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Email Field
                    TextField(
                      controller: _emailController,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: AuraTypography.bodyMedium(isDark: true),
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: AuraColors.textMutedDark,
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

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: AuraTypography.bodyLarge(isDark: true).copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: AuraTypography.bodyMedium(isDark: true),
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          color: AuraColors.textMutedDark,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Action Button
                    MorphingButton(
                      text: _isSignUp ? "Create Account" : "Sign In",
                      isLoading: authState.isLoading,
                      onPressed: _submitAuth,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AuraColors.glassBorderDark,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "OR CONTINUE WITH",
                            style: AuraTypography.caption(isDark: true),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AuraColors.glassBorderDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social OAuth Buttons
                    Row(
                      children: [
                        Expanded(
                          child: MorphingButton(
                            text: "Apple",
                            icon: Icons.apple,
                            style: MorphingButtonStyle.glassOutline,
                            onPressed: _submitAuth,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MorphingButton(
                            text: "Google",
                            icon: Icons.g_mobiledata_rounded,
                            style: MorphingButtonStyle.glassOutline,
                            onPressed: _submitAuth,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Switch Mode Toggle
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: RichText(
                    text: TextSpan(
                      text: _isSignUp
                          ? "Already have an account? "
                          : "Don't have an account? ",
                      style: AuraTypography.bodyMedium(isDark: true),
                      children: [
                        TextSpan(
                          text: _isSignUp ? "Sign In" : "Create One",
                          style: AuraTypography.bodyMedium(isDark: true).copyWith(
                            color: AuraColors.auraViolet,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
