import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/offer_model.dart';
import '../data/mock_data.dart';

class CartState {
  final List<CartItem> items;
  final Offer? appliedOffer;

  const CartState({
    this.items = const [],
    this.appliedOffer,
  });

  CartState copyWith({
    List<CartItem>? items,
    Offer? appliedOffer,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedOffer: appliedOffer ?? this.appliedOffer,
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
  double get deliveryFee => (itemTotal > 500 || items.isEmpty) ? 0.0 : 40.0;
  double get grandTotal => subtotal + taxes + deliveryFee;
  
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartNotifier extends Notifier<CartState> {
  final _uuid = const Uuid();

  @override
  CartState build() {
    return const CartState();
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
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  void clearCart() {
    state = const CartState();
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
    // We cannot pass null to copyWith if it uses `??` logic to ignore nulls, 
    // so we recreate the state
    state = CartState(items: state.items, appliedOffer: null);
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});
