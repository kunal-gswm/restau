import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../home/presentation/pages/home_screen.dart';

/// Khana Splash Screen
///
/// A premium, minimal splash screen representing the Khana brand.
/// It features a staggered fade and slide up animation for the logo, brand name, and tagline.
/// Adheres to accessibility (supports reduced motion) and automatically transitions to the HomeScreen.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AppCurves.enter,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(curvedAnimation);

    _startSplashSequence();
  }

  void _startSplashSequence() {
    // Determine if reduced motion is enabled (we check this post-frame to ensure MediaQuery is available if needed,
    // but typically we can check it in build. For animation controller, we'll just start it.)
    _animationController.forward();

    // Transition to Home Screen after 2.2 seconds to allow the logo animation and a brief pause to be fully visible.
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          AppPageRoute(page: const HomeScreen()),
        );
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
    // Ensure the background is AppColors.background (warm off-white) in light mode,
    // or adapt if a dark theme was applied.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1F2937) : AppColors.background;
    final textPrimary = isDarkMode ? AppColors.textInverse : AppColors.textPrimary;
    final textSecondaryColor = isDarkMode ? AppColors.textDisabled : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Semantics(
        label: 'Khana, Food made memorable.',
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Respect accessibility reduce motion setting
              final disableAnimations = MediaQuery.of(context).disableAnimations;

              return FadeTransition(
                opacity: disableAnimations ? const AlwaysStoppedAnimation(1.0) : _fadeAnimation,
                child: SlideTransition(
                  position: disableAnimations ? const AlwaysStoppedAnimation(Offset.zero) : _slideAnimation,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ─── Logo ──────────────────────────────────────
                const AppLogo(size: 110),
                
                const SizedBox(height: AppSpacing.xxl),

                // ─── App Name ──────────────────────────────────
                Text(
                  'KHANA',
                  style: AppTypography.display(textPrimary).copyWith(
                    letterSpacing: 2.0, // Added elegant spacing for premium feel
                    fontWeight: FontWeight.w900,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.sm),

                // ─── Tagline ───────────────────────────────────
                Text(
                  '"Food made memorable."',
                  style: AppTypography.subtitle1(textSecondaryColor).copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxxl * 2),

                // ─── Subtle Loading Indicator ──────────────────
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withValues(alpha: 0.6)),
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
