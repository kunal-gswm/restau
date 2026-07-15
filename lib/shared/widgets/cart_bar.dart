import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Floating cart bar widget used at the bottom of Home and Menu screens.
///
/// Shows item count badge, "View Cart" label, and total price.
class CartBar extends StatelessWidget {
  final int itemCount;
  final double total;
  final VoidCallback onTap;

  const CartBar({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Material(
        color: AppColors.primary,
        borderRadius: AppRadii.borderRadiusPill,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.borderRadiusPill,
          child: Container(
            height: AppSizes.buttonHeightLg,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: AppRadii.borderRadiusPill,
              boxShadow: AppElevation.brandGlow,
            ),
            child: Row(
              children: [
                // Item count badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '$itemCount',
                        key: ValueKey(itemCount),
                        style: AppTypography.priceRegular(AppColors.primary),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Label
                Text(
                  'View Cart',
                  style: AppTypography.buttonRegular(AppColors.textOnPrimary),
                ),

                const Spacer(),

                // Total price
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '₹${total.toStringAsFixed(0)}',
                    key: ValueKey(total),
                    style: AppTypography.priceLarge(AppColors.textOnPrimary),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
