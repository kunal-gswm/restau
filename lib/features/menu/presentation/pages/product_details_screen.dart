import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../../../shared/widgets/primary_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  String _selectedSize = 'Regular';
  bool _addExtraCheese = false;
  final TextEditingController _notesController = TextEditingController();

  double get _totalPrice {
    double basePrice = 299.0;
    if (_selectedSize == 'Large') basePrice += 100.0;
    if (_addExtraCheese) basePrice += 50.0;
    return basePrice * _quantity;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar with Image ──────────────────────────────
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: AppColors.surfaceMuted),
              ),
            ),
          ),

          // ─── Content ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 12, color: AppColors.nonVegetarian),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmberLight,
                          borderRadius: AppRadii.borderRadiusXs,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: AppColors.accentAmber),
                            const SizedBox(width: 4),
                            Text('BESTSELLER', style: AppTypography.badge(AppColors.accentAmber)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '4.8',
                        style: AppTypography.subtitle2(AppColors.textPrimary),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, size: 16, color: AppColors.starRating),
                      Text(
                        ' (120+)',
                        style: AppTypography.body2(AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Chicken Dum Biryani',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Fragrant basmati rice cooked with marinated chicken, saffron, and aromatic spices in a sealed pot. Served with raita and salan.',
                    style: AppTypography.body1(AppColors.textSecondary).copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ─── Modifiers ──────────────────────────────────
                  Text('Portion Size', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Choose 1', style: AppTypography.body2(AppColors.textTertiary)),
                  const SizedBox(height: AppSpacing.md),
                  _buildRadioOption('Regular', 'Serves 1', 0.0),
                  _buildRadioOption('Large', 'Serves 2-3', 100.0),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: AppColors.dividerThick),
                  const SizedBox(height: AppSpacing.lg),

                  Text('Add-ons', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Optional', style: AppTypography.body2(AppColors.textTertiary)),
                  const SizedBox(height: AppSpacing.md),
                  _buildCheckboxOption('Extra Chicken', 80.0, _addExtraCheese, (v) => setState(() => _addExtraCheese = v ?? false)),
                  _buildCheckboxOption('Boiled Egg', 30.0, false, (v) {}),
                  _buildCheckboxOption('Extra Raita', 40.0, false, (v) {}),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: AppColors.dividerThick),
                  const SizedBox(height: AppSpacing.lg),

                  // ─── Instructions ────────────────────────────────
                  Text('Special Instructions', style: AppTypography.subtitle1(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'e.g. Please make it extra spicy...',
                      filled: true,
                      fillColor: AppColors.surfaceMuted,
                      border: OutlineInputBorder(
                        borderRadius: AppRadii.borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                    ),
                  ),
                  
                  const SizedBox(height: 140), // Padding for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // ─── Bottom CTA Bar ──────────────────────────────────────
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppElevation.bottomSheet,
        ),
        child: SafeArea(
          child: Row(
            children: [
              QuantityStepper.large(
                quantity: _quantity,
                onIncrement: () => setState(() => _quantity++),
                onDecrement: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: PrimaryButton(
                  text: 'Add ₹${_totalPrice.toStringAsFixed(0)}',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
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

  Widget _buildRadioOption(String title, String subtitle, double extraPrice) {
    final isSelected = _selectedSize == title;
    return InkWell(
      onTap: () => setState(() => _selectedSize = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h3(AppColors.textPrimary)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: AppTypography.body2(AppColors.textSecondary)),
                ],
              ),
            ),
            if (extraPrice > 0)
              Text('+₹${extraPrice.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(String title, double extraPrice, bool value, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              color: value ? AppColors.primary : AppColors.textTertiary,
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(title, style: AppTypography.h3(AppColors.textPrimary)),
            ),
            Text('+₹${extraPrice.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
