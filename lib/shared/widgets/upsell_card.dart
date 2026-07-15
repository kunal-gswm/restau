import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'quantity_stepper.dart';

/// Upsell card widget with vertical and horizontal variants.
///
/// Shows related items, usually in cart or product details.
class UpsellCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final VoidCallback onAdd;
  final bool isHorizontal;

  const UpsellCard.vertical({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onAdd,
  }) : isHorizontal = false;

  const UpsellCard.horizontal({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onAdd,
  }) : isHorizontal = true;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontal();
    }
    return _buildVertical();
  }

  Widget _buildVertical() {
    return Container(
      width: AppSizes.upsellCardWidth,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.low,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
            child: Image.network(
              imageUrl,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 90,
                color: AppColors.surfaceMuted,
                child: const Icon(Icons.fastfood, color: AppColors.textTertiary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle2(AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${price.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
                    AddToCartButton(onTap: onAdd),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontal() {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.low,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadii.borderRadiusMd,
            child: Image.network(
              imageUrl,
              height: 64,
              width: 64,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 64,
                width: 64,
                color: AppColors.surfaceMuted,
                child: const Icon(Icons.fastfood, color: AppColors.textTertiary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle2(AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${price.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
                    AddToCartButton(onTap: onAdd),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
