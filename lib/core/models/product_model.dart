class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isVeg;
  final bool isBestseller;
  final List<ModifierGroup> modifierGroups;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isVeg,
    this.isBestseller = false,
    this.modifierGroups = const [],
  });
}

class ModifierGroup {
  final String id;
  final String title;
  final String subtitle;
  final bool isRequired;
  final bool allowMultiple;
  final List<ModifierOption> options;

  const ModifierGroup({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isRequired = false,
    this.allowMultiple = false,
    required this.options,
  });
}

class ModifierOption {
  final String id;
  final String title;
  final String subtitle;
  final double extraPrice;

  const ModifierOption({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.extraPrice = 0.0,
  });
}
