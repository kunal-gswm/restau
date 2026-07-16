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

  Address copyWith({
    String? id,
    String? title,
    String? fullAddress,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      title: title ?? this.title,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }
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

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDefault: isDefault ?? this.isDefault,
    );
  }
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

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? loyaltyPoints,
    String? loyaltyTier,
    List<Address>? addresses,
    List<PaymentMethod>? paymentMethods,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }
}
