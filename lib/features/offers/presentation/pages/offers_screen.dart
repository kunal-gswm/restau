import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/providers/menu_providers.dart';
import '../../../../core/providers/cart_providers.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Deals'),
      ),
      body: offers.isEmpty
          ? Center(
              child: Text(
                'No offers available right now.\nCheck back later!',
                textAlign: TextAlign.center,
                style: AppTypography.body1(AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: AppSpacing.screenAll,
              itemCount: offers.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadii.borderRadiusXl,
                    boxShadow: AppElevation.low,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(offer.discountPercentage * 100).toInt()}% OFF',
                                  style: AppTypography.h1(AppColors.primary).copyWith(fontSize: 24),
                                ),
                                if (offer.maxDiscount != null)
                                  Text(
                                    'Up to ₹${offer.maxDiscount!.toInt()}',
                                    style: AppTypography.subtitle2(AppColors.primary),
                                  ),
                              ],
                            ),
                            Icon(Icons.local_offer, color: AppColors.primary, size: 40),
                          ],
                        ),
                      ),
                      
                      // Details
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(offer.title, style: AppTypography.h3(AppColors.textPrimary)),
                            const SizedBox(height: AppSpacing.sm),
                            Text(offer.description, style: AppTypography.body2(AppColors.textSecondary)),
                            const SizedBox(height: AppSpacing.md),
                            
                            if (offer.minOrderValue != null) ...[
                              Text('Min. Order: ₹${offer.minOrderValue!.toInt()}', style: AppTypography.caption(AppColors.textTertiary)),
                              const SizedBox(height: AppSpacing.lg),
                            ],
                            
                            // Coupon Code Box
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: AppRadii.borderRadiusMd,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    offer.code,
                                    style: AppTypography.subtitle2(AppColors.textPrimary).copyWith(letterSpacing: 2),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: offer.code));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${offer.code} copied to clipboard!')),
                                      );
                                      // Optionally auto apply if cart isn't empty
                                      final cartItems = ref.read(cartProvider).items;
                                      if (cartItems.isNotEmpty) {
                                         ref.read(cartProvider.notifier).applyCoupon(offer.code);
                                      }
                                    },
                                    child: Text(
                                      'COPY',
                                      style: AppTypography.buttonSmall(AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
