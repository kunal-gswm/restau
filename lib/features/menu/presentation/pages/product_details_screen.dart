import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/cart_item_model.dart';
import '../../../../core/providers/cart_providers.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../../../shared/widgets/primary_button.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  final TextEditingController _notesController = TextEditingController();
  
  // Map of ModifierGroup ID to a set of selected ModifierOption IDs
  final Map<String, Set<String>> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    // Pre-select required options (first option by default)
    for (var group in widget.product.modifierGroups) {
      if (group.isRequired && group.options.isNotEmpty) {
        _selectedOptions[group.id] = {group.options.first.id};
      } else {
        _selectedOptions[group.id] = {};
      }
    }
  }

  double get _totalPrice {
    double basePrice = widget.product.price;
    
    // Add all modifier prices
    for (var group in widget.product.modifierGroups) {
      final selectedForGroup = _selectedOptions[group.id] ?? {};
      for (var option in group.options) {
        if (selectedForGroup.contains(option.id)) {
          basePrice += option.extraPrice;
        }
      }
    }
    
    return basePrice * _quantity;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleRadioChange(String groupId, String optionId) {
    setState(() {
      _selectedOptions[groupId] = {optionId};
    });
  }

  void _handleCheckboxChange(String groupId, String optionId, bool isSelected) {
    setState(() {
      final selectedSet = _selectedOptions[groupId] ?? {};
      if (isSelected) {
        selectedSet.add(optionId);
      } else {
        selectedSet.remove(optionId);
      }
      _selectedOptions[groupId] = selectedSet;
    });
  }

  void _addToCart() {
    List<SelectedModifier> selectedMods = [];
    
    for (var group in widget.product.modifierGroups) {
      final selectedIds = _selectedOptions[group.id] ?? {};
      for (var id in selectedIds) {
        final option = group.options.firstWhere((o) => o.id == id);
        selectedMods.add(SelectedModifier(group: group, option: option));
      }
    }

    ref.read(cartProvider.notifier).addItem(
      product: widget.product,
      quantity: _quantity,
      selectedModifiers: selectedMods,
      specialInstructions: _notesController.text,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.title} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing not fully implemented in demo')),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                p.imageUrl,
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
                      Icon(Icons.circle, size: 12, color: p.isVeg ? AppColors.vegetarian : AppColors.nonVegetarian),
                      const SizedBox(width: AppSpacing.sm),
                      if (p.isBestseller) ...[
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
                      ],
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
                    p.title,
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    p.description,
                    style: AppTypography.body1(AppColors.textSecondary).copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ─── Modifiers ──────────────────────────────────
                  for (var group in p.modifierGroups) ...[
                    Text(group.title, style: AppTypography.subtitle1(AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(group.subtitle, style: AppTypography.body2(AppColors.textTertiary)),
                    const SizedBox(height: AppSpacing.md),
                    for (var option in group.options)
                      if (group.allowMultiple)
                        _buildCheckboxOption(group, option)
                      else
                        _buildRadioOption(group, option),
                    
                    const SizedBox(height: AppSpacing.lg),
                    Divider(color: AppColors.dividerThick),
                    const SizedBox(height: AppSpacing.lg),
                  ],

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
                  onPressed: _addToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(ModifierGroup group, ModifierOption option) {
    final isSelected = _selectedOptions[group.id]?.contains(option.id) ?? false;
    return InkWell(
      onTap: () => _handleRadioChange(group.id, option.id),
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
                  Text(option.title, style: AppTypography.h3(AppColors.textPrimary)),
                  if (option.subtitle.isNotEmpty)
                    Text(option.subtitle, style: AppTypography.body2(AppColors.textSecondary)),
                ],
              ),
            ),
            if (option.extraPrice > 0)
              Text('+₹${option.extraPrice.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(ModifierGroup group, ModifierOption option) {
    final isSelected = _selectedOptions[group.id]?.contains(option.id) ?? false;
    return InkWell(
      onTap: () => _handleCheckboxChange(group.id, option.id, !isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(option.title, style: AppTypography.h3(AppColors.textPrimary)),
            ),
            if (option.extraPrice > 0)
              Text('+₹${option.extraPrice.toStringAsFixed(0)}', style: AppTypography.priceSmall(AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
