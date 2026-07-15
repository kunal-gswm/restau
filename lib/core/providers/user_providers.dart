import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';
import 'menu_providers.dart';

final userProvider = Provider<User>((ref) {
  return MockData.currentUser;
});

class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ['p1', 'p3']; // Mock some initial favorites
  }

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(() {
  return FavoritesNotifier();
});

// Provides only the products that are favorited
final favoriteProductsProvider = Provider((ref) {
  final allProducts = ref.watch(productsProvider); // from menu_providers.dart (will need import)
  final favoriteIds = ref.watch(favoritesProvider);
  return allProducts.where((p) => favoriteIds.contains(p.id)).toList();
});
