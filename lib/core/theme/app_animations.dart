import 'package:flutter/material.dart';

/// Khana Design System — Motion / Animation Tokens
///
/// All animation durations and curves must come from this file.
class AppDurations {
  AppDurations._();

  /// Micro-interactions: checkboxes, toggles, color changes
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard transitions: expand, slide, fade
  static const Duration normal = Duration(milliseconds: 250);

  /// Complex transitions: page, modal, multi-step
  static const Duration slow = Duration(milliseconds: 400);

  /// Page transition duration
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// Staggered list item delay
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Loading shimmer cycle
  static const Duration shimmer = Duration(milliseconds: 1500);
}

/// Standard animation curves
class AppCurves {
  AppCurves._();

  /// Default for most animations
  static const Curve standard = Curves.easeInOut;

  /// For elements entering the screen
  static const Curve enter = Curves.easeOut;

  /// For elements leaving the screen
  static const Curve exit = Curves.easeIn;

  /// For bouncy, playful animations
  static const Curve spring = Curves.elasticOut;

  /// For smooth deceleration (progress bars, reveals)
  static const Curve decelerate = Curves.easeOutCubic;
}

/// Premium page route with fade + slide-up transition
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AppPageRoute({required this.page})
      : super(
          transitionDuration: AppDurations.pageTransition,
          reverseTransitionDuration: AppDurations.normal,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: AppCurves.enter,
            );
            return FadeTransition(
              opacity: curve,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.03),
                  end: Offset.zero,
                ).animate(curve),
                child: child,
              ),
            );
          },
        );
}

/// Full-screen dialog route (for product details, etc.)
class AppDialogRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AppDialogRoute({required this.page})
      : super(
          fullscreenDialog: true,
          transitionDuration: AppDurations.slow,
          reverseTransitionDuration: AppDurations.normal,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: AppCurves.decelerate,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            );
          },
        );
}
