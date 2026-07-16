import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/offer_model.dart';
import '../data/mock_data.dart';
import 'shared_prefs_provider.dart';

const Object _sentinel = Object();

class CartState {
  static const double standardDeliveryFee = 40.0;

  final List<CartItem> items;
  final Offer? appliedOffer;

  const CartState({
    this.items = const [],
    this.appliedOffer,
  });

  CartState copyWith({
    List<CartItem>? items,
    Object? appliedOffer = _sentinel,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedOffer: appliedOffer == _sentinel ? this.appliedOffer : appliedOffer as Offer?,
    );
  }

  // Calculated fields
  double get itemTotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get discount {
    if (appliedOffer == null) return 0.0;
    if (appliedOffer!.minOrderValue != null && itemTotal < appliedOffer!.minOrderValue!) {
      return 0.0; // Minimum order value not met
    }
    double calcDiscount = itemTotal * appliedOffer!.discountPercentage;
    if (appliedOffer!.maxDiscount != null && calcDiscount > appliedOffer!.maxDiscount!) {
      return appliedOffer!.maxDiscount!;
    }
    return calcDiscount;
  }

  double get subtotal => itemTotal - discount;
  double get taxes => subtotal * 0.05; // 5% tax
  double get deliveryFee => (itemTotal > 500 || items.isEmpty) ? 0.0 : standardDeliveryFee;
  double get grandTotal => subtotal + taxes + deliveryFee;
  
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartNotifier extends Notifier<CartState> {
  static const _cartKey = 'app_cart_state';
  final _uuid = const Uuid();

  @override
  CartState build() {
    final prefs = ref.read(sharedPrefsProvider);
    final cartJson = prefs.getString(_cartKey);
    
    if (cartJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(cartJson);
        final items = <CartItem>[];
        for (var map in decoded) {
          final pId = map['productId'] as String;
          final qty = map['quantity'] as int;
          final product = MockData.products.firstWhere((p) => p.id == pId, orElse: () => MockData.products.first);
          items.add(CartItem(
            id: _uuid.v4(),
            product: product,
            quantity: qty,
          ));
        }
        return CartState(items: items);
      } catch (e) {
        return const CartState();
      }
    }
    return const CartState();
  }

  void _saveToCache() {
    final prefs = ref.read(sharedPrefsProvider);
    final simplifiedList = state.items.map((i) => {
      'productId': i.product.id,
      'quantity': i.quantity,
    }).toList();
    prefs.setString(_cartKey, jsonEncode(simplifiedList));
  }

  void addItem({
    required Product product,
    required int quantity,
    List<SelectedModifier> selectedModifiers = const [],
    String specialInstructions = '',
  }) {
    // Basic logic to check if identical item exists (same product and modifiers) could go here
    // For simplicity, we just add a new row
    
    final newItem = CartItem(
      id: _uuid.v4(),
      product: product,
      quantity: quantity,
      selectedModifiers: selectedModifiers,
      specialInstructions: specialInstructions,
    );

    state = state.copyWith(
      items: [...state.items, newItem],
    );
    _saveToCache();
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    state = state.copyWith(
      items: state.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList(),
    );
    _saveToCache();
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
    _saveToCache();
  }

  void clearCart() {
    state = const CartState();
    _saveToCache();
  }

  bool applyCoupon(String code) {
    try {
      final offer = MockData.offers.firstWhere((o) => o.code.toUpperCase() == code.toUpperCase());
      if (offer.minOrderValue != null && state.itemTotal < offer.minOrderValue!) {
        return false;
      }
      state = state.copyWith(appliedOffer: offer);
      return true;
    } catch (e) {
      return false; // Coupon not found
    }
  }
  
  void removeCoupon() {
    state = state.copyWith(appliedOffer: null);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
