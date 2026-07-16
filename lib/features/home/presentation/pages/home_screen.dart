import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/cart_providers.dart';
import '../../../../core/providers/menu_providers.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../../core/models/product_model.dart';
import '../../../../shared/widgets/cart_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/loyalty_summary_card.dart';
import '../widgets/order_again_card.dart';
import '../widgets/category_pill.dart';
import '../widgets/home_skeleton.dart';
import '../../../menu/presentation/pages/menu_screen.dart';
import '../../../cart/presentation/pages/cart_screen.dart';
import '../../../offers/presentation/pages/offers_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../menu/presentation/pages/product_details_screen.dart';
import '../../../menu/presentation/pages/search_screen.dart';
import '../../../profile/presentation/pages/favorites_screen.dart';
import '../../../profile/presentation/pages/saved_addresses_screen.dart';
import '../../../../core/utils/app_translations.dart';
import '../../../../core/providers/settings_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;
  final PageController _bannerController = PageController(viewportFraction: 0.93, initialPage: 4000);
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _startBannerAutoPlay();
    
    // Simulate network delay to show the premium skeleton loader
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_bannerController.hasClients || !_bannerController.position.hasContentDimensions) return;
      final currentPage = _bannerController.page?.round() ?? _bannerController.initialPage;
      _bannerController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

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
      floatingActionButton: cartState.items.isNotEmpty && !_isLoading
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
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppColors.primary),
              label: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Home'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.restaurant_menu_outlined),
              selectedIcon: const Icon(Icons.restaurant_menu, color: AppColors.primary),
              label: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Menu'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_offer_outlined),
              selectedIcon: const Icon(Icons.local_offer, color: AppColors.primary),
              label: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Offers'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person, color: AppColors.primary),
              label: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Profile'),
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
    if (_isLoading) {
      return const HomeSkeleton();
    }

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
          toolbarHeight: 54,
          automaticallyImplyLeading: false,
          titleSpacing: AppSpacing.lg,
          title: InkWell(
            onTap: () => _showAddressSelectorBottomSheet(context, ref),
            borderRadius: AppRadii.borderRadiusPill,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: AppSizes.iconSm, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      user.addresses.firstWhere((a) => a.isDefault, orElse: () => user.addresses.first).title,
                      style: AppTypography.subtitle2(AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.keyboard_arrow_down, size: AppSizes.iconSm, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, size: AppSizes.iconLg),
              tooltip: 'Search',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTranslations.tr(ref.watch(settingsProvider).locale, 'Good evening,'),
                      style: AppTypography.body2(AppColors.textTertiary),
                    ),
                    Text(
                      user.name.split(' ').first,
                      style: AppTypography.h2(AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              // ─── Hero Banner ───────────────────────────────────
              _buildHeroBanner(context),

              const SizedBox(height: AppSpacing.lg),

              // ─── Loyalty ───────────────────────────────────────
              LoyaltySummaryCard(
                points: user.loyaltyPoints, 
                onTap: () {
                  setState(() => _currentNavIndex = 3); // Go to profile
                },
              ),

              const SizedBox(height: AppSpacing.lg),

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
                        title: AppTranslations.tr(ref.watch(settingsProvider).locale, 'All'), 
                        emoji: '✨', 
                        isSelected: ref.watch(selectedCategoryProvider) == 'All',
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).setCategory('All');
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

              const SizedBox(height: AppSpacing.lg),

              // ─── Order Again ───────────────────────────────────
              if (favorites.isNotEmpty) ...[
                SectionHeader(
                  title: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Your Favourites'),
                  actionText: AppTranslations.tr(ref.watch(settingsProvider).locale, 'See all'),
                  onAction: () {
                    Navigator.push(context, AppPageRoute(page: const FavoritesScreen()));
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 225,
                  child: ListView.separated(
                    padding: AppSpacing.screenH,
                    scrollDirection: Axis.horizontal,
                    itemCount: favorites.length,
                    separatorBuilder: (c, i) => const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      final cartQty = cartState.items.where((i) => i.product.id == product.id).fold(0, (sum, i) => sum + i.quantity);
                      return OrderAgainCard(
                        title: product.title,
                        contextText: product.category,
                        price: '₹${product.price.toInt()}',
                        imageUrl: product.imageUrl,
                        quantity: cartQty,
                        onTap: () {
                          Navigator.push(context, AppDialogRoute(page: ProductDetailsScreen(product: product)));
                        },
                        onIncrement: () {
                          ref.read(cartProvider.notifier).addItem(product: product, quantity: 1);
                        },
                        onDecrement: () {
                          ref.read(cartProvider.notifier).removeItem(product.id);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ─── Today's Special ───────────────────────────────
              SectionHeader(title: AppTranslations.tr(ref.watch(settingsProvider).locale, 'Chef\'s Recommendation')),
              const SizedBox(height: AppSpacing.md),
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
    final allRecommendations = ref.watch(recommendedProductsProvider);
    if (allRecommendations.isEmpty) return const SizedBox.shrink();
    
    final bestsellers = allRecommendations.where((p) => p.isBestseller).toList();
    final banners = <Product>[];
    if (bestsellers.isNotEmpty) {
      banners.add(bestsellers[0]); // e.g. Royal Butter Chicken Thali
      if (bestsellers.length > 3) banners.add(bestsellers[3]); // e.g. Chicken Dum Biryani
      if (bestsellers.length > 6) banners.add(bestsellers[6]); // e.g. Paneer Butter Masala
      if (bestsellers.length > 9) banners.add(bestsellers[9]); // e.g. Afghani Tikka or Nawabi Combo
    }
    if (banners.isEmpty) banners.addAll(allRecommendations.take(4));

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: 10000,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index % banners.length;
              });
            },
            itemBuilder: (context, index) {
              final actualIndex = index % banners.length;
              final product = banners[actualIndex];
              final customBadge = actualIndex == 0
                  ? 'CHEF\'S SPECIAL THALI'
                  : actualIndex == 1
                      ? 'TRENDING DUM BIRYANI'
                      : actualIndex == 2
                          ? 'ROYAL CURRY FEAST'
                          : 'SIGNATURE TANDOOR & GRILL';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                decoration: BoxDecoration(
                  borderRadius: AppRadii.borderRadiusXxl,
                  boxShadow: AppElevation.high,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: AppRadii.borderRadiusXxl,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, AppDialogRoute(page: ProductDetailsScreen(product: product)));
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          product.imageUrl,
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
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
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
                                    const Icon(Icons.local_fire_department, size: 14, color: AppColors.textOnPrimary),
                                    const SizedBox(width: AppSpacing.xs),
                                    Text(
                                      customBadge,
                                      style: AppTypography.badge(AppColors.textOnPrimary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.h1(AppColors.textInverse).copyWith(
                                  fontSize: 26,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Material(
                                    color: AppColors.surface,
                                    borderRadius: AppRadii.borderRadiusPill,
                                    child: InkWell(
                                      onTap: () {
                                        ref.read(cartProvider.notifier).addItem(product: product, quantity: 1);
                                      },
                                      borderRadius: AppRadii.borderRadiusPill,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.lg,
                                          vertical: AppSpacing.sm,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${AppTranslations.tr(ref.watch(settingsProvider).locale, 'Order Now')} • ₹${product.price.toInt()}',
                                              style: AppTypography.subtitle2(AppColors.textPrimary),
                                            ),
                                            const SizedBox(width: AppSpacing.xs),
                                            const Icon(Icons.arrow_forward, size: AppSizes.iconSm, color: AppColors.primary),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isSelected = _currentBannerIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.border,
                borderRadius: AppRadii.borderRadiusPill,
              ),
            );
          }),
        ),
      ],
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
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadii.borderRadiusXxl,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(context, AppDialogRoute(page: ProductDetailsScreen(product: pickProduct)));
            },
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
                        AppTranslations.tr(ref.watch(settingsProvider).locale, 'Add to Order'),
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
        ),
      ),
    );
  }

  void _showAddressSelectorBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xxl))),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final liveUser = ref.watch(userProvider);
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppTranslations.tr(ref.watch(settingsProvider).locale, 'Select Delivery Address'), style: AppTypography.h2(AppColors.textPrimary)),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textTertiary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                for (var address in liveUser.addresses) ...[
                  Card(
                    color: address.isDefault ? AppColors.primaryLight : AppColors.surface,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.borderRadiusMd,
                      side: BorderSide(
                        color: address.isDefault ? AppColors.primary : AppColors.border,
                        width: address.isDefault ? 1.5 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        address.isDefault ? Icons.star : Icons.location_on_outlined,
                        color: address.isDefault ? AppColors.primary : AppColors.textSecondary,
                      ),
                      title: Text(address.title, style: AppTypography.subtitle2(AppColors.textPrimary)),
                      subtitle: Text(address.fullAddress, style: AppTypography.body2(AppColors.textSecondary)),
                      trailing: address.isDefault
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : const Icon(Icons.radio_button_unchecked, color: AppColors.textTertiary),
                      onTap: () {
                        ref.read(userProvider.notifier).setDefaultAddress(address.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Delivery address changed to ${address.title}'),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeightMd,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, AppPageRoute(page: const SavedAddressesScreen()));
                    },
                    icon: const Icon(Icons.add_location_alt_outlined, color: AppColors.primary),
                    label: Text(AppTranslations.tr(ref.watch(settingsProvider).locale, 'Manage & Add Addresses')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: AppRadii.borderRadiusPill),
                    ),
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