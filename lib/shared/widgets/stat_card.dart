import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Stat card widget for profile metrics.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primaryLight : AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        border: Border.all(
          color: isHighlighted ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
        ),
        boxShadow: isHighlighted ? AppElevation.none : AppElevation.low,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.caption(isHighlighted ? AppColors.primary : AppColors.textSecondary).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h1(isHighlighted ? AppColors.primary : AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
