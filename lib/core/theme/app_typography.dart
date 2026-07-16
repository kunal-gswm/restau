import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Khana Design System — Typography Tokens
///
/// All text styles must come from this file.
/// No screen should use inline TextStyle() with raw font sizes.
class AppTypography {
  AppTypography._();

  static String? get fontFamily => GoogleFonts.inter().fontFamily;

  // ─── Display ─────────────────────────────────────────────────
  /// Display: 32px / Bold — Hero greeting, feature headers
  static TextStyle display(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
        letterSpacing: -0.8,
      );

  // ─── Headings ────────────────────────────────────────────────
  /// H1: 24px / Bold — Screen titles
  static TextStyle h1(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
        letterSpacing: -0.5,
      );

  /// H2: 20px / Semi-Bold — Section headers (Order Again, Today's Special)
  static TextStyle h2(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
        letterSpacing: -0.4,
      );

  /// H3: 16px / Semi-Bold — Card titles, item names
  static TextStyle h3(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
        letterSpacing: -0.2,
      );

  // ─── Subtitles ───────────────────────────────────────────────
  /// Subtitle1: 18px / Semi-Bold — Section subtitles (Bill Details, Payment)
  static TextStyle subtitle1(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
        letterSpacing: -0.3,
      );

  /// Subtitle2: 14px / Semi-Bold — Sub-labels, emphasis text
  static TextStyle subtitle2(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  // ─── Body ────────────────────────────────────────────────────
  /// Body1: 16px / Regular — Main body, descriptions
  static TextStyle body1(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  /// Body2: 14px / Regular — Secondary text, modifiers
  static TextStyle body2(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  // ─── Prices ──────────────────────────────────────────────────
  /// Price Display: 36px / Black — Hero price tags
  static TextStyle priceDisplay(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w900,
        height: 1.1,
        color: color,
        letterSpacing: -1.0,
      );

  /// Price Large: 20px / Black — Cart totals, checkout
  static TextStyle priceLarge(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w900,
        height: 1.2,
        color: color,
        letterSpacing: -0.5,
      );

  /// Price Regular: 16px / Bold — Inline item prices
  static TextStyle priceRegular(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  /// Price Small: 14px / Bold — Upsell prices, modifier prices
  static TextStyle priceSmall(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  // ─── Buttons ─────────────────────────────────────────────────
  /// Button Large: 18px / Bold — Primary CTAs
  static TextStyle buttonLarge(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );

  /// Button Regular: 16px / Semi-Bold — Secondary buttons
  static TextStyle buttonRegular(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  /// Button Small: 14px / Semi-Bold — Compact buttons
  static TextStyle buttonSmall(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
      );

  // ─── Labels & Captions ───────────────────────────────────────
  /// Caption: 12px / Medium — Timestamps, metadata
  static TextStyle caption(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      );

  /// Overline: 12px / Bold / Uppercase — Category labels, tags
  static TextStyle overline(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: color,
        letterSpacing: 1.0,
      );

  /// Badge: 10px / Bold / Uppercase — Small badges
  static TextStyle badge(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
        letterSpacing: 0.8,
      );

  /// Tiny: 11px / Medium — Fine print, legal text
  static TextStyle tiny(Color color) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );
}
