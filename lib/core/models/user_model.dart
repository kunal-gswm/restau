class Address {
  final String id;
  final String title;
  final String fullAddress;
  final bool isDefault;

  const Address({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.isDefault = false,
  });
}

class PaymentMethod {
  final String id;
  final String type; // 'upi', 'card', 'cash'
  final String title;
  final String subtitle;
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.isDefault = false,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int loyaltyPoints;
  final String loyaltyTier;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.loyaltyPoints,
    required this.loyaltyTier,
    this.addresses = const [],
    this.paymentMethods = const [],
  });
}
