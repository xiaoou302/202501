class StopCustomPreviewCreator {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const StopCustomPreviewCreator({
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

const List<StopCustomPreviewCreator> shopInventory = <StopCustomPreviewCreator>[
  StopCustomPreviewCreator(
    itemId: 'rue20000',
    name: 'Rue Package',
    type: 'basic',
    coinAmount: 100,
    price: '0.99',
    description: 'Rue Package',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20001',
    name: 'Rue Package 1',
    type: 'basic',
    coinAmount: 500,
    price: '4.99',
    description: 'Rue Package 1',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20002',
    name: 'Rue Package 2',
    type: 'basic',
    coinAmount: 1200,
    price: '9.99',
    description: 'Rue Package 2',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20003',
    name: 'Rue Package 3',
    type: 'basic',
    coinAmount: 2500,
    price: '19.99',
    description: 'Rue Package 3',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20004',
    name: 'Rue Package 4',
    type: 'basic',
    coinAmount: 7000,
    price: '49.99',
    description: 'Rue Package 4',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20005',
    name: 'Rue Package 5',
    type: 'basic',
    coinAmount: 15000,
    price: '99.99',
    description: 'Rue Package 5',
    locale: 'en_US',
    category: 'basic',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20006',
    name: 'Rue Package 1',
    type: 'promo',
    coinAmount: 500,
    price: '1.99',
    description: 'Rue Package 1 (Big Off)',
    locale: 'en_US',
    category: 'promo',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20007',
    name: 'Rue Package 2',
    type: 'promo',
    coinAmount: 1200,
    price: '4.99',
    description: 'Rue Package 2 (Big Off)',
    locale: 'en_US',
    category: 'promo',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20008',
    name: 'Rue Package 3',
    type: 'promo',
    coinAmount: 2500,
    price: '11.99',
    description: 'Rue Package 3 (Big Off)',
    locale: 'en_US',
    category: 'promo',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20009',
    name: 'Rue Package 4',
    type: 'promo',
    coinAmount: 7000,
    price: '34.99',
    description: 'Rue Package 4 (Big Off)',
    locale: 'en_US',
    category: 'promo',
  ),
  StopCustomPreviewCreator(
    itemId: 'rue20010',
    name: 'Rue Package 5',
    type: 'promo',
    coinAmount: 15000,
    price: '79.99',
    description: 'Rue Package 5 (Big Off)',
    locale: 'en_US',
    category: 'promo',
  ),
];
