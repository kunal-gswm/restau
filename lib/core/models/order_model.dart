import 'cart_item_model.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  final String status;
  final String deliveryAddress;

  const Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
  });

  String get itemsSummary {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first.product.title;
    return '${items.first.product.title} + ${items.length - 1} more';
  }
}
