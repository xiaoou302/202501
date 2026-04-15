class ProductItem {
  final String productId;
  final String displayName;
  final String productType;
  final int coins;
  final String fallbackPrice;
  final String description;
  final String locale;
  final String category;

  const ProductItem({
    required this.productId,
    required this.displayName,
    required this.productType,
    required this.coins,
    required this.fallbackPrice,
    required this.description,
    required this.locale,
    required this.category,
  });
}

class ProductCatalog {
  static const List<ProductItem> _allProducts = [
    ProductItem(
      productId: 'torami2000',
      displayName: 'Starter Pack',
      productType: 'basic',
      coins: 100,
      fallbackPrice: '0.99',
      description: 'Starter Pack',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2011',
      displayName: 'Small Pack',
      productType: 'basic',
      coins: 200,
      fallbackPrice: '3.99',
      description: 'Small Pack',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2012',
      displayName: 'Large Pack',
      productType: 'basic',
      coins: 350,
      fallbackPrice: '6.99',
      description: 'Large Pack',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2001',
      displayName: 'Pack 1',
      productType: 'basic',
      coins: 500,
      fallbackPrice: '4.99',
      description: 'Pack 1',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2002',
      displayName: 'Pack 2',
      productType: 'basic',
      coins: 1200,
      fallbackPrice: '9.99',
      description: 'Pack 2',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2003',
      displayName: 'Pack 3',
      productType: 'basic',
      coins: 2500,
      fallbackPrice: '19.99',
      description: 'Pack 3',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2004',
      displayName: 'Pack 4',
      productType: 'basic',
      coins: 7000,
      fallbackPrice: '49.99',
      description: 'Pack 4',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2005',
      displayName: 'Pack 5',
      productType: 'basic',
      coins: 15000,
      fallbackPrice: '99.99',
      description: 'Pack 5',
      locale: 'en_US',
      category: 'basic',
    ),
    ProductItem(
      productId: 'torami2006',
      displayName: 'Pack 1 (Discount)',
      productType: 'promotion',
      coins: 500,
      fallbackPrice: '1.99',
      description: 'Pack 1 (Discount)',
      locale: 'en_US',
      category: 'promotion',
    ),
    ProductItem(
      productId: 'torami2007',
      displayName: 'Pack 2 (Discount)',
      productType: 'promotion',
      coins: 1200,
      fallbackPrice: '4.99',
      description: 'Pack 2 (Discount)',
      locale: 'en_US',
      category: 'promotion',
    ),
    ProductItem(
      productId: 'torami2008',
      displayName: 'Pack 3 (Discount)',
      productType: 'promotion',
      coins: 2500,
      fallbackPrice: '11.99',
      description: 'Pack 3 (Discount)',
      locale: 'en_US',
      category: 'promotion',
    ),
    ProductItem(
      productId: 'torami2009',
      displayName: 'Pack 4 (Discount)',
      productType: 'promotion',
      coins: 7000,
      fallbackPrice: '34.99',
      description: 'Pack 4 (Discount)',
      locale: 'en_US',
      category: 'promotion',
    ),
    ProductItem(
      productId: 'torami2010',
      displayName: 'Pack 5 (Discount)',
      productType: 'promotion',
      coins: 15000,
      fallbackPrice: '79.99',
      description: 'Pack 5 (Discount)',
      locale: 'en_US',
      category: 'promotion',
    ),
  ];

  static List<ProductItem> getAllProducts() {
    return _allProducts;
  }

  static ProductItem? findProductById(String id) {
    try {
      return _allProducts.firstWhere((item) => item.productId == id);
    } catch (e) {
      return null;
    }
  }

  static int getCoinAmount(String productId) {
    try {
      return _allProducts
          .firstWhere((item) => item.productId == productId)
          .coins;
    } catch (e) {
      return 0;
    }
  }
}
