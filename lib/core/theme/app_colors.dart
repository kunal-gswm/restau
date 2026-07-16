import 'package:flutter/material.dart';

/// Khana Design System — Color Tokens
///
/// Every color in the application must come from this file.
/// No screen should use raw Color() constructors or Colors.grey[N].
class AppColors {
  AppColors._();

  // ─── Brand Colors ────────────────────────────────────────────
  /// Primary brand — warm, appetizing saffron-red
  static const Color primary = Color(0xFFE23D28);

  /// Darker variant for pressed/active states
  static const Color primaryDark = Color(0xFFC62828);

  /// Light tint for secondary buttons, badges, subtle backgrounds
  static const Color primaryLight = Color(0xFFFFF0EE);

  /// Ultra-light tint for hover/surface accents
  static const Color primarySurface = Color(0xFFFFF8F6);

  // ─── Accent Colors ───────────────────────────────────────────
  /// Gold accent for loyalty, premium elements, star ratings
  static const Color accentGold = Color(0xFFE8A838);
  static const Color accentGoldLight = Color(0xFFFFF8E8);

  /// Amber for badges like "Bestseller", "New"
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentAmberLight = Color(0xFFFEF3C7);

  // ─── Background & Surface ────────────────────────────────────
  /// Main screen background — warm off-white
  static const Color background = Color(0xFFFAF9F7);

  /// Card / elevated surface
  static const Color surface = Color(0xFFFFFFFF);

  /// Muted surface for inputs, secondary cards
  static const Color surfaceMuted = Color(0xFFF5F4F2);



  // ─── Text Colors ─────────────────────────────────────────────
  /// Primary text — near-black with warmth
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary text — descriptions, subtitles
  static const Color textSecondary = Color(0xFF6B7280);

  /// Tertiary text — hints, placeholders, captions
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Disabled text
  static const Color textDisabled = Color(0xFFD1D5DB);

  /// Inverse text — for use on dark/brand backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Text on primary brand background
  static const Color textOnPrimary = Color(0xFFFFFFFF);



  // ─── Borders & Dividers ──────────────────────────────────────
  /// Subtle border for cards
  static const Color border = Color(0xFFE5E7EB);

  /// Stronger border for inputs, focused states
  static const Color borderStrong = Color(0xFFD1D5DB);

  /// Divider between sections (thinner/lighter)
  static const Color divider = Color(0xFFF3F4F6);

  /// Thick divider / section separator
  static const Color dividerThick = Color(0xFFF0EFED);



  // ─── Feedback / Status Colors ────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFEAB308);
  static const Color warningLight = Color(0xFFFEF9C3);

  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Overlays ────────────────────────────────────────────────
  /// Scrim for bottom sheets, modals
  static const Color overlay = Color(0x66000000);

  /// Light overlay for image text readability
  static const Color overlayLight = Color(0x33000000);

  /// Dark overlay for hero images
  static const Color overlayDark = Color(0x99000000);

  // ─── Misc ────────────────────────────────────────────────────
  /// Star/rating color
  static const Color starRating = Color(0xFFE8A838);

  /// Vegetarian indicator
  static const Color vegetarian = Color(0xFF16A34A);

  /// Non-vegetarian indicator
  static const Color nonVegetarian = Color(0xFFDC2626);

  /// Spicy indicator
  static const Color spicy = Color(0xFFEF4444);

  /// Shimmer base and highlight for loading states
  static const Color shimmerBase = Color(0xFFF3F4F6);
  static const Color shimmerHighlight = Color(0xFFE5E7EB);
}
