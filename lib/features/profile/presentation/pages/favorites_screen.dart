import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/user_providers.dart';
import '../../../home/presentation/widgets/order_again_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet.', style: AppTypography.subtitle1(AppColors.textSecondary)))
          : GridView.builder(
              padding: AppSpacing.screenAll,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.75,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return OrderAgainCard(
                  title: product.title,
                  contextText: product.category,
                  price: '₹${product.price.toInt()}',
                  imageUrl: product.imageUrl,
                  onReorder: () {},
                );
              },
            ),
    );
  }
}
