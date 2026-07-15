import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Reusable section header with title and optional trailing action.
///
/// Used consistently across Home, Cart, Profile, and Menu screens
/// for "Order Again", "Complete Your Meal", "Rewards", etc.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.h2(AppColors.textPrimary),
            ),
          ),
          if (trailing != null) trailing!,
          if (actionText != null && trailing == null)
            Material(
              color: AppColors.primaryLight,
              borderRadius: AppRadii.borderRadiusPill,
              child: InkWell(
                borderRadius: AppRadii.borderRadiusPill,
                onTap: onAction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  child: Text(
                    actionText!,
                    style: AppTypography.caption(AppColors.primary).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
