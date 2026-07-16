class Offer {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discountPercentage;
  final double? maxDiscount;
  final double? minOrderValue;
  final bool isAutoApply;
  final String type; // 'coupon', 'restaurant_offer', 'loyalty'

  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountPercentage,
    this.maxDiscount,
    this.minOrderValue,
    this.isAutoApply = false,
    required this.type,
  });
}

