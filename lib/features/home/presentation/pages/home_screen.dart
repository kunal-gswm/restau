import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/cart_providers.dart';
import '../../../../core/providers/menu_providers.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../../shared/widgets/cart_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/loyalty_summary_card.dart';
import '../widgets/order_again_card.dart';
import '../widgets/category_pill.dart';
import '../../../menu/presentation/pages/menu_screen.dart';
import '../../../cart/presentation/pages/cart_screen.dart';
import '../../../offers/presentation/pages/offers_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeBody(context),
          const MenuScreen(),
          const OffersScreen(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cartState.items.isNotEmpty
          ? CartBar(
              itemCount: cartState.totalItemCount,
              total: cartState.grandTotal,
              onTap: () {
                Navigator.push(
                  context,
                  AppPageRoute(page: const CartScreen()),
                );
              },
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          height: AppSizes.bottomNavHeight,
          elevation: 0,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryLight,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu, color: AppColors.primary),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_offer_outlined),
              selectedIcon: Icon(Icons.local_offer, color: AppColors.primary),
              label: 'Offers',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
          selectedIndex: _currentNavIndex,
          onDestinationSelected: (index) {
            setState(() => _currentNavIndex = index);
          },
        ),
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    final user = ref.watch(userProvider);
    final categories = ref.watch(categoriesProvider);
    final favorites = ref.watch(favoriteProductsProvider);
    final cartState = ref.watch(cartProvider);

    return CustomScrollView(
      slivers: [
        // ─── Premium App Bar ───────────────────────────────────
        SliverAppBar(
          pinned: true,
          floating: true,
          elevation: 0,
          backgroundColor: AppColors.background.withValues(alpha: 0.97),
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 64,
          titleSpacing: AppSpacing.xl,
          leadingWidth: 120,
          leading: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xl),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: AppSizes.iconSm, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    user.addresses.firstWhere((a) => a.isDefault, orElse: () => user.addresses.first).title,
                    style: AppTypography.subtitle2(AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: AppSizes.iconSm, color: AppColors.textTertiary),
              ],
            ),
          ),
          title: Center(
            child: Text(
              'KHANA',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.0,
                color: AppColors.primary,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, size: AppSizes.iconLg),
              tooltip: 'Search',
              onPressed: () {
                setState(() => _currentNavIndex = 1);
                // Trigger search open in MenuScreen
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Greeting ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good evening,',
                      style: AppTypography.body1(AppColors.textTertiary),
                    ),
                    Text(
                      user.name.split(' ').first,
                      style: AppTypography.display(AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              // ─── Hero Banner ───────────────────────────────────
              _buildHeroBanner(context),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Loyalty ───────────────────────────────────────
              LoyaltySummaryCard(
                points: user.loyaltyPoints, 
                onTap: () {
                  setState(() => _currentNavIndex = 3); // Go to profile
                },
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Categories ────────────────────────────────────
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: AppSpacing.screenH,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryPill(
                        title: 'All', 
                        emoji: '✨', 
                        isSelected: ref.watch(selectedCategoryProvider) == 'All',
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).setCategory(categories.first);
                          setState(() => _currentNavIndex = 1);
                        },
                      );
                    }
                    final category = categories[index - 1];
                    // Map emoji
                    String emoji = '🍛';
                    if (category == 'Biryani') emoji = '🍚';
                    if (category == 'Tandoor') emoji = '🔥';
                    if (category == 'Beverages') emoji = '🥤';
                    if (category == 'Desserts') emoji = '🍰';
                    
                    return CategoryPill(
                      title: category,
                      emoji: emoji,
                      isSelected: ref.watch(selectedCategoryProvider) == category,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(category);
                        setState(() => _currentNavIndex = 1);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Order Again ───────────────────────────────────
              if (favorites.isNotEmpty) ...[
                SectionHeader(
                  title: 'Your Favourites',
                  actionText: 'See all',
                  onAction: () {
                     setState(() => _currentNavIndex = 1);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 225,
                  child: ListView.separated(
                    padding: AppSpacing.screenH,
                    scrollDirection: Axis.horizontal,
                    itemCount: favorites.length,
                    separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return OrderAgainCard(
                        title: product.title,
                        contextText: product.category,
                        price: '₹${product.price.toInt()}',
                        imageUrl: product.imageUrl,
                        onReorder: () {
                           ref.read(cartProvider.notifier).addItem(product: product, quantity: 1);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
              ],

              // ─── Today's Special ───────────────────────────────
              SectionHeader(title: 'Chef\'s Recommendation'),
              const SizedBox(height: AppSpacing.lg),
              _buildTodaysSpecial(context),

              // Bottom padding for FAB
              SizedBox(height: cartState.items.isNotEmpty ? 120 : 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    // Dynamic Hero from recommended products
    final recommendations = ref.watch(recommendedProductsProvider);
    if (recommendations.isEmpty) return const SizedBox.shrink();
    
    final heroProduct = recommendations.last; // using the last bestseller for hero

    return Container(
      margin: AppSpacing.screenH,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: AppRadii.borderRadiusXxl,
        boxShadow: AppElevation.high,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.borderRadiusXxl,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              heroProduct.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColors.surfaceMuted),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadii.borderRadiusPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.restaurant, size: 12, color: AppColors.textOnPrimary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'FROM OUR KITCHEN',
                          style: AppTypography.badge(AppColors.textOnPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    heroProduct.title.replaceAll(' ', '\n'), // Simple wrap logic
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h1(AppColors.textInverse).copyWith(
                      fontSize: 28,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Material(
                    color: AppColors.surface,
                    borderRadius: AppRadii.borderRadiusPill,
                    child: InkWell(
                      onTap: () {
                        ref.read(cartProvider.notifier).addItem(product: heroProduct, quantity: 1);
                      },
                      borderRadius: AppRadii.borderRadiusPill,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Order Now  •  ₹${heroProduct.price.toInt()}',
                              style: AppTypography.subtitle2(AppColors.textPrimary),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward, size: AppSizes.iconSm, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSpecial(BuildContext context) {
    final recommendations = ref.watch(recommendedProductsProvider);
    if (recommendations.isEmpty) return const SizedBox.shrink();
    
    final pickProduct = recommendations.first; // First bestseller

    return Padding(
      padding: AppSpacing.screenH,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.borderRadiusXxl,
          boxShadow: AppElevation.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xxl)),
                  child: Image.network(
                    pickProduct.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 220,
                      color: AppColors.surfaceMuted,
                      child: const Center(child: Icon(Icons.restaurant, size: 48, color: AppColors.textTertiary)),
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.lg,
                  right: AppSpacing.lg,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: AppRadii.borderRadiusPill,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starRating, size: 14),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Chef\'s Pick',
                          style: AppTypography.badge(AppColors.textInverse),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickProduct.title,
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    pickProduct.description,
                    style: AppTypography.body1(AppColors.textSecondary).copyWith(height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${pickProduct.price.toInt()}',
                        style: AppTypography.priceDisplay(AppColors.textPrimary),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightLg,
                    child: ElevatedButton(
                      onPressed: () {
                         ref.read(cartProvider.notifier).addItem(product: pickProduct, quantity: 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.borderRadiusLg,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add to Order',
                        style: AppTypography.buttonLarge(AppColors.textOnPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}