class PrepareEnabledEdgeAdapter {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const PrepareEnabledEdgeAdapter({
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

const List<PrepareEnabledEdgeAdapter> shopInventory = <PrepareEnabledEdgeAdapter>[
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1100',
    name: 'Strida Package',
    type: 'consumable',
    coinAmount: 100,
    price: '0.99',
    description: 'Strida Package',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1101',
    name: 'Strida Package 1',
    type: 'consumable',
    coinAmount: 500,
    price: '4.99',
    description: 'Strida Package 1',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1102',
    name: 'Strida Package 2',
    type: 'consumable',
    coinAmount: 1000,
    price: '9.99',
    description: 'Strida Package 2',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1103',
    name: 'Strida Package 3',
    type: 'consumable',
    coinAmount: 2000,
    price: '19.99',
    description: 'Strida Package 3',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1104',
    name: 'Strida Package 4',
    type: 'consumable',
    coinAmount: 5000,
    price: '49.99',
    description: 'Strida Package 4',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1105',
    name: 'Strida Package 5',
    type: 'consumable',
    coinAmount: 10000,
    price: '99.99',
    description: 'Strida Package 5',
    locale: 'en_US',
    category: 'basic',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1106',
    name: 'Strida Package 1（Big Off）',
    type: 'consumable',
    coinAmount: 600,
    price: '4.99',
    description: 'Strida Package 1（Big Off）',
    locale: 'en_US',
    category: 'promo',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1107',
    name: 'Strida Package 2（Big Off）',
    type: 'consumable',
    coinAmount: 1200,
    price: '9.99',
    description: 'Strida Package 2（Big Off）',
    locale: 'en_US',
    category: 'promo',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1108',
    name: 'Strida Package 3（Big Off）',
    type: 'consumable',
    coinAmount: 2500,
    price: '19.99',
    description: 'Strida Package 3（Big Off）',
    locale: 'en_US',
    category: 'promo',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1109',
    name: 'Strida Package 4（Big Off）',
    type: 'consumable',
    coinAmount: 6000,
    price: '49.99',
    description: 'Strida Package 4（Big Off）',
    locale: 'en_US',
    category: 'promo',
  ),
  PrepareEnabledEdgeAdapter(
    itemId: 'strida1110',
    name: 'Strida Package 5（Big Off）',
    type: 'consumable',
    coinAmount: 12000,
    price: '99.99',
    description: 'Strida Package 5（Big Off）',
    locale: 'en_US',
    category: 'promo',
  ),
];
