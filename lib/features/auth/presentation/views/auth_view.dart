import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/aura_colors.dart';
import '../../../../core/theme/aura_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/morphing_button.dart';
import '../../../../core/layout/responsive_breakpoints.dart';
import '../../../../core/router/app_router.dart';
import '../../application/providers/auth_provider.dart';
import '../widgets/desktop_auth_hero.dart';

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

    final success =
        await ref.read(authControllerProvider.notifier).login(email, pass);
    if (success && mounted) {
      context.go(AppRoutes.createProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AuraBreakpoints.isDesktop(context);
    final authState = ref.watch(authControllerProvider);

    Widget authFormContent = Center(
      child: Container(
        maxWidth: 480,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAlignment.start,
          children: [
            if (!isDesktop) ...[
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
              const SizedBox(height: 24),
            ],

            Text(
              _isSignUp ? "Create Account" : "Welcome Back",
              style: AuraTypography.headingLarge(isDark: true).copyWith(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isSignUp
                  ? "Initialize your multi-LLM AI personal stylist workspace."
                  : "Sign in to access your personal color palette and outfit ratings.",
              style: AuraTypography.bodyLarge(isDark: true),
            ),
            const SizedBox(height: 28),

            if (authState.failure != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.redAccent.withOpacity(0.15),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Text(
                  authState.failure!.message,
                  style: AuraTypography.bodyMedium(isDark: true).copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
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

                  MorphingButton(
                    text: _isSignUp ? "Create Workspace" : "Sign In",
                    isLoading: authState.isLoading,
                    onPressed: _submitAuth,
                  ),
                  const SizedBox(height: 20),

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

            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp ? "Already registered? Sign In" : "New to Aura AI? Create Account",
                  style: AuraTypography.bodyMedium(isDark: true).copyWith(
                    color: AuraColors.auraViolet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AuraColors.backgroundDark,
      body: isDesktop
          ? Row(
              children: [
                const Expanded(child: DesktopAuthHero()),
                Expanded(child: authFormContent),
              ],
            )
          : SingleChildScrollView(child: authFormContent),
    );
  }
}
