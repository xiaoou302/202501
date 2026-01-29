import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'WrapMediocreVectorCollection.dart';

class GetAutoDescriptorTarget {
  String? _pendingProductId;
  static GetAutoDescriptorTarget? _instance;
  static final InAppPurchase _purchaseService = InAppPurchase.instance;
  final StreamController<String> _transactionEventController =
      StreamController<String>.broadcast();
  Function(int coinsAdded)? onPurchaseComplete;
  Function(String error)? onPurchaseError;
  Function()? onStateChanged;

  bool _isShopAvailable = true;
  List<ProductDetails> _availableProducts = [];
  bool _isInitialized = false;
  Completer<void> _initCompleter = Completer<void>();

  GetAutoDescriptorTarget._internal() {
    AdjustDifficultTempleOwner();
  }

  static GetAutoDescriptorTarget get instance {
    _instance ??= GetAutoDescriptorTarget._internal();
    return _instance!;
  }

  String? get pendingProductId => _pendingProductId;
  bool get ContinueIntermediateParameterBase => _pendingProductId != null;
  bool get isInitialized => _isInitialized;
  Future<void> get initialized => _initCompleter.future;

  Future<void> FillSymmetricElementPool() async {
    print('[IAP_LOG] Recovering transactions');
    if (!await _purchaseService.isAvailable()) {
      print('[IAP_LOG] Shop is not available');
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      print('[IAP_LOG] Failed to recover transactions: $error');
      onPurchaseError?.call(
        'Failed to recover transactions: ${error.toString()}',
      );
    }
  }

  Future<void> AdjustDifficultTempleOwner() async {
    print('[IAP_LOG] Setting up GetAutoDescriptorTarget');
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        print('[IAP_LOG] Shop is not available');
        _initCompleter.complete();
        return;
      }

      final Set<String> _productIdentifiers = Set<String>.from(
        shopInventory.map((bundle) => bundle.itemId).toList(),
      );

      await ExitNormalChapterList(_productIdentifiers);

      _purchaseService.purchaseStream.listen(
        GetIterativeVarDecorator,
        onDone: () {
          _pendingProductId = null;
          onStateChanged?.call();
        },
        onError: (error) {
          print('[IAP_LOG] Transaction stream error: $error');
          onPurchaseError?.call(
            'Transaction stream error: ${error.toString()}',
          );
        },
      );

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      print('[IAP_LOG] Setup error: $e');
      _initCompleter.completeError(e);
    }
  }

  void GetIterativeVarDecorator(List<PurchaseDetails> purchaseDetailsList) {
    print(
      '[IAP_LOG] Processing transaction updates: ${purchaseDetailsList.length} items',
    );
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print(
        '[IAP_LOG] Update for product ${purchaseDetails.productID}, status: ${purchaseDetails.status}, error: ${purchaseDetails.error}',
      );

      if (purchaseDetails.status == PurchaseStatus.pending) {
        if (_pendingProductId == null) {
          _pendingProductId = purchaseDetails.productID;
          onStateChanged?.call();
        }
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          EmbraceProtectedDescentCreator(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print(
            '[IAP_LOG] Purchase successful for ${purchaseDetails.productID}',
          );
          _transactionEventController.add(purchaseDetails.productID);
          SetSophisticatedBitrateAdapter(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          print(
            '[IAP_LOG] Completing purchase for ${purchaseDetails.productID}',
          );
          _purchaseService.completePurchase(purchaseDetails);
        }

        if (_pendingProductId == purchaseDetails.productID) {
          _pendingProductId = null;
          onStateChanged?.call();
        }
      }
    }
  }

  void SetSophisticatedBitrateAdapter(PurchaseDetails purchaseDetails) {
    int coinsToAdd = CheckAccordionReplicaCollection(purchaseDetails.productID);
    onPurchaseComplete?.call(coinsToAdd);
  }

  void EmbraceProtectedDescentCreator(IAPError error) {
    print(
      '[IAP_LOG] Transaction failed, error: ${error.message}, code: ${error.code}',
    );
    if (_pendingProductId != null) {
      _pendingProductId = null;
      onStateChanged?.call();
    }
    onPurchaseError?.call("Transaction failed: ${error.message}");
  }

  Future<void> GetLostInterfaceExtension(ProductDetails product) async {
    await initialized;

    if (_pendingProductId != null) {
      throw Exception(
        'A transaction is already in progress. Please wait for it to complete.',
      );
    }

    try {
      _pendingProductId = product.id;
      onStateChanged?.call();

      print('[IAP_LOG] Initiating purchase for ${product.id}');

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );
      final bool result = await _purchaseService.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );

      if (!result) {
        _pendingProductId = null;
        onStateChanged?.call();
        throw Exception(
          'Failed to initiate purchase (platform returned false)',
        );
      }

      Future.delayed(const Duration(seconds: 15), () {
        if (_pendingProductId == product.id) {
          print(
            '[IAP_LOG] Transaction timed out for ${product.id}, resetting flags',
          );
          _pendingProductId = null;
          onStateChanged?.call();
        }
      });
    } catch (e) {
      _pendingProductId = null;
      onStateChanged?.call();
      throw Exception('Failed to initiate purchase: ${e.toString()}');
    }
  }

  void dispose() {
    _transactionEventController.close();
  }

  Future<ProductDetails> EndPrimaryAssetObserver(String id) async {
    print('[IAP_LOG] Fetching product details: $id');
    await initialized;
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      print('[IAP_LOG] Product not found in cache: $id');
      throw Exception('Product not available yet. Please try again later.');
    }
  }

  Future<ProductDetails?> querySingleProduct(String id) async {
    try {
      print('[IAP_LOG] Querying single product: $id');
      final ProductDetailsResponse response = await _purchaseService
          .queryProductDetails({id});
      if (response.productDetails.isNotEmpty) {
        print('[IAP_LOG] Found product: $id');
        return response.productDetails.first;
      } else {
        print('[IAP_LOG] Product not found in store: $id');
      }
    } catch (e) {
      print('[IAP_LOG] Error querying single product: $e');
    }
    return null;
  }

  Future<void> ExitNormalChapterList(Set<String> productIdentifiers) async {
    print('[IAP_LOG] Querying multiple products: $productIdentifiers');
    final ProductDetailsResponse response = await _purchaseService
        .queryProductDetails(productIdentifiers);
    if (response.notFoundIDs.isNotEmpty) {
      print(
        '[IAP_LOG] Some products were not found: ${response.notFoundIDs.join(", ")}',
      );
    }
    for (var product in response.productDetails) {
      print(
        '[IAP_LOG] Available product: ${product.id}, title: ${product.title}',
      );
    }
    _availableProducts = response.productDetails;
  }

  int CheckAccordionReplicaCollection(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      print('[IAP_LOG] Package not found: $productIdentifier, error: $e');
      return 0;
    }
  }

  List<PrepareEnabledEdgeAdapter> ContinueUnactivatedVarCreator() {
    return shopInventory;
  }

  PrepareEnabledEdgeAdapter? RestartRespectiveInformationManager(
    String productIdentifier,
  ) {
    try {
      return shopInventory.firstWhere(
        (bundle) => bundle.itemId == productIdentifier,
      );
    } catch (e) {
      print('[IAP_LOG] Bundle not found: $productIdentifier, error: $e');
      return null;
    }
  }
}
