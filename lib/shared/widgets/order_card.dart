import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'secondary_button.dart';
import 'primary_button.dart';

/// Order history card for profile past orders section.
class OrderCard extends StatelessWidget {
  final String date;
  final String items;
  final double price;
  final String status;
  final VoidCallback onReorder;
  final VoidCallback onRate;

  const OrderCard({
    super.key,
    required this.date,
    required this.items,
    required this.price,
    required this.status,
    required this.onReorder,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Khana', style: AppTypography.subtitle2(AppColors.textPrimary)),
              Text('₹${price.toStringAsFixed(0)}', style: AppTypography.priceRegular(AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: AppTypography.caption(AppColors.textSecondary)),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text(status, style: AppTypography.caption(AppColors.success).copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(items, style: AppTypography.body2(AppColors.textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Reorder',
                  onPressed: onReorder,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SecondaryButton(
                  text: 'Rate Order',
                  onPressed: onRate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
