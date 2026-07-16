import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/quantity_stepper.dart';

/// "Order Again" carousel card showing previously ordered items.
///
/// Features food photography, personalized context, price, and quick-add.
class OrderAgainCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String contextText;
  final VoidCallback? onReorder;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int quantity;

  const OrderAgainCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.contextText = '',
    this.onReorder,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
    this.quantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.orderAgainCardWidth,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.low,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.borderRadiusXl,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food image
                ClipRRect(
                  borderRadius: AppRadii.borderRadiusMd,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: AppColors.surfaceMuted,
                    child: Image.network(
                      imageUrl.isNotEmpty
                          ? imageUrl
                          : 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(Icons.fastfood, color: AppColors.textTertiary, size: AppSizes.iconXl),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  title,
                  style: AppTypography.subtitle2(AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Context text
                if (contextText.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    contextText,
                    style: AppTypography.caption(AppColors.textTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const Spacer(),

                // Price and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: AppTypography.priceRegular(AppColors.textPrimary),
                    ),
                    QuantityStepper.compact(
                      quantity: quantity,
                      onIncrement: () {
                        if (onIncrement != null) {
                          onIncrement!();
                        } else if (onReorder != null) {
                          onReorder!();
                        }
                      },
                      onDecrement: () {
                        if (onDecrement != null) {
                          onDecrement!();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}