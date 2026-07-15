import 'product_model.dart';

class CartItem {
  final String id; // Unique ID for this cart entry (UUID)
  final Product product;
  final int quantity;
  final List<SelectedModifier> selectedModifiers;
  final String specialInstructions;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedModifiers = const [],
    this.specialInstructions = '',
  });

  double get totalPrice {
    double modifiersTotal = selectedModifiers.fold(
      0.0,
      (sum, mod) => sum + mod.option.extraPrice,
    );
    return (product.price + modifiersTotal) * quantity;
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    List<SelectedModifier>? selectedModifiers,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedModifiers: selectedModifiers ?? this.selectedModifiers,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

class SelectedModifier {
  final ModifierGroup group;
  final ModifierOption option;

  const SelectedModifier({
    required this.group,
    required this.option,
  });
}
