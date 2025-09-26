class CancelPriorBaselineHandler {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const CancelPriorBaselineHandler({
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

const List<CancelPriorBaselineHandler> shopInventory = <CancelPriorBaselineHandler>[
  CancelPriorBaselineHandler(
    itemId: '555800',
    name: 'Love Package',
    type: 'basic',
    coinAmount: 100,
    price: '\$0.99',
    description: 'Love Package',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555801',
    name: 'Love Package 1',
    type: 'basic',
    coinAmount: 500,
    price: '\$4.99',
    description: 'Love Package 1',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555802',
    name: 'Love Package 2',
    type: 'basic',
    coinAmount: 1200,
    price: '\$9.99',
    description: 'Love Package 2',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555803',
    name: 'Love Package 3',
    type: 'basic',
    coinAmount: 2500,
    price: '\$19.99',
    description: 'Love Package 3',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555804',
    name: 'Love Package 4',
    type: 'basic',
    coinAmount: 7000,
    price: '\$49.99',
    description: 'Love Package 4',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555805',
    name: 'Love Package 5',
    type: 'basic',
    coinAmount: 15000,
    price: '\$99.99',
    description: 'Love Package 5',
    locale: 'en_US',
    category: 'basic',
  ),
  CancelPriorBaselineHandler(
    itemId: '555806',
    name: 'Love Package 1 (Big Off)',
    type: 'promotion',
    coinAmount: 500,
    price: '\$1.99',
    description: 'Love Package 1 (Big Off)',
    locale: 'en_US',
    category: 'promotion',
  ),
  CancelPriorBaselineHandler(
    itemId: '555807',
    name: 'Love Package 2 (Big Off)',
    type: 'promotion',
    coinAmount: 1200,
    price: '\$4.99',
    description: 'Love Package 2 (Big Off)',
    locale: 'en_US',
    category: 'promotion',
  ),
  CancelPriorBaselineHandler(
    itemId: '555808',
    name: 'Love Package 3 (Big Off)',
    type: 'promotion',
    coinAmount: 2500,
    price: '\$11.99',
    description: 'Love Package 3 (Big Off)',
    locale: 'en_US',
    category: 'promotion',
  ),
  CancelPriorBaselineHandler(
    itemId: '555809',
    name: 'Love Package 4 (Big Off)',
    type: 'promotion',
    coinAmount: 7000,
    price: '\$34.99',
    description: 'Love Package 4 (Big Off)',
    locale: 'en_US',
    category: 'promotion',
  ),
  CancelPriorBaselineHandler(
    itemId: '555810',
    name: 'Love Package 5 (Big Off)',
    type: 'promotion',
    coinAmount: 15000,
    price: '\$79.99',
    description: 'Love Package 5 (Big Off)',
    locale: 'en_US',
    category: 'promotion',
  ),
];
