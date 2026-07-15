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

class SearchFiltersState {
  final bool isVegOnly;
  final double maxPrice;

  const SearchFiltersState({
    this.isVegOnly = false,
    this.maxPrice = 1500.0,
  });

  SearchFiltersState copyWith({bool? isVegOnly, double? maxPrice}) {
    return SearchFiltersState(
      isVegOnly: isVegOnly ?? this.isVegOnly,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

class SearchFiltersNotifier extends Notifier<SearchFiltersState> {
  @override
  SearchFiltersState build() => const SearchFiltersState();

  void toggleVegOnly(bool value) => state = state.copyWith(isVegOnly: value);
  void setMaxPrice(double value) => state = state.copyWith(maxPrice: value);
}

final searchFiltersProvider = NotifierProvider<SearchFiltersNotifier, SearchFiltersState>(() => SearchFiltersNotifier());

class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ['Biryani', 'Paneer Tikka'];

  void addSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = List<String>.from(state);
    current.remove(trimmed);
    current.insert(0, trimmed);
    if (current.length > 5) current.removeLast();
    state = current;
  }
  
  void clearSearches() => state = [];
}

final recentSearchesProvider = NotifierProvider<RecentSearchesNotifier, List<String>>(() => RecentSearchesNotifier());

final searchResultsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filters = ref.watch(searchFiltersProvider);
  
  if (query.isEmpty) return [];
  
  final products = ref.watch(productsProvider);
  return products.where((p) {
    final matchesQuery = p.title.toLowerCase().contains(query) || p.description.toLowerCase().contains(query);
    final matchesVeg = !filters.isVegOnly || p.isVeg;
    final matchesPrice = p.price <= filters.maxPrice;
    return matchesQuery && matchesVeg && matchesPrice;
  }).toList();
});
