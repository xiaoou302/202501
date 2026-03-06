import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MoveAccessibleVariableHandler.dart';
import 'StartSubsequentTempleArray.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class InitializeAutoConfigurationHelper extends StatefulWidget {
  const InitializeAutoConfigurationHelper({Key? key}) : super(key: key);

  @override
  TrainSharedDataHandler createState() => TrainSharedDataHandler();
}

class TrainSharedDataHandler extends State<InitializeAutoConfigurationHelper>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 1228;
  final ConcatenateMainValuePool _shopManager =
      ConcatenateMainValuePool.instance;
  late List<SetCustomVarExtension> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  // Modern Color Palette
  static const primaryColor = Color(0xFF2C2C2E); // Dark Grey
  static const accentColor = Color(0xFF0A84FF); // iOS Blue
  static const backgroundColor = Color(0xFFF2F2F7); // iOS Light Gray Background
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF000000);
  static const secondaryTextColor = Color(0xFF8E8E93);

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    RestartCustomHeadInstance();
    _shopManager.onPurchaseComplete = CancelDiscardedVectorStack;
    _shopManager.onPurchaseError = SetRapidVarCreator;
    _shopItems = _shopManager.SetSignificantIntegerGroup();
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.GetSortedEffectArray(
            bundle.itemId,
          );
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      RefreshHardOriginHelper('Failed to load store: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> RestartCustomHeadInstance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 1228;
    });
  }

  Future<void> GetDirectColorAdapter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> StopNormalTagObserver(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await GetDirectColorAdapter();
  }

  void CancelDiscardedVectorStack(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      GetDirectColorAdapter();
    });
    RefreshHardOriginHelper('Successfully added $purchasedAmount gems!');
  }

  void SetRapidVarCreator(String errorMessage) {
    RefreshHardOriginHelper('Transaction failed: $errorMessage');
  }

  void RefreshHardOriginHelper(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> InitializeGeometricCardExtension() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.CreateDedicatedNumberAdapter();
      RefreshHardOriginHelper('Purchases restored successfully');
    } catch (e) {
      RefreshHardOriginHelper('Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(SetCustomVarExtension bundle) async {
    print(
      'Attempting to purchase item: ${bundle.itemId} (${bundle.name})',
    ); // Log purchase attempt

    if (_shopManager.RestartEasyEdgeBase) {
      print('Purchase blocked: Transaction already in progress');
      RefreshHardOriginHelper(
        'Please wait for the current transaction to complete.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        print(
          'Purchase failed: Product details not found for ${bundle.itemId}',
        );
        RefreshHardOriginHelper(
          'Product not available yet. Please try again later.',
        );
        return;
      }

      print(
        'Initiating purchase for product: ${product.id}, Price: ${product.price}',
      );
      await _shopManager.PrepareUnsortedProjectionHelper(product);
      print('Purchase initiation successful for ${product.id}');
    } catch (e) {
      print('Purchase error for ${bundle.itemId}: $e');
      RefreshHardOriginHelper(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Store',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.diamond_rounded,
                      color: accentColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_coinBalance',
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                // Responsive Grid
                int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                double childAspectRatio = 0.75; // Adjusted for card content

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Disclaimer Section
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.orangeAccent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.orangeAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Usage Information",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Each analysis request in Bean Archive and Flavor Compass consumes 1 Coin.",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              RestartSmallTraversalExtension(_shopItems[index]),
                          childCount: _shopItems.length,
                        ),
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                  ],
                );
              },
            ),
    );
  }

  Widget RestartSmallTraversalExtension(SetCustomVarExtension bundle) {
    final product = _productDetails[bundle.itemId];
    // In production, we should check product != null.
    // For now, since we are hardcoding UI for new IDs that might not be in Apple Sandbox yet,
    // we allow interaction if product is null, but _handlePurchase handles null product check.
    // However, user said "Don't simulate purchase, keep hardcoded IDs".
    // The issue "buttons unclickable" likely comes from `isAvailable` being false because `product` is null.
    // To allow clicking even if product details aren't loaded (so we can at least see the UI/attempt purchase),
    // we can relax this check or ensure we handle the tap.

    // BUT, the user said "Don't simulate". If products aren't in StoreKit, they won't load.
    // If they don't load, `product` is null.
    // If `product` is null, `isAvailable` is false.
    // If `isAvailable` is false, `onTap` is null.
    // If `onTap` is null, button is disabled.

    // User said: "内购界面中卡片中的按钮无法点击... 不要模拟充值... 保持内购id使用硬编码".
    // This implies they want the UI to work even if the product fetch fails or returns nothing (maybe for testing UI layout).
    // OR they expect the product fetch to work and it's failing.

    // If we want the button to be clickable even if product is null (to attempt purchase which will then fail/prompt),
    // we should remove `isAvailable` from the onTap check, or handle it inside `_handlePurchase`.

    // Let's modify to allow tap always, and let _handlePurchase decide/show error.
    final bool isProcessing = _shopManager.RestartEasyEdgeBase;

    // Fallback price if product details not loaded yet
    final String displayPrice = product?.price ?? bundle.price;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: !isProcessing ? () => _handlePurchase(bundle) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    color: accentColor,
                    size: 32,
                  ),
                ),

                // Content
                Column(
                  children: [
                    Text(
                      bundle.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bundle.coinAmount} Coins',
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayPrice,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                // Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isProcessing ? secondaryTextColor : accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          "Purchase",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
