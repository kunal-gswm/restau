import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/menu_providers.dart';
import '../../../../core/providers/cart_providers.dart';
import '../../../../core/models/product_model.dart';
import '../../../../shared/widgets/search_input.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import 'product_details_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final filters = ref.watch(searchFiltersProvider);
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
        backgroundColor: AppColors.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.lg),
            child: SearchInput(
              hintText: 'Search for biryani, kebabs...',
              isInteractive: true,
              autoFocus: true,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).setQuery(val);
              },
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  ref.read(recentSearchesProvider.notifier).addSearch(val);
                }
              },
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('Veg Only', style: AppTypography.subtitle2(filters.isVegOnly ? AppColors.textInverse : AppColors.textSecondary)),
                      selected: filters.isVegOnly,
                      selectedColor: AppColors.vegetarian,
                      checkmarkColor: AppColors.textInverse,
                      onSelected: (val) {
                        ref.read(searchFiltersProvider.notifier).toggleVegOnly(val);
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilterChip(
                      label: Text(filters.maxPrice < 1500 ? 'Under ₹${filters.maxPrice.toInt()}' : 'Price', 
                        style: AppTypography.subtitle2(filters.maxPrice < 1500 ? AppColors.textInverse : AppColors.textSecondary)),
                      selected: filters.maxPrice < 1500,
                      selectedColor: AppColors.primary,
                      checkmarkColor: AppColors.textInverse,
                      onSelected: (val) {
                        if (val) {
                          _showPriceBottomSheet(context, ref, filters.maxPrice);
                        } else {
                          ref.read(searchFiltersProvider.notifier).setMaxPrice(1500.0); // Reset
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          if (query.isEmpty) ...[
            if (recent.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenAll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Searches', style: AppTypography.subtitle1(AppColors.textPrimary)),
                          TextButton(
                            onPressed: () => ref.read(recentSearchesProvider.notifier).clearSearches(),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: AppSpacing.sm,
                        children: recent.map((term) => ActionChip(
                          label: Text(term),
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).setQuery(term);
                          },
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ] else if (results.isEmpty) ...[
             SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: AppSpacing.md),
                      Text('No results found', style: AppTypography.h2(AppColors.textPrimary)),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Try adjusting your search or filters', style: AppTypography.body2(AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
             SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text('${results.length} results', style: AppTypography.subtitle2(AppColors.textSecondary)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProductCard(context, ref, results[index]),
                childCount: results.length,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPriceBottomSheet(BuildContext context, WidgetRef ref, double currentMax) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double tempPrice = currentMax;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Set Maximum Price', style: AppTypography.h2(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.lg),
                  Text('₹${tempPrice.toInt()}', style: AppTypography.display(AppColors.primary)),
                  Slider(
                    value: tempPrice,
                    min: 100,
                    max: 1500,
                    divisions: 14,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => tempPrice = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(searchFiltersProvider.notifier).setMaxPrice(tempPrice);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.borderRadiusMd),
                    ),
                    child: Text('Apply Filter', style: AppTypography.buttonLarge(AppColors.textOnPrimary)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          AppDialogRoute(page: ProductDetailsScreen(product: product)),
        );
      },
      child: Padding(
        padding: AppSpacing.screenH.copyWith(top: AppSpacing.md, bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: product.isVeg ? AppColors.vegetarian : AppColors.nonVegetarian,
                      ),
                      if (product.isBestseller) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentAmberLight,
                            borderRadius: AppRadii.borderRadiusXs,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 10, color: AppColors.accentAmber),
                              const SizedBox(width: 2),
                              Text('BESTSELLER', style: AppTypography.badge(AppColors.accentAmber)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(product.title, style: AppTypography.h3(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('₹${product.price.toStringAsFixed(0)}', style: AppTypography.priceRegular(AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.description,
                    style: AppTypography.body2(AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: AppRadii.borderRadiusMd,
                  child: Image.network(
                    product.imageUrl,
                    width: AppSizes.productImageMd,
                    height: AppSizes.productImageMd,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: AppSizes.productImageMd,
                      height: AppSizes.productImageMd,
                      color: AppColors.surfaceMuted,
                      child: const Icon(Icons.fastfood, color: AppColors.textTertiary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -16,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: AppElevation.low,
                      borderRadius: AppRadii.borderRadiusPill,
                    ),
                    child: AddToCartButton(
                      onTap: () {
                         ref.read(cartProvider.notifier).addItem(product: product, quantity: 1);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
