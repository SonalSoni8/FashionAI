import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/aura_colors.dart';
import '../../../core/theme/aura_typography.dart';
import '../../../core/widgets/aura_button.dart';
import '../../../core/widgets/aura_card.dart';
import '../../../core/widgets/aura_text_field.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _emailController = TextEditingController(text: "alex.morgan@aura.ai");
  final _passwordController = TextEditingController(text: "••••••••••••");
  bool _isSignUp = false;
  bool _isLoading = false;

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);

    if (mounted) {
      if (_isSignUp) {
        context.push(AppRoutes.createProfile);
      } else {
        context.push(AppRoutes.digitalTwinOnboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AuraColors.auraGradientPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: AuraColors.auraViolet.withOpacity(0.5),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  "Aura AI",
                  style: AuraTypography.displayHero(isDark: true),
                ),
                const SizedBox(height: 4),
                Text(
                  "World's First AI Fashion Operating System",
                  style: AuraTypography.bodyLarge(isDark: true),
                ),
                const SizedBox(height: 32),

                // Auth Card
                AuraCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.all(24),
                  isGlowing: true,
                  glowColor: AuraColors.auraViolet,
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        _isSignUp ? "Create Your Account" : "Welcome Back",
                        style: AuraTypography.headingMedium(isDark: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSignUp
                            ? "Sign up to create your digital fashion twin"
                            : "Log in to access your Aura DNA™ & Digital Closet",
                        style: AuraTypography.caption(isDark: true),
                      ),
                      const SizedBox(height: 20),

                      AuraTextField(
                        controller: _emailController,
                        label: "Email Address",
                        hint: "name@domain.com",
                        prefixIcon: Icons.email_rounded,
                      ),
                      const SizedBox(height: 14),

                      AuraTextField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "••••••••••••",
                        obscureText: true,
                        prefixIcon: Icons.lock_rounded,
                      ),
                      const SizedBox(height: 24),

                      AuraButton(
                        text: _isSignUp ? "Continue to Profile Setup" : "Log In",
                        icon: Icons.arrow_forward_rounded,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() => _isSignUp = !_isSignUp);
                          },
                          child: Text(
                            _isSignUp
                                ? "Already have an account? Log In"
                                : "Don't have an account? Sign Up",
                            style: AuraTypography.caption(isDark: true).copyWith(
                              color: AuraColors.auraViolet,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
