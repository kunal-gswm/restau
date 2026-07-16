import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';
import 'menu_providers.dart';
import 'shared_prefs_provider.dart';

class UserNotifier extends Notifier<User> {
  @override
  User build() {
    return MockData.currentUser;
  }

  void setDefaultAddress(String addressId) {
    final updatedAddresses = state.addresses.map((a) {
      return a.copyWith(isDefault: a.id == addressId);
    }).toList();
    state = state.copyWith(addresses: updatedAddresses);
  }

  void addAddress(Address address) {
    final updatedAddresses = [...state.addresses, address];
    state = state.copyWith(addresses: updatedAddresses);
  }

  void updateAddress(String addressId, String title, String fullAddress) {
    final updatedAddresses = state.addresses.map((a) {
      if (a.id == addressId) {
        return a.copyWith(title: title, fullAddress: fullAddress);
      }
      return a;
    }).toList();
    state = state.copyWith(addresses: updatedAddresses);
  }

  void addPaymentMethod(PaymentMethod method) {
    final updatedMethods = [...state.paymentMethods, method];
    state = state.copyWith(paymentMethods: updatedMethods);
  }

  void deletePaymentMethod(String title) {
    final updatedMethods = state.paymentMethods.where((m) => m.title != title).toList();
    state = state.copyWith(paymentMethods: updatedMethods);
  }

  void updateProfile({String? name, String? phone, String? email}) {
    state = state.copyWith(
      name: name ?? state.name,
      phone: phone ?? state.phone,
      email: email ?? state.email,
    );
  }
// Provides only the products that are favorited
final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

class FavoritesNotifier extends Notifier<List<String>> {
  static const _favoritesKey = 'app_favorites';

  @override
  List<String> build() {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getStringList(_favoritesKey) ?? ['p1', 'p3']; // Load from cache, fallback to defaults
  }

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = state.where((id) => id != productId).toList();
    } else {
      state = [...state, productId];
    }
    
    // Save to cache
    ref.read(sharedPrefsProvider).setStringList(_favoritesKey, state);
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
