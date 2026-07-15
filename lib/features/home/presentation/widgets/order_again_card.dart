import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/quantity_stepper.dart';

/// "Order Again" carousel card showing previously ordered items.
///
/// Features food photography, personalized context, price, and quick-add.
class OrderAgainCard extends StatefulWidget {
  final String title;
  final String price;
  final String imageUrl;
  final String contextText;
  final VoidCallback? onReorder;

  const OrderAgainCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.contextText = '',
    this.onReorder,
  });

  @override
  State<OrderAgainCard> createState() => _OrderAgainCardState();
}

class _OrderAgainCardState extends State<OrderAgainCard> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.orderAgainCardWidth,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.borderRadiusXl,
        boxShadow: AppElevation.low,
      ),
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
                  widget.imageUrl.isNotEmpty
                      ? widget.imageUrl
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
              widget.title,
              style: AppTypography.subtitle2(AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Context text
            if (widget.contextText.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                widget.contextText,
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
                  widget.price,
                  style: AppTypography.priceRegular(AppColors.textPrimary),
                ),
                QuantityStepper.compact(
                  quantity: _quantity,
                  onIncrement: () {
                    setState(() => _quantity++);
                    if (_quantity == 1 && widget.onReorder != null) {
                      widget.onReorder!();
                    }
                  },
                  onDecrement: () {
                    setState(() {
                      if (_quantity > 0) _quantity--;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}