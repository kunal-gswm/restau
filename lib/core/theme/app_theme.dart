import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Khana Design System — Theme Configuration
///
/// Centralized ThemeData for the entire application.
/// Enforces visual consistency through component themes.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.accentGold,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.border,
      ),

      // ─── AppBar ────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.h2(AppColors.textPrimary),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSizes.iconLg,
        ),
      ),

      // ─── Text ──────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: AppTypography.display(AppColors.textPrimary),
        displayMedium: AppTypography.h1(AppColors.textPrimary),
        displaySmall: AppTypography.h2(AppColors.textPrimary),
        headlineMedium: AppTypography.h3(AppColors.textPrimary),
        titleLarge: AppTypography.subtitle1(AppColors.textPrimary),
        titleMedium: AppTypography.subtitle2(AppColors.textPrimary),
        bodyLarge: AppTypography.body1(AppColors.textPrimary),
        bodyMedium: AppTypography.body2(AppColors.textSecondary),
        labelLarge: AppTypography.buttonRegular(AppColors.textPrimary),
        labelMedium: AppTypography.caption(AppColors.textSecondary),
        labelSmall: AppTypography.badge(AppColors.textTertiary),
      ),

      // ─── Elevated Button ──────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          minimumSize: const Size(64, AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.borderRadiusLg,
          ),
          textStyle: AppTypography.buttonLarge(AppColors.textOnPrimary),
        ),
      ),

      // ─── Outlined Button ──────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(64, AppSizes.buttonHeightMd),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.borderRadiusLg,
          ),
          textStyle: AppTypography.buttonRegular(AppColors.textPrimary),
        ),
      ),

      // ─── Text Button ──────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.buttonRegular(AppColors.primary),
        ),
      ),

      // ─── Input Decoration ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        hintStyle: AppTypography.body2(AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.borderRadiusMd,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // ─── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.borderRadiusLg,
        ),
        margin: EdgeInsets.zero,
      ),

      // ─── Divider ──────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // ─── Bottom Nav ───────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.bottomNavHeight,
        backgroundColor: AppColors.surface,
        elevation: 0,
        indicatorColor: AppColors.primaryLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.caption(AppColors.primary).copyWith(fontWeight: FontWeight.w700);
          }
          return AppTypography.caption(AppColors.textTertiary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: AppSizes.iconLg);
          }
          return const IconThemeData(color: AppColors.textTertiary, size: AppSizes.iconLg);
        }),
      ),

      // ─── Snackbar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTypography.body2(AppColors.textInverse),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.borderRadiusMd,
        ),
      ),

      // ─── Switch ───────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryLight;
          return AppColors.surfaceMuted;
        }),
      ),

      // ─── Progress Indicator ────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceMuted,
        circularTrackColor: AppColors.surfaceMuted,
      ),

      // ─── Misc ──────────────────────────────────────────────
      dividerColor: AppColors.divider,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      useMaterial3: true,
    );
  }

}
