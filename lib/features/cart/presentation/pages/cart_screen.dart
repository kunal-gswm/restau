import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/upsell_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../checkout/presentation/pages/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Mock cart items (in a real app, this would come from a state manager)
  final List<Map<String, dynamic>> _items = [
    {
      'id': '1',
      'title': 'Royal Butter Chicken Thali',
      'options': 'Regular, Extra Raita',
      'price': 539.0,
      'quantity': 1,
      'isVeg': false,
    },
    {
      'id': '2',
      'title': 'Paneer Tikka',
      'options': 'Spicy',
      'price': 249.0,
      'quantity': 1,
      'isVeg': true,
    }
  ];

  double get _itemTotal => _items.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get _taxes => _itemTotal * 0.05; // 5% GST
  double get _deliveryFee => _itemTotal > 500 ? 0 : 40.0;
  double get _grandTotal => _itemTotal + _taxes + _deliveryFee;

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    if (_items.isEmpty) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Scaffold(); // Handled by Navigator.pop
    }

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
                  final item = _items[index];
                  return Dismissible(
                    key: Key(item['id']),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppSpacing.xl),
                      color: AppColors.error,
                      child: const Icon(Icons.delete, color: AppColors.textOnPrimary),
                    ),
                    onDismissed: (_) => _removeItem(index),
                    child: Padding(
                      padding: AppSpacing.screenH.copyWith(bottom: AppSpacing.lg),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: item['isVeg'] ? AppColors.vegetarian : AppColors.nonVegetarian,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'], style: AppTypography.h3(AppColors.textPrimary)),
                                if ((item['options'] as String).isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(item['options'], style: AppTypography.body2(AppColors.textSecondary)),
                                ],
                                const SizedBox(height: AppSpacing.sm),
                                Text('₹${item['price'].toStringAsFixed(0)}', style: AppTypography.priceRegular(AppColors.textPrimary)),
                              ],
                            ),
                          ),
                          QuantityStepper.standard(
                            quantity: item['quantity'],
                            onIncrement: () => setState(() => item['quantity']++),
                            onDecrement: () {
                              if (item['quantity'] > 1) {
                                setState(() => item['quantity']--);
                              } else {
                                _removeItem(index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _items.length,
              ),
            ),
          ),
          
          SliverToBoxAdapter(child: Divider(color: AppColors.dividerThick)),

          // ─── Upsell Section ──────────────────────────────────
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
                    child: ListView(
                      padding: AppSpacing.screenH,
                      scrollDirection: Axis.horizontal,
                      children: [
                        UpsellCard.horizontal(
                          title: 'Mango Lassi',
                          price: 99.0,
                          imageUrl: 'https://images.unsplash.com/photo-1572448862527-d3c904757de6?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                          onAdd: () {},
                        ),
                        UpsellCard.horizontal(
                          title: 'Gulab Jamun (2 pcs)',
                          price: 79.0,
                          imageUrl: 'https://images.unsplash.com/photo-1596706788540-362c4a9a08e6?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
                          onAdd: () {},
                        ),
                      ],
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
                  onTap: () {},
                  borderRadius: AppRadii.borderRadiusLg,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: AppRadii.borderRadiusLg,
                      color: AppColors.surface,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, color: AppColors.primary, size: AppSizes.iconMd),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Apply Coupon',
                            style: AppTypography.subtitle2(AppColors.textPrimary),
                          ),
                        ),
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
                    _buildBillRow('Item Total', _itemTotal),
                    const SizedBox(height: AppSpacing.sm),
                    _buildBillRow('Taxes & Charges', _taxes),
                    const SizedBox(height: AppSpacing.sm),
                    _buildBillRow(
                      'Delivery Fee',
                      _deliveryFee,
                      isFree: _deliveryFee == 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('To Pay', style: AppTypography.h2(AppColors.textPrimary)),
                        Text('₹${_grandTotal.toStringAsFixed(0)}', style: AppTypography.priceLarge(AppColors.textPrimary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Savings Banner ────────────────────────────────
          if (_deliveryFee == 0)
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
                      Text(
                        'You saved ₹40 on delivery!',
                        style: AppTypography.subtitle2(AppColors.success),
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
                  Text('₹${_grandTotal.toStringAsFixed(0)}', style: AppTypography.priceLarge(AppColors.textPrimary)),
                  Text('View detailed bill', style: AppTypography.caption(AppColors.primary).copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: PrimaryButton(
                  text: 'Proceed to Pay',
                  onPressed: () {
                    Navigator.push(
                      context,
                      AppPageRoute(page: CheckoutScreen(cartTotal: _grandTotal)),
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
                  Text('₹40', style: AppTypography.body2(AppColors.textTertiary).copyWith(decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 4),
                  Text('FREE', style: AppTypography.subtitle2(AppColors.success)),
                ],
              )
            : Text('₹${amount.toStringAsFixed(0)}', style: AppTypography.body2(AppColors.textPrimary)),
      ],
    );
  }
}
