import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Category filter pill for horizontal scrolling category bar.
class CategoryPill extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.title,
    this.emoji = '🍔',
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: AppRadii.borderRadiusLg,
        boxShadow: isSelected
            ? AppElevation.brandGlow
            : AppElevation.low,
        border: isSelected
            ? null
            : Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadii.borderRadiusLg,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.subtitle2(
                    isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
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