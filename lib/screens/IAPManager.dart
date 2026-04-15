import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'ProductCatalog.dart';

class IAPManager {
  bool _transactionActive = false;
  static IAPManager? _sharedInstance;
  static final InAppPurchase _iap = InAppPurchase.instance;
  final StreamController<String> _eventStream =
      StreamController<String>.broadcast();
  Function(int coinsAdded)? purchaseSuccessCallback;
  Function(String error)? purchaseErrorCallback;

  bool _storeAvailable = true;
  List<ProductDetails> _products = [];
  bool _transactionWaiting = false;
  bool _ready = false;
  Completer<void> _readyCompleter = Completer<void>();

  IAPManager._create() {
    _initialize();
  }

  static IAPManager get shared {
    _sharedInstance ??= IAPManager._create();
    return _sharedInstance!;
  }

  bool get hasActiveTransaction => _transactionActive;
  bool get isReady => _ready;
  Future<void> get initializationComplete => _readyCompleter.future;

  Future<void> restorePurchases() async {
    debugPrint('Starting purchase restoration');
    if (!await _iap.isAvailable()) {
      debugPrint('Store unavailable');
      return;
    }
    try {
      await _iap.restorePurchases();
    } catch (error) {
      debugPrint('Restoration failed: $error');
      purchaseErrorCallback?.call('Restoration failed: ${error.toString()}');
    }
  }

  Future<void> _initialize() async {
    debugPrint('Initializing IAP system');
    try {
      _storeAvailable = await _iap.isAvailable();
      if (!_storeAvailable) {
        debugPrint('Store not available');
        _readyCompleter.complete();
        return;
      }

      final Set<String> ids = Set<String>.from(
        ProductCatalog.getAllProducts().map((item) => item.productId),
      );

      await _loadProducts(ids);

      _iap.purchaseStream.listen(
        _handlePurchaseStream,
        onDone: () {
          _transactionWaiting = false;
        },
        onError: (error) {
          debugPrint('Purchase stream error: $error');
          purchaseErrorCallback?.call('Stream error: ${error.toString()}');
        },
      );

      _ready = true;
      _readyCompleter.complete();
    } catch (e) {
      debugPrint('Init error: $e');
      _readyCompleter.completeError(e);
    }
  }

  void _handlePurchaseStream(List<PurchaseDetails> purchases) {
    debugPrint('Processing purchases');
    for (final PurchaseDetails purchase in purchases) {
      debugPrint('Product: ${purchase.productID}, Status: ${purchase.status}');
      if (purchase.status == PurchaseStatus.pending) {
        _transactionWaiting = true;
        _transactionActive = true;
      } else {
        if (purchase.status == PurchaseStatus.error) {
          _handleError(purchase.error!);
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _eventStream.add(purchase.productID);
          _deliverPurchase(purchase);
        }
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
      _transactionWaiting = false;
      _transactionActive = false;
    }
  }

  void _deliverPurchase(PurchaseDetails purchase) {
    int coins = ProductCatalog.getCoinAmount(purchase.productID);
    purchaseSuccessCallback?.call(coins);
  }

  void _handleError(IAPError error) {
    _transactionWaiting = false;
    debugPrint('Purchase error: ${error.message}, code: ${error.code}');
    purchaseErrorCallback?.call("Purchase failed: ${error.message}");
  }

  Future<void> startPurchase(ProductDetails product) async {
    await initializationComplete;

    if (_transactionActive || _transactionWaiting) {
      throw Exception('Purchase in progress. Please wait.');
    }

    try {
      _transactionActive = true;
      final PurchaseParam param = PurchaseParam(productDetails: product);
      await _iap.buyConsumable(purchaseParam: param, autoConsume: true);
    } catch (e) {
      _transactionActive = false;
      _transactionWaiting = false;
      throw Exception('Purchase failed: ${e.toString()}');
    }
  }

  void dispose() {
    _eventStream.close();
  }

  Future<ProductDetails> fetchProductInfo(String id) async {
    debugPrint('Loading product: $id');
    await initializationComplete;
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      debugPrint('Product not found: $id');
      throw Exception('Product unavailable. Try again later.');
    }
  }

  Future<void> _loadProducts(Set<String> ids) async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products missing: ${response.notFoundIDs.join(", ")}');
    }
    for (var product in response.productDetails) {
      debugPrint('Product loaded: ${product.id}, title: ${product.title}');
    }
    _products = response.productDetails;
    if (_products.isEmpty) {
      debugPrint('No products available');
    }
  }
}
