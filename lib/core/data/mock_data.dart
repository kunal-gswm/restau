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

    // ─── Curries ─────────────────────────────
    Product(
      id: 'p10',
      title: 'Paneer Butter Masala',
      description: 'Rich and creamy tomato gravy simmered with fresh cottage cheese cubes, butter, and fenugreek leaves.',
      price: 269.0,
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Curries',
      isVeg: true,
      isBestseller: true,
      modifierGroups: [
        ModifierGroup(
          id: 'mg_spice1',
          title: 'Spice Level',
          subtitle: 'Choose 1',
          isRequired: true,
          options: [
            ModifierOption(id: 'mo_s1', title: 'Mild / Less Spicy'),
            ModifierOption(id: 'mo_s2', title: 'Medium Spiced'),
            ModifierOption(id: 'mo_s3', title: 'Extra Spicy / Dhaba Style'),
          ],
        ),
      ],
    ),
    Product(
      id: 'p11',
      title: 'Dal Makhani (Overnight Slow Cooked)',
      description: 'Black lentils and red kidney beans slow-cooked overnight with fresh cream, white butter, and gentle spices.',
      price: 229.0,
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Curries',
      isVeg: true,
      isBestseller: true,
    ),
    Product(
      id: 'p12',
      title: 'Chicken Tikka Masala',
      description: 'Charcoal-grilled chicken tikka pieces tossed in a robust, spiced onion-tomato masala gravy.',
      price: 329.0,
      imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Curries',
      isVeg: false,
      isBestseller: true,
    ),
    Product(
      id: 'p13',
      title: 'Kadhai Mutton Rogan Josh',
      description: 'Traditional Kashmiri style slow-braised mutton tender chunks cooked in aromatic spices and red chili extract.',
      price: 459.0,
      imageUrl: 'https://images.unsplash.com/photo-1545830790-68595959c491?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Curries',
      isVeg: false,
    ),

    // ─── Breads ──────────────────────────────
    Product(
      id: 'p14',
      title: 'Butter Garlic Naan',
      description: 'Fluffy tandoori leavened flatbread topped with freshly chopped garlic and brushed with melted butter.',
      price: 65.0,
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Breads',
      isVeg: true,
      isBestseller: true,
    ),
    Product(
      id: 'p15',
      title: 'Tandoori Butter Roti',
      description: 'Whole wheat rustic flatbread baked crisp inside a clay tandoor and finished with butter.',
      price: 35.0,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Breads',
      isVeg: true,
    ),
    Product(
      id: 'p16',
      title: 'Amritsari Stuffed Kulcha',
      description: 'Crispy layered tandoori bread stuffed with spiced potato and paneer mix, served with chole gravy dip.',
      price: 119.0,
      imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Breads',
      isVeg: true,
      isBestseller: true,
    ),

    // ─── More Tandoor & Starters ─────────────
    Product(
      id: 'p17',
      title: 'Afghani Malai Chicken Tikka',
      description: 'Boneless chicken chunks marinated in rich cashew paste, cheese, cream, and crushed black cardamom, roasted golden inside tandoor.',
      price: 339.0,
      imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Tandoor',
      isVeg: false,
      isBestseller: true,
    ),
    Product(
      id: 'p18',
      title: 'Tandoori Soya Chaap',
      description: 'Tender protein-rich soya chunks marinated in spicy yogurt tandoori masala and chargrilled with bell peppers.',
      price: 219.0,
      imageUrl: 'https://images.unsplash.com/photo-1555126634-323283e090fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Tandoor',
      isVeg: true,
    ),

    // ─── Desserts & Beverages ───────────────
    Product(
      id: 'p8',
      title: 'Alphonso Mango Lassi',
      description: 'Thick, creamy churned yogurt drink blended with real alphonso mango pulp and cardamom.',
      price: 99.0,
      imageUrl: 'https://images.unsplash.com/photo-1572448862527-d3c904757de6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Beverages',
      isVeg: true,
      isBestseller: true,
    ),
    Product(
      id: 'p19',
      title: 'Masala Chaas (Spiced Buttermilk)',
      description: 'Refreshing churned buttermilk infused with roasted cumin, green chillies, fresh mint, and black salt.',
      price: 59.0,
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Beverages',
      isVeg: true,
    ),
    Product(
      id: 'p9',
      title: 'Saffron Kesar Gulab Jamun (2 pcs)',
      description: 'Warm, melt-in-mouth milk solids dumplings soaked in rose-cardamom saffron sugar syrup.',
      price: 79.0,
      imageUrl: 'https://images.unsplash.com/photo-1596706788540-362c4a9a08e6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Desserts',
      isVeg: true,
    ),
    Product(
      id: 'p20',
      title: 'Pista Kesari Rasmalai (2 pcs)',
      description: 'Spongy chhena discs dipped in chilled, saffron-sweetened rabdi garnished with crushed pistachios.',
      price: 119.0,
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Desserts',
      isVeg: true,
      isBestseller: true,
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
    Offer(
      id: 'o3',
      title: 'ROYALFEAST',
      description: 'Flat ₹150 off on orders above ₹699. Valid on all curries and combos.',
      code: 'ROYALFEAST',
      discountPercentage: 0.25,
      maxDiscount: 150.0,
      minOrderValue: 699.0,
      type: 'coupon',
    ),
    Offer(
      id: 'o4',
      title: 'SWEETTREAT',
      description: 'Enjoy 30% discount on all Desserts and Beverages.',
      code: 'SWEETTREAT',
      discountPercentage: 0.30,
      maxDiscount: 100.0,
      minOrderValue: 199.0,
      type: 'coupon',
    ),
  ];
}
