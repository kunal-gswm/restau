import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../models/offer_model.dart';
import '../data/mock_data.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return MockData.products;
});

final categoriesProvider = Provider<List<String>>((ref) {
  return MockData.categories;
});

final offersProvider = Provider<List<Offer>>((ref) {
  return MockData.offers;
});

// Provides recommended products (bestsellers)
final recommendedProductsProvider = Provider<List<Product>>((ref) {
  return MockData.products.where((p) => p.isBestseller).toList();
});

// Provides products grouped by category
final menuByCategoryProvider = Provider<Map<String, List<Product>>>((ref) {
  final products = ref.watch(productsProvider);
  final categories = ref.watch(categoriesProvider);
  
  Map<String, List<Product>> grouped = {};
  for (var category in categories) {
    grouped[category] = products.where((p) => p.category == category).toList();
  }
  // Remove empty categories
  grouped.removeWhere((key, value) => value.isEmpty);
  
  return grouped;
});

// Manage selected category in Menu Screen
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return MockData.categories.first;
  }

  void setCategory(String category) {
    state = category;
  }
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(() {
  return SelectedCategoryNotifier();
});

// Search functionality
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

final searchResultsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return [];
  
  final products = ref.watch(productsProvider);
  return products.where((p) => p.title.toLowerCase().contains(query) || p.description.toLowerCase().contains(query)).toList();
});
