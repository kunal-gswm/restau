import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/cart_providers.dart';
import '../../../../core/providers/menu_providers.dart';
import '../../../../core/models/cart_item_model.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/animated_price.dart';
import '../../../../shared/widgets/upsell_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../checkout/presentation/pages/checkout_screen.dart';
import '../../../menu/presentation/pages/product_details_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _showCouponDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          title: Text('Apply Coupon', style: AppTypography.h2(AppColors.textPrimary)),
          content: TextField(
            controller: _couponController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Enter Code (e.g. WELCOME50)',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: AppRadii.borderRadiusMd,
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: AppTypography.buttonRegular(AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final success = ref.read(cartProvider.notifier).applyCoupon(_couponController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Coupon Applied!' : 'Invalid or expired coupon'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textOnPrimary),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    // If cart is completely cleared from within the screen, pop it
    // Using a post-frame callback prevents build phase exceptions
    if (cartState.items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ModalRoute.of(context)?.isCurrent == true) {
          Navigator.pop(context);
        }
      });
      return const Scaffold(backgroundColor: AppColors.background);
    }

    // Grab some desserts/beverages for the upsell section
    final allProducts = ref.watch(productsProvider);
    final upsellItems = allProducts.where((p) => p.category == 'Desserts' || p.category == 'Beverages').toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: CustomScrollView(
        slivers: [
          // ─── Items List ─────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final CartItem item = cartState.items[index];
                  
                  // Format options string
                  final List<String> options = item.selectedModifiers.map((m) => m.option.title).toList();
                  final optionsStr = options.join(', ');

                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.xl),
                      color: AppColors.error,
                      child: const Icon(Icons.delete, color: AppColors.textOnPrimary),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Remove Item', style: AppTypography.h3(AppColors.textPrimary)),
                          content: Text('Are you sure you want to remove ${item.product.title} from your cart?', style: AppTypography.body2(AppColors.textSecondary)),
                          actionsAlignment: MainAxisAlignment.end,
                          actionsPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel', style: AppTypography.buttonRegular(AppColors.textSecondary)),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.textOnPrimary),
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      ) ?? false;
                    },
                    onDismissed: (_) {
                      ref.read(cartProvider.notifier).removeItem(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.product.title} removed from cart'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Padding(
                      padding: AppSpacing.screenH.copyWith(bottom: AppSpacing.lg),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: item.product.isVeg ? AppColors.vegetarian : AppColors.nonVegetarian,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.title, style: AppTypography.h3(AppColors.textPrimary)),
                                if (optionsStr.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(optionsStr, style: AppTypography.body2(AppColors.textSecondary)),
                                ],
                                if (item.specialInstructions.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text('Note: ${item.specialInstructions}', style: AppTypography.caption(AppColors.textTertiary)),
                                ],
                                const SizedBox(height: AppSpacing.sm),
                                Text('₹${item.totalPrice.toStringAsFixed(0)}', style: AppTypography.priceRegular(AppColors.textPrimary)),
                              ],
                            ),
                          ),
                          QuantityStepper.standard(
                            quantity: item.quantity,
                            onIncrement: () {
                              ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1);
                            },
                            onDecrement: () {
                              ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: cartState.items.length,
              ),
            ),
          ),
          
          SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),

          // ─── Upsell Section ──────────────────────────────────
          if (upsellItems.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Complete Your Meal'),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        padding: AppSpacing.screenH,
                        scrollDirection: Axis.horizontal,
                        itemCount: upsellItems.length,
                        separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final product = upsellItems[index];
                          return UpsellCard.horizontal(
                            title: product.title,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            onAdd: () {
                              ref.read(cartProvider.notifier).addItem(product: product, quantity: 1);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added')),
                              );
                            },
                            onTap: () {
                              Navigator.push(context, AppDialogRoute(page: ProductDetailsScreen(product: product)));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),

          // ─── Offers & Coupons ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenAll,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showCouponDialog,
                  borderRadius: AppRadii.borderRadiusLg,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      border: Border.all(color: cartState.appliedOffer != null ? AppColors.success : AppColors.borderStrong),
                      borderRadius: AppRadii.borderRadiusLg,
                      color: cartState.appliedOffer != null ? AppColors.successLight : AppColors.surface,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_offer, color: cartState.appliedOffer != null ? AppColors.success : AppColors.primary, size: AppSizes.iconMd),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartState.appliedOffer != null ? '${cartState.appliedOffer!.code} Applied' : 'Apply Coupon',
                                style: AppTypography.subtitle2(cartState.appliedOffer != null ? AppColors.success : AppColors.textPrimary),
                              ),
                              if (cartState.appliedOffer != null)
                                Text('You saved ₹${cartState.discount.toStringAsFixed(0)}', style: AppTypography.caption(AppColors.success)),
                            ],
                          ),
                        ),
                        if (cartState.appliedOffer != null)
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: AppColors.success),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeCoupon();
                            },
                          )
                        else
                          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Bill Details ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.borderRadiusXl,
                  boxShadow: AppElevation.low,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bill Details', style: AppTypography.subtitle1(AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.md),
                    _buildBillRow('Item Total', cartState.itemTotal),
                    if (cartState.discount > 0) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Item Discount', style: AppTypography.body2(AppColors.success)),
                          Text('-₹${cartState.discount.toStringAsFixed(0)}', style: AppTypography.body2(AppColors.success)),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    _buildBillRow('Taxes & Charges', cartState.taxes),
                    const SizedBox(height: AppSpacing.sm),
                    _buildBillRow(
                      'Delivery Fee',
                      cartState.deliveryFee,
                      isFree: cartState.deliveryFee == 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Pay', style: AppTypography.h2(AppColors.textPrimary)),
                        AnimatedPrice(
                          value: cartState.grandTotal,
                          textStyle: AppTypography.priceLarge(AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Savings Banner ────────────────────────────────
          if (cartState.deliveryFee == 0 || cartState.discount > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.screenAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: AppRadii.borderRadiusMd,
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.success, size: AppSizes.iconMd),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'You saved ₹${((cartState.deliveryFee == 0 ? CartState.standardDeliveryFee : 0) + cartState.discount).toStringAsFixed(0)} on this order!',
                          style: AppTypography.subtitle2(AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),

      // ─── Footer CTA ────────────────────────────────────────
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppElevation.bottomSheet,
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${cartState.grandTotal.toStringAsFixed(0)}', style: AppTypography.priceLarge(AppColors.textPrimary)),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.surface,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xxl))),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Detailed Bill Breakdown', style: AppTypography.h2(AppColors.textPrimary)),
                              const SizedBox(height: AppSpacing.lg),
                              _buildBillRow('Items Total', cartState.itemTotal),
                              const SizedBox(height: AppSpacing.sm),
                              if (cartState.discount > 0) ...[
                                _buildBillRow('Discount', -cartState.discount),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                              _buildBillRow('Taxes & Charges', cartState.taxes),
                              const SizedBox(height: AppSpacing.sm),
                              _buildBillRow('Delivery Fee', cartState.deliveryFee, isFree: cartState.deliveryFee == 0),
                              const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.md), child: Divider()),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Grand Total', style: AppTypography.h2(AppColors.textPrimary)),
                                  Text('₹${cartState.grandTotal.toStringAsFixed(0)}', style: AppTypography.priceLarge(AppColors.textPrimary)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xl),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('View detailed bill', style: AppTypography.caption(AppColors.primary).copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: PrimaryButton(
                  text: 'Proceed to Pay',
                  onPressed: () {
                    Navigator.push(
                      context,
                      AppPageRoute(page: CheckoutScreen(cartTotal: cartState.grandTotal)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body2(AppColors.textSecondary)),
        isFree
            ? Row(
                children: [
                  Text('₹${CartState.standardDeliveryFee.toStringAsFixed(0)}', style: AppTypography.body2(AppColors.textTertiary).copyWith(decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 4),
                  Text('FREE', style: AppTypography.subtitle2(AppColors.success)),
                ],
              )
            : Text('₹${amount.toStringAsFixed(0)}', style: AppTypography.body2(AppColors.textPrimary)),
      ],
    );
  }
}
