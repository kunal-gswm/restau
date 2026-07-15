import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../shared/widgets/cart_bar.dart';
import '../../../../shared/widgets/search_input.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import 'product_details_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  
  // Dummy cart state for demo
  int _cartItems = 0;
  double _cartTotal = 0.0;
  bool _isFavorite = false;

  final List<String> _categories = [
    'Combos',
    'Curries',
    'Biryani',
    'Tandoor',
    'Breads',
    'Desserts',
  ];

  void _addToCart(double price) {
    setState(() {
      _cartItems++;
      _cartTotal += price;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(),
              _buildStickyCategoryBar(),
              _buildMenuSection('Combos'),
              _buildMenuSection('Curries'),
              _buildMenuSection('Biryani'),
              _buildMenuSection('Tandoor'),
              _buildMenuSection('Breads'),
              _buildMenuSection('Desserts'),
              
              // Bottom padding for cart FAB
              SliverToBoxAdapter(
                child: SizedBox(height: _cartItems > 0 ? 120 : 40),
              ),
            ],
          ),

          // Floating Cart Bar
          if (_cartItems > 0)
            Positioned(
              bottom: AppSpacing.lg,
              left: 0,
              right: 0,
              child: CartBar(
                itemCount: _cartItems,
                total: _cartTotal,
                onTap: () {
                  // Navigate to cart
                },
              ),
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
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? AppColors.primary : AppColors.textInverse,
          ),
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.textInverse),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Restaurant Cover Image
            Image.network(
              'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColors.surfaceMuted),
            ),
            
            // Gradient Overlay
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

            // Restaurant Info
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
                  const SearchInput(
                    hintText: 'Search in Khana...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyCategoryBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyCategoryDelegate(
        child: Container(
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenH,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedCategoryIndex;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: AppRadii.borderRadiusPill,
                    onTap: () {
                      setState(() => _selectedCategoryIndex = index);
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
                          _categories[index],
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

  Widget _buildMenuSection(String category) {
    return SliverToBoxAdapter(
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
          _buildProductCard(
            title: '$category Special 1',
            description: 'A delicious preparation with authentic spices, served hot.',
            price: 299,
            isBestseller: true,
            isVeg: true,
            imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
          ),
          _buildProductCard(
            title: '$category Special 2',
            description: 'Classic recipe passed down through generations.',
            price: 349,
            isBestseller: false,
            isVeg: false,
            imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
          ),
          _buildProductCard(
            title: '$category Special 3',
            description: 'Chef\'s special with a modern twist.',
            price: 249,
            isBestseller: false,
            isVeg: true,
            imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80',
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String description,
    required double price,
    required bool isBestseller,
    required bool isVeg,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          AppDialogRoute(page: const ProductDetailsScreen()),
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
                        color: isVeg ? AppColors.vegetarian : AppColors.nonVegetarian,
                      ),
                      if (isBestseller) ...[
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
                    title,
                    style: AppTypography.h3(AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: AppTypography.priceRegular(AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    description,
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
                    imageUrl,
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
                      onTap: () => _addToCart(price),
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
