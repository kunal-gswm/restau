import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../shared/widgets/cart_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../widgets/loyalty_summary_card.dart';
import '../widgets/order_again_card.dart';
import '../widgets/category_pill.dart';
import '../../../menu/presentation/pages/menu_screen.dart';
import '../../../cart/presentation/pages/cart_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int _cartItems = 0;
  double _cartTotal = 0.0;

  void _addToCart(double price) {
    setState(() {
      _cartItems++;
      _cartTotal += price;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Handle bottom nav tab switching
    return Scaffold(
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeBody(context),
          const MenuScreen(),
          _buildOffersPlaceholder(),
          const ProfileScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _cartItems > 0
          ? CartBar(
              itemCount: _cartItems,
              total: _cartTotal,
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

  Widget _buildOffersPlaceholder() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_offer, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Special Offers', style: AppTypography.h1(AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: AppSpacing.screenH,
              child: Text(
                'Exclusive deals and seasonal promotions\ncoming your way!',
                style: AppTypography.body2(AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody(BuildContext context) {
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
                Text(
                  'Home',
                  style: AppTypography.subtitle2(AppColors.textPrimary),
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
                      'Alex',
                      style: AppTypography.display(AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

              // ─── Hero Banner ───────────────────────────────────
              _buildHeroBanner(context),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Loyalty ───────────────────────────────────────
              LoyaltySummaryCard(points: 350, onTap: () {}),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Categories ────────────────────────────────────
              SizedBox(
                height: 52,
                child: ListView(
                  padding: AppSpacing.screenH,
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryPill(title: 'All', emoji: '✨', isSelected: true),
                    SizedBox(width: AppSpacing.sm),
                    CategoryPill(title: 'Thalis', emoji: '🍛'),
                    SizedBox(width: AppSpacing.sm),
                    CategoryPill(title: 'Biryanis', emoji: '🍚'),
                    SizedBox(width: AppSpacing.sm),
                    CategoryPill(title: 'Tandoor', emoji: '🔥'),
                    SizedBox(width: AppSpacing.sm),
                    CategoryPill(title: 'Drinks', emoji: '🥤'),
                    SizedBox(width: AppSpacing.sm),
                    CategoryPill(title: 'Desserts', emoji: '🍰'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Order Again ───────────────────────────────────
              SectionHeader(
                title: 'Your Favourites',
                actionText: 'See all',
                onAction: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 225,
                child: ListView(
                  padding: AppSpacing.screenH,
                  scrollDirection: Axis.horizontal,
                  children: [
                    OrderAgainCard(
                      title: 'Butter Chicken Thali',
                      contextText: 'Your Friday dinner',
                      price: '₹349',
                      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                      onReorder: () => _addToCart(349.0),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    OrderAgainCard(
                      title: 'Paneer Tikka',
                      contextText: 'Ordered 2 weeks ago',
                      price: '₹249',
                      imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                      onReorder: () => _addToCart(249.0),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    OrderAgainCard(
                      title: 'Chicken Biryani',
                      contextText: 'Most ordered',
                      price: '₹299',
                      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
                      onReorder: () => _addToCart(299.0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // ─── Today's Special ───────────────────────────────
              SectionHeader(title: 'Chef\'s Recommendation'),
              const SizedBox(height: AppSpacing.lg),
              _buildTodaysSpecial(context),

              // Bottom padding for FAB
              SizedBox(height: _cartItems > 0 ? 120 : 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
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
            // Background image
            Image.network(
              'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: AppColors.surfaceMuted),
            ),

            // Gradient overlay for text readability
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

            // Content overlay
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Seasonal tag
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

                  // Title
                  Text(
                    'Smoked Tandoori\nPlatter',
                    style: AppTypography.h1(AppColors.textInverse).copyWith(
                      fontSize: 28,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // CTA
                  Material(
                    color: AppColors.surface,
                    borderRadius: AppRadii.borderRadiusPill,
                    child: InkWell(
                      onTap: () => _addToCart(799.0),
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
                              'Order Now  •  ₹799',
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
            // Image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xxl)),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
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

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Royal Butter Chicken Thali',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Slow-cooked in our signature makhani gravy, served with naan, dal, rice, raita, and pickles. A complete feast.',
                    style: AppTypography.body1(AppColors.textSecondary).copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Price + CTA
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹499',
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
                      onPressed: () => _addToCart(499.0),
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