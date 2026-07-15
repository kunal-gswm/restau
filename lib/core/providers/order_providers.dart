import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    // Start with empty history or mock history
    return [];
  }

  void addOrder(Order order) {
    state = [order, ...state]; // Add to top
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(() {
  return OrdersNotifier();
});
