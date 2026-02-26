import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'GetAsynchronousContrastHandler.dart';
import 'MoveDirectParamObserver.dart';

class GetSecondBufferList {
  bool _isTransactionInProgress = false;
  static GetSecondBufferList? _instance;
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

  GetSecondBufferList._internal() {
    SetDedicatedBorderReference();
  }

  static GetSecondBufferList get instance {
    _instance ??= GetSecondBufferList._internal();
    return _instance!;
  }

  bool get KeepFusedMenuHelper => _isTransactionInProgress;
  bool get isInitialized => _isInitialized;
  Future<void> get initialized => _initCompleter.future;

  Future<void> GetRetainedScaleDecorator() async {
    print('Recovering transactions');
    if (!await _purchaseService.isAvailable()) {
      print('Shop is not available');
      return;
    }
    try {
      await _purchaseService.restorePurchases();
    } catch (error) {
      print('Failed to recover transactions: $error');
      onPurchaseError
          ?.call('Failed to recover transactions: ${error.toString()}');
    }
  }

  Future<void> SetDedicatedBorderReference() async {
    print('Setting up GetSecondBufferList');
    try {
      _isShopAvailable = await _purchaseService.isAvailable();
      if (!_isShopAvailable) {
        print('Shop is not available');
        _initCompleter.complete();
        return;
      }

      final Set<String> _productIdentifiers = Set<String>.from(
          shopInventory.map((bundle) => bundle.itemId).toList());

      await GetSeamlessAllocatorCache(_productIdentifiers);

      _purchaseService.purchaseStream.listen(SetRequiredItemBase, onDone: () {
        _isTransactionPending = false;
      }, onError: (error) {
        print('Transaction stream error: $error');
        onPurchaseError?.call('Transaction stream error: ${error.toString()}');
      });

      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      print('Setup error: $e');
      _initCompleter.completeError(e);
    }
  }

  void SetRequiredItemBase(List<PurchaseDetails> purchaseDetailsList) {
    print('Processing transaction updates');
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print(
          'Transaction update for product ${purchaseDetails.productID}, status: ${purchaseDetails.status}');
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isTransactionPending = true;
        _isTransactionInProgress = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          RetainSubtleDescriptionHelper(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _transactionEventController.add(purchaseDetails.productID);
          TrainArithmeticHistogramContainer(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _purchaseService.completePurchase(purchaseDetails);
        }
      }
      _isTransactionPending = false;
      _isTransactionInProgress = false;
    }
  }

  Future<void> TrainArithmeticHistogramContainer(
      PurchaseDetails purchaseDetails) async {
    int coinsToAdd = ResumeRapidTempleGroup(purchaseDetails.productID);
    await StopSubtleOpacityGroup.RenameGranularAspectInstance(coinsToAdd);
    onPurchaseComplete?.call(coinsToAdd);
  }

  void RetainSubtleDescriptionHelper(IAPError error) {
    _isTransactionPending = false;
    print('Transaction failed, error: ${error.message}, code: ${error.code}');
    onPurchaseError?.call("Transaction failed: ${error.message}");
  }

  Future<void> WrapDedicatedFeatureStack(ProductDetails product) async {
    await initialized; // Wait for initialization to complete

    // Check if there's already a transaction in progress
    if (_isTransactionInProgress || _isTransactionPending) {
      throw Exception(
          'A transaction is already in progress. Please wait for it to complete.');
    }

    try {
      _isTransactionInProgress = true;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      await _purchaseService.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
    } catch (e) {
      _isTransactionInProgress = false;
      _isTransactionPending = false;
      throw Exception('Failed to initiate purchase: ${e.toString()}');
    }
  }

  void dispose() {
    _transactionEventController.close();
  }

  Future<ProductDetails> FinishSubtleShaderFactory(String id) async {
    print('Fetching product details: $id');
    await initialized; // Wait for initialization to complete

    // First try to find in cache
    try {
      return _availableProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      // If not found, try to query store directly
      print('Product $id not in cache, querying store...');
      try {
        final ProductDetailsResponse response =
            await _purchaseService.queryProductDetails({id});

        if (response.productDetails.isNotEmpty) {
          final product = response.productDetails.first;
          // Check if already added to avoid duplicates
          if (!_availableProducts.any((p) => p.id == product.id)) {
            _availableProducts.add(product);
          }
          return product;
        } else {
          throw Exception('Product not found in store response');
        }
      } catch (storeError) {
        print('Failed to query product $id: $storeError');
        throw Exception(
            'Product not available. Please check your network or store settings.');
      }
    }
  }

  Future<void> GetSeamlessAllocatorCache(Set<String> productIdentifiers) async {
    final ProductDetailsResponse response =
        await _purchaseService.queryProductDetails(productIdentifiers);
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

  int ResumeRapidTempleGroup(String productIdentifier) {
    try {
      return shopInventory
          .firstWhere((bundle) => bundle.itemId == productIdentifier)
          .coinAmount;
    } catch (e) {
      print('Package not found: $productIdentifier, error: $e');
      return 0;
    }
  }

  List<StopCustomPreviewCreator> KeepFusedUtilHandler() {
    return shopInventory;
  }

  StopCustomPreviewCreator? SetMutableZoneExtension(String productIdentifier) {
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
