import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Search input bar widget.
///
/// Tappable display-only version for screens that navigate to a search page,
/// or full input for inline search (set [isInteractive] to true).
class SearchInput extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isInteractive;
  final bool autoFocus;

  const SearchInput({
    super.key,
    this.hintText = 'Search menu...',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.isInteractive = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isInteractive) {
      return Container(
        height: AppSizes.touchTarget,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: AppRadii.borderRadiusPill,
        ),
        child: TextField(
          autofocus: autoFocus,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body2(AppColors.textTertiary),
            prefixIcon: Icon(Icons.search, color: AppColors.textTertiary, size: AppSizes.iconMd),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      );
    }

    return Container(
      height: AppSizes.touchTarget,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.borderRadiusPill,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadii.borderRadiusPill,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.textTertiary,
                  size: AppSizes.iconMd,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    hintText,
                    style: AppTypography.body2(AppColors.textTertiary),
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
