class DecoupleIndependentCoordContainer {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const DecoupleIndependentCoordContainer({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<DecoupleIndependentCoordContainer> shopInventory = <DecoupleIndependentCoordContainer>[
  DecoupleIndependentCoordContainer(
    itemId: 'com.uuidflutter.test.1',
    name: 'Black Iron',
    type: 'basic',
    coinAmount: 140,
    price: '2.19',
    description: 'Black Iron',
    locale: 'en_US',
    category: 'basic',
  ),
  DecoupleIndependentCoordContainer(
    itemId: 'com.Radiant.1',
    name: 'Black Iron',
    type: 'basic',
    coinAmount: 140,
    price: '2.89',
    description: 'Black Iron',
    locale: 'en_US',
    category: 'basic',
  ),
  DecoupleIndependentCoordContainer(
    itemId: 'com.Radiant.2',
    name: 'Silver',
    type: 'basic',
    coinAmount: 400,
    price: '7.59',
    description: 'Silver',
    locale: 'en_US',
    category: 'basic',
  ),
  DecoupleIndependentCoordContainer(
    itemId: 'com.Radiant.3',
    name: 'Gold',
    type: 'basic',
    coinAmount: 1600,
    price: '21.99',
    description: 'Gold',
    locale: 'en_US',
    category: 'basic',
  ),
  DecoupleIndependentCoordContainer(
    itemId: 'com.Radiant.4',
    name: 'Diamond',
    type: 'basic',
    coinAmount: 7700,
    price: '89.99',
    description: 'Diamond',
    locale: 'en_US',
    category: 'basic',
  ),
  DecoupleIndependentCoordContainer(
    itemId: 'com.Radiant.vip.1month',
    name: 'VIP Monthly',
    type: 'subscription',
    coinAmount: 10000,
    price: '8.99',
    description: 'VIP Membership - 1 Month',
    locale: 'en_US',
    category: 'vip',
  ),
];
