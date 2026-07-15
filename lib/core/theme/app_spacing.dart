import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Khana Design System — Spacing Tokens
///
/// All spacing values in the application must come from this scale.
/// No screen should use raw double literals for padding/margin.
class AppSpacing {
  AppSpacing._();

  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  /// Consistent horizontal screen padding
  static const double screenPadding = 20.0;

  /// Vertical gap between major sections
  static const double sectionGap = 40.0;

  /// Internal card padding
  static const double cardPadding = 16.0;

  /// Gap between items in a list
  static const double itemGap = 12.0;

  /// Max content width for centered layouts
  static const double maxContentWidth = 600.0;

  // ─── Common EdgeInsets ─────────────────────────────────────
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets cardAll = EdgeInsets.all(cardPadding);
}

/// Khana Design System — Corner Radius Tokens
class AppRadii {
  AppRadii._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double pill = 999.0;

  // Pre-built BorderRadius
  static final BorderRadius borderRadiusXs = BorderRadius.circular(xs);
  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(xl);
  static final BorderRadius borderRadiusXxl = BorderRadius.circular(xxl);
  static final BorderRadius borderRadiusPill = BorderRadius.circular(pill);
}

/// Khana Design System — Elevation / Shadow Tokens
class AppElevation {
  AppElevation._();

  /// No shadow — flat element
  static const List<BoxShadow> none = [];

  /// Subtle lift — for cards at rest
  static List<BoxShadow> get low => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Standard elevation — for interactive cards, search bars
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// High elevation — for floating elements, FABs, modals
  static List<BoxShadow> get high => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  /// Brand glow — for primary brand elements (cart bar, CTAs)
  static List<BoxShadow> get brandGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Top shadow — for sticky headers
  static List<BoxShadow> get stickyHeader => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Bottom sheet shadow
  static List<BoxShadow> get bottomSheet => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];
}

/// Khana Design System — Size Constants
class AppSizes {
  AppSizes._();

  // ─── Icons ──────────────────────────────────────────────────
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ─── Touch Targets ──────────────────────────────────────────
  /// Minimum interactive element size (WCAG)
  static const double touchTarget = 48.0;

  // ─── Buttons ────────────────────────────────────────────────
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 56.0;

  // ─── Avatars ────────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 80.0;

  // ─── Images ─────────────────────────────────────────────────
  static const double productImageSm = 64.0;
  static const double productImageMd = 100.0;
  static const double productImageLg = 160.0;

  // ─── Navigation ─────────────────────────────────────────────
  static const double bottomNavHeight = 64.0;
  static const double appBarHeight = 56.0;

  // ─── Cards ──────────────────────────────────────────────────
  static const double orderAgainCardWidth = 170.0;
  static const double upsellCardWidth = 130.0;
  static const double rewardCardWidth = 130.0;
}
