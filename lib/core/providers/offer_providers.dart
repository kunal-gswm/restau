import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/offer_model.dart';
import '../data/mock_data.dart';

final offersProvider = Provider<List<Offer>>((ref) {
  return MockData.offers;
});

class LoyaltyNotifier extends Notifier<int> {
  @override
  int build() {
    return MockData.currentUser.loyaltyPoints;
  }

  void addPoints(int points) {
    state += points;
  }
}

final loyaltyProvider = NotifierProvider<LoyaltyNotifier, int>(() {
  return LoyaltyNotifier();
});
