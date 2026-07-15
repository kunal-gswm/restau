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

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  bool _isManualScrolling = false; // Flag to prevent scrollspy from overriding manual tab clicks

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isManualScrolling) return;

    // Simple scroll spy logic
    String? visibleCategory;
    for (var entry in _categoryKeys.entries) {
      final key = entry.value;
      if (key.currentContext != null) {
        final renderObject = key.currentContext!.findRenderObject() as RenderBox;
        final position = renderObject.localToGlobal(Offset.zero).dy;
        // If the section is near the top of the screen (adjusting for app bar + sticky header)
        if (position > 0 && position < 350) {
          visibleCategory = entry.key;
          break;
        }
      }
    }

    if (visibleCategory != null) {
      final currentCategory = ref.read(selectedCategoryProvider);
      if (currentCategory != visibleCategory && currentCategory != 'All') {
        // We defer state update to avoid setState during build or scroll notification
        Future.microtask(() {
          ref.read(selectedCategoryProvider.notifier).setCategory(visibleCategory!);
        });
      }
    }
  }

  void _scrollToCategory(String category) {
    if (category == 'All') return;
    final key = _categoryKeys[category];
    if (key != null && key.currentContext != null) {
      _isManualScrolling = true;
      ref.read(selectedCategoryProvider.notifier).setCategory(category);
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      ).then((_) => _isManualScrolling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedProducts = ref.watch(menuByCategoryProvider);
    final categories = ref.watch(categoriesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);
    
    // Ensure keys exist for all categories
    for (var category in categories) {
      _categoryKeys.putIfAbsent(category, () => GlobalKey());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          
          if (searchQuery.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding),
                child: Text('Search Results for "$searchQuery"', style: AppTypography.h2(AppColors.textPrimary)),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: searchResults.map((product) => _buildProductCard(product)).toList(),
              ),
            ),
          ] else ...[
            _buildStickyCategoryBar(categories),
            for (var category in groupedProducts.keys)
              _buildMenuSection(category, groupedProducts[category]!),
          ],

          // Bottom padding for cart FAB (managed by HomeScreen)
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: AppColors.textInverse),
          onPressed: () {
            // Simulated restaurant favorite action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Khana added to favorites!')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.textInverse),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening share dialog...')),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColors.surfaceMuted),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: AppSpacing.lg,
              left: AppSpacing.screenPadding,
              right: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryLight,
                          child: Text('K', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khana',
                              style: AppTypography.display(AppColors.textInverse).copyWith(fontSize: 28),
                            ),
                            Text(
                              'Modern Indian Cuisine',
                              style: AppTypography.subtitle2(AppColors.textInverse.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadii.borderRadiusPill,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.starRating, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '4.8',
                              style: AppTypography.subtitle2(AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SearchInput(
                    hintText: 'Search in Khana...',
                    isInteractive: true,
                    onChanged: (val) {
                      ref.read(searchQueryProvider.notifier).setQuery(val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyCategoryBar(List<String> categories) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    
    // Add "All" to the beginning for the horizontal scroll
    final displayCategories = ['All', ...categories];

    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyCategoryDelegate(
        child: Container(
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenH,
            itemCount: displayCategories.length,
            itemBuilder: (context, index) {
              final cat = displayCategories[index];
              final isSelected = cat == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadii.borderRadiusPill,
                    onTap: () {
                      if (cat == 'All') {
                        ref.read(selectedCategoryProvider.notifier).setCategory('All');
                        _scrollController.animateTo(0, duration: AppDurations.normal, curve: Curves.easeInOut);
                      } else {
                        _scrollToCategory(cat);
                      }
                    },
                    child: AnimatedContainer(
                      duration: AppDurations.normal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.textPrimary : AppColors.surface,
                        borderRadius: AppRadii.borderRadiusPill,
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: AppTypography.subtitle2(
                            isSelected ? AppColors.textInverse : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String category, List<Product> products) {
    return SliverToBoxAdapter(
      key: _categoryKeys[category],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.screenPadding, AppSpacing.xl, AppSpacing.screenPadding, AppSpacing.md),
            child: Row(
              children: [
                Text(
                  category,
                  style: AppTypography.h1(AppColors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Divider(color: AppColors.dividerThick),
                ),
              ],
            ),
          ),
          ...products.map((p) => _buildProductCard(p)),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
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
                              Text(
                                'BESTSELLER',
                                style: AppTypography.badge(AppColors.accentAmber),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    product.title,
                    style: AppTypography.h3(AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: AppTypography.priceRegular(AppColors.textPrimary),
                  ),
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

class _StickyCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyCategoryDelegate({required this.child});

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: overlapsContent ? AppElevation.stickyHeader : AppElevation.none,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyCategoryDelegate oldDelegate) {
    return true;
  }
}
