import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/offer_model.dart';

class MockData {
  static const List<String> categories = [
    'Combos',
    'Curries',
    'Biryani',
    'Tandoor',
    'Breads',
    'Desserts',
    'Beverages',
  ];

  static final List<Product> products = [
    // ─── Combos ──────────────────────────────
    Product(
      id: 'p1',
      title: 'Royal Butter Chicken Thali',
      description: 'Slow-cooked in our signature makhani gravy, served with naan, dal, rice, raita, and pickles. A complete feast.',
      price: 499.0,
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Combos',
      isVeg: false,
      isBestseller: true,
      modifierGroups: [
        ModifierGroup(
          id: 'mg1',
          title: 'Bread Choice',
          subtitle: 'Choose 1',
          isRequired: true,
          options: [
            ModifierOption(id: 'mo1', title: 'Butter Naan'),
            ModifierOption(id: 'mo2', title: 'Garlic Naan', extraPrice: 20),
            ModifierOption(id: 'mo3', title: 'Tandoori Roti'),
          ],
        ),
      ],
    ),
    Product(
      id: 'p2',
      title: 'Veg Premium Thali',
      description: 'Paneer Butter Masala, Dal Makhani, Mix Veg, Rice, 2 Roti, Sweet.',
      price: 399.0,
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Combos',
      isVeg: true,
      isBestseller: true,
    ),

    // ─── Biryani ─────────────────────────────
    Product(
      id: 'p3',
      title: 'Chicken Dum Biryani',
      description: 'Fragrant basmati rice cooked with marinated chicken, saffron, and aromatic spices in a sealed pot. Served with raita and salan.',
      price: 299.0,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
      category: 'Biryani',
      isVeg: false,
      isBestseller: true,
      modifierGroups: [
        ModifierGroup(
          id: 'mg2',
          title: 'Portion Size',
          subtitle: 'Choose 1',
          isRequired: true,
          options: [
            ModifierOption(id: 'mo4', title: 'Regular', subtitle: 'Serves 1'),
            ModifierOption(id: 'mo5', title: 'Large', subtitle: 'Serves 2-3', extraPrice: 100),
          ],
        ),
        ModifierGroup(
          id: 'mg3',
          title: 'Add-ons',
          subtitle: 'Optional',
          allowMultiple: true,
          options: [
            ModifierOption(id: 'mo6', title: 'Extra Chicken', extraPrice: 80),
            ModifierOption(id: 'mo7', title: 'Boiled Egg', extraPrice: 30),
            ModifierOption(id: 'mo8', title: 'Extra Raita', extraPrice: 40),
          ],
        ),
      ],
    ),
    Product(
      id: 'p4',
      title: 'Mutton Handi Biryani',
      description: 'Tender mutton pieces layered with long grain basmati rice, slow-cooked in a clay pot.',
      price: 449.0,
      imageUrl: 'https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Biryani',
      isVeg: false,
    ),
    Product(
      id: 'p5',
      title: 'Paneer Tikka Biryani',
      description: 'Smoked paneer tikka tossed with biryani rice and mild spices.',
      price: 279.0,
      imageUrl: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Biryani',
      isVeg: true,
    ),

    // ─── Tandoor ─────────────────────────────
    Product(
      id: 'p6',
      title: 'Paneer Tikka',
      description: 'Cottage cheese cubes marinated in yogurt and spices, grilled in tandoor.',
      price: 249.0,
      imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Tandoor',
      isVeg: true,
      isBestseller: true,
    ),
    Product(
      id: 'p7',
      title: 'Smoked Tandoori Chicken',
      description: 'Half chicken marinated in traditional tandoori masala and roasted to perfection.',
      price: 349.0,
      imageUrl: 'https://images.unsplash.com/photo-1599487405445-5dfadfac4201?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Tandoor',
      isVeg: false,
    ),

    // ─── Desserts & Beverages ───────────────
    Product(
      id: 'p8',
      title: 'Mango Lassi',
      description: 'Thick yogurt drink blended with sweet alphonso mangoes.',
      price: 99.0,
      imageUrl: 'https://images.unsplash.com/photo-1572448862527-d3c904757de6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Beverages',
      isVeg: true,
    ),
    Product(
      id: 'p9',
      title: 'Gulab Jamun (2 pcs)',
      description: 'Soft milk dumplings fried and soaked in sugar syrup.',
      price: 79.0,
      imageUrl: 'https://images.unsplash.com/photo-1596706788540-362c4a9a08e6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Desserts',
      isVeg: true,
    ),
  ];

  static final User currentUser = User(
    id: 'u1',
    name: 'Alex Doe',
    email: 'alex.doe@example.com',
    phone: '+91 9876543210',
    loyaltyPoints: 1450,
    loyaltyTier: 'Grill Master',
    addresses: [
      Address(
        id: 'a1',
        title: 'Home',
        fullAddress: '456 Palm Avenue, Koramangala, Bangalore 560034',
        isDefault: true,
      ),
      Address(
        id: 'a2',
        title: 'Office',
        fullAddress: 'Tech Park Block B, Indiranagar, Bangalore 560038',
      ),
    ],
    paymentMethods: [
      PaymentMethod(
        id: 'pm1',
        type: 'upi',
        title: 'Google Pay',
        subtitle: 'Linked to 9876543210',
        isDefault: true,
      ),
      PaymentMethod(
        id: 'pm2',
        type: 'card',
        title: 'HDFC Bank Credit Card',
        subtitle: '•••• •••• •••• 4242',
      ),
      PaymentMethod(
        id: 'pm3',
        type: 'cash',
        title: 'Cash on Delivery',
        subtitle: 'Pay at doorstep',
      ),
    ],
  );

  static final List<Offer> offers = [
    Offer(
      id: 'o1',
      title: 'WELCOME50',
      description: 'Get 50% off on your first order up to ₹150.',
      code: 'WELCOME50',
      discountPercentage: 0.50,
      maxDiscount: 150.0,
      type: 'coupon',
    ),
    Offer(
      id: 'o2',
      title: 'FESTIVAL20',
      description: 'Flat 20% off on all Biryanis.',
      code: 'FESTIVAL20',
      discountPercentage: 0.20,
      maxDiscount: 200.0,
      minOrderValue: 499.0,
      type: 'coupon',
    ),
  ];
}
