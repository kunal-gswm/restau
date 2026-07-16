import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../auth/presentation/pages/login_screen.dart';

/// Khana Splash Screen — Premium Cinematic Reveal
///
/// A highly unique splash screen featuring:
/// 1. Path-tracing animation of the culinary cloche logo.
/// 2. Cinematic letter-spacing tracking expansion for the brand text.
/// 3. Smooth exit transition to the Home screen.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  late Animation<double> _logoTraceAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textTrackingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), // Slowed down for a luxurious reveal
    );

    // 1. Logo Path Tracing: 0.0 to 0.5 (first 1.75s)
    _logoTraceAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOutCubic),
    );

    // 2. Text Fade In: 0.4 to 0.7
    _textFadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );

    // 3. Text Tracking (Letter Spacing): 0.4 to 1.0 (smoothly settles in)
    _textTrackingAnimation = Tween<double>(begin: 12.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _startSplashSequence();
  }

  void _startSplashSequence() {
    _animationController.forward();

    // Transition to Home Screen gracefully after the sequence settles (4.5 seconds total)
    Timer(const Duration(milliseconds: 4500), () {
      if (mounted) {
        final user = ref.read(supabaseClientProvider).auth.currentUser;
        final isGuest = ref.read(authControllerProvider);

        if (user != null || isGuest) {
          Navigator.pushReplacement(
            context,
            AppPageRoute(page: const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            AppPageRoute(page: const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1F2937) : AppColors.background;
    final textPrimary = isDarkMode ? AppColors.textInverse : AppColors.textPrimary;
    final textSecondaryColor = isDarkMode ? AppColors.textDisabled : AppColors.textSecondary;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Semantics(
        label: 'Khana, Food made memorable.',
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final logoProgress = disableAnimations ? 1.0 : _logoTraceAnimation.value;
              final textOpacity = disableAnimations ? 1.0 : _textFadeAnimation.value;
              final textTracking = disableAnimations ? 2.0 : _textTrackingAnimation.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ─── Path-Traced Logo ────────────────────────────
                  AppLogo(size: 110, progress: logoProgress),
                  
                  const SizedBox(height: AppSpacing.xxl),

                  // ─── Cinematic App Name ────────────────────────
                  Opacity(
                    opacity: textOpacity,
                    child: Text(
                      'KHANA',
                      style: AppTypography.display(textPrimary).copyWith(
                        letterSpacing: textTracking,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.sm),

                  // ─── Tagline ───────────────────────────────────
                  Opacity(
                    opacity: textOpacity,
                    child: Text(
                      '"Food made memorable."',
                      style: AppTypography.subtitle1(textSecondaryColor).copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl * 2),

                  // ─── Subtle Loading Indicator ──────────────────
                  Opacity(
                    opacity: textOpacity,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
