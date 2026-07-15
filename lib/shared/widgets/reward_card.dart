import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Reward card widget for profile loyalty section.
class RewardCard extends StatelessWidget {
  final String title;
  final String cost;
  final bool isUnlocked;
  final IconData icon;

  const RewardCard({
    super.key,
    required this.title,
    required this.cost,
    this.isUnlocked = false,
    this.icon = Icons.fastfood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.rewardCardWidth,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.surfaceMuted,
        borderRadius: AppRadii.borderRadiusXl,
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
        ),
        boxShadow: isUnlocked ? AppElevation.low : AppElevation.none,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUnlocked)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.primary, size: AppSizes.iconMd),
                  )
                else
                  const Icon(Icons.lock_outline, color: AppColors.textTertiary, size: AppSizes.iconMd),
                const Spacer(),
                Text(
                  title,
                  style: AppTypography.subtitle2(isUnlocked ? AppColors.textPrimary : AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  cost,
                  style: AppTypography.caption(isUnlocked ? AppColors.primary : AppColors.textTertiary).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
