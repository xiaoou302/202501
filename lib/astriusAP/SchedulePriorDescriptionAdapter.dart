import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'GetRobustCoordCache.dart';

class GetLiteAllocatorObserver {
  bool _isTransactionInProgress = false;
  static GetLiteAllocatorObserver? _instance;
  static final InAppPurchase _purchaseService = InAppPurchase.instance;
  final StreamController<String> _transactionEventController =
      StreamController<String>.broadcast();
  Function(int coinsAdded)? onPurchaseComplete;
  Function(String error)? onPurchaseError;

  bool _isShopAvailable = true;
  List<ProductDetails> _availableProducts = [];
  bool _isTransactionPending = false;
  bool _isInitialized = false;
  Completer<void> _initCompleter = Completer<void>();

  GetLiteAllocatorObserver._internal() {
    SetGreatChallengeHelper();
  }

  static GetLiteAllocatorObserver get instance {
    _instance ??= GetLiteAllocatorObserver._internal();
    return _instance!;
  }

  bool get ConvertIndependentParamFactory => _isTransactionInProgress;
  bool get isInitialized => _isInitialized;
  Future<void> get initialized => _initCompleter.future;

  Future<void> ResumeSynchronousTweakOwner() async {
    print('Recovering transactions');
    if (!await _purchaseService.isAvailable()) {
      print('Shop is not available');
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      print('Failed to recover transactions: $error');
      onPurchaseError?.call(
        'Failed to recover transactions: ${error.toString()}',
      );
    }
  }

  Future<void> SetGreatChallengeHelper() async {
    print('Setting up GetLiteAllocatorObserver');
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        print('Shop is not available');
        _initCompleter.complete();
        return;
      }

      final Set<String> _productIdentifiers = Set<String>.from(
        shopInventory.map((bundle) => bundle.itemId).toList(),
      );

      await AccelerateCommonBrushOwner(_productIdentifiers);

      _purchaseService.purchaseStream.listen(
        LimitDenseOptimizerFilter,
        onDone: () {
          _isTransactionPending = false;
        },
        onError: (error) {
          print('Transaction stream error: $error');
          onPurchaseError?.call(
            'Transaction stream error: ${error.toString()}',
          );
        },
      );

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      print('Setup error: $e');
      _initCompleter.completeError(e);
    }
  }

  void LimitDenseOptimizerFilter(List<PurchaseDetails> purchaseDetailsList) {
    print('[IAP_LOG] Processing transaction updates');
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print(
        '[IAP_LOG] Transaction update for product ${purchaseDetails.productID}, status: ${purchaseDetails.status}',
      );
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isTransactionPending = true;
        _isTransactionInProgress = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          SetElasticControllerHelper(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('[IAP_LOG] Purchase success: ${purchaseDetails.productID}');
          _transactionEventController.add(purchaseDetails.productID);
          PrepareSignificantPreviewArray(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print(
            '[IAP_LOG] Completing purchase for ${purchaseDetails.productID}',
          );
          _purchaseService.completePurchase(purchaseDetails);
        }
      }
      _isTransactionPending = false;
      _isTransactionInProgress = false;
    }
  }

  void PrepareSignificantPreviewArray(PurchaseDetails purchaseDetails) {
    print(
      '[IAP_LOG] PrepareSignificantPreviewArray for ${purchaseDetails.productID}',
    );
    int coinsToAdd = CheckTensorFragmentsDecorator(purchaseDetails.productID);
    onPurchaseComplete?.call(coinsToAdd);
  }

  void SetElasticControllerHelper(IAPError error) {
    _isTransactionPending = false;
    print(
      '[IAP_LOG] Transaction failed, error: ${error.message}, code: ${error.code}, details: ${error.details}',
    );
    onPurchaseError?.call("Transaction failed: ${error.message}");
  }

  Future<void> EmbedArithmeticHeadAdapter(ProductDetails product) async {
    print('[IAP_LOG] EmbedArithmeticHeadAdapter called for ${product.id}');
    await initialized; // Wait for initialization to complete

    // Check if there's already a transaction in progress
    if (_isTransactionInProgress || _isTransactionPending) {
      print('[IAP_LOG] Transaction already in progress');
      throw Exception(
        'A transaction is already in progress. Please wait for it to complete.',
      );
    }

    try {
      _isTransactionInProgress = true;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      print('[IAP_LOG] Initiating buyConsumable for ${product.id}');
      await _purchaseService.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
      print('[IAP_LOG] buyConsumable initiated successfully');
    } catch (e) {
      _isTransactionInProgress = false;
      _isTransactionPending = false;
      print('[IAP_LOG] Failed to initiate purchase: $e');
      throw Exception('Failed to initiate purchase: ${e.toString()}');
    }
  }

  void dispose() {
    _transactionEventController.close();
  }

  Future<ProductDetails> PauseMultiPositionImplement(String id) async {
    print('Fetching product details: $id');
    await initialized; // Wait for initialization to complete
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      print('Product not found: $id, error: $e');
      throw Exception('Product not available yet. Please try again later.');
    }
  }

  Future<ProductDetails?> FetchSpecificProduct(String id) async {
    if (!await _purchaseService.isAvailable()) {
      print('Store not available');
      return null;
    }
    try {
      final ProductDetailsResponse response = await _purchaseService
          .queryProductDetails({id});
      if (response.productDetails.isNotEmpty) {
        return response.productDetails.first;
      }
    } catch (e) {
      print('Error fetching product $id: $e');
    }
    return null;
  }

  Future<void> AccelerateCommonBrushOwner(
    Set<String> productIdentifiers,
  ) async {
    final ProductDetailsResponse response = await _purchaseService
        .queryProductDetails(productIdentifiers);
    if (response.notFoundIDs.isNotEmpty) {
      print('Some products were not found: ${response.notFoundIDs.join(", ")}');
    }
    for (var product in response.productDetails) {
      print('Available product: ${product.id}, title: ${product.title}');
    }
    _availableProducts = response.productDetails;
    if (_availableProducts.isEmpty) {
      print('No available products found');
    }
  }

  int CheckTensorFragmentsDecorator(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      print('Package not found: $productIdentifier, error: $e');
      return 0;
    }
  }

  List<ParsePriorParamCollection> FillLiteIndexInstance() {
    return shopInventory;
  }

  ParsePriorParamCollection? AssociateCrucialConfigurationCache(
    String productIdentifier,
  ) {
    try {
      return shopInventory.firstWhere(
        (bundle) => bundle.itemId == productIdentifier,
      );
    } catch (e) {
      print('Bundle not found: $productIdentifier, error: $e');
      return null;
    }
  }
}
