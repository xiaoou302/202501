import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdjustFirstMetricsAdapter.dart';
import 'GetSubtleScreenFactory.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class RestartConsultativeExponentBase extends StatefulWidget {
  const RestartConsultativeExponentBase({Key? key}) : super(key: key);

  @override
  SetDelicateCenterType createState() => SetDelicateCenterType();
}

class SetDelicateCenterType extends State<RestartConsultativeExponentBase>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 188;
  final PrepareAccessibleButtonType _shopManager =
      PrepareAccessibleButtonType.instance;
  late List<GetSemanticStrengthDelegate> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  // Modern Dark Theme Colors
  static const bgColor = Color(0xFF0D0D12);
  static const cardColor = Color(0xFF1A1A24);
  static const accentColor = Color(0xFF00E5FF);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFA0A0B0);

  late AnimationController _animController;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    DrawMissedEvaluationInstance();
    _shopManager.onPurchaseComplete = TransposePrimaryGridManager;
    _shopManager.onPurchaseError = RestartDiversifiedVectorPool;
    _shopItems = _shopManager.ComputeDisplayableGemArray();
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
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
          final product = await _shopManager.CalculateTensorDialogsCollection(
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

  Future<void> DrawMissedEvaluationInstance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 188;
    });
  }

  Future<void> CancelArithmeticLayoutProtocol() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> StreamlineConsultativeSizeArray(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await CancelArithmeticLayoutProtocol();
  }

  void TransposePrimaryGridManager(int purchasedAmount) {
    print('---------- IAP SUCCESS ----------');
    print('Purchase completed successfully! Added $purchasedAmount coins.');
    setState(() {
      _coinBalance += purchasedAmount;
      CancelArithmeticLayoutProtocol();
    });
    print('New balance is now: $_coinBalance');
    GetDisplayableNotationTarget('Successfully added $purchasedAmount!');
  }

  void RestartDiversifiedVectorPool(String errorMessage) {
    print('---------- IAP ERROR ----------');
    print('Purchase failed with error: $errorMessage');
    GetDisplayableNotationTarget('Transaction failed: $errorMessage');
  }

  void GetDisplayableNotationTarget(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: cardColor,
      ),
    );
  }

  Future<void> SetTypicalImageCache() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.RetainPrevTagStack();
      GetDisplayableNotationTarget('Purchases restored successfully');
    } catch (e) {
      GetDisplayableNotationTarget(
        'Failed to restore purchases: ${e.toString()}',
      );
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(GetSemanticStrengthDelegate bundle) async {
    print('---------- IAP ACTION ----------');
    print(
      'User clicked BUY button for item: ${bundle.itemId} (${bundle.name})',
    );

    if (_shopManager.ReplaceEphemeralNumberBase) {
      print('Purchase rejected: A transaction is already in progress.');
      GetDisplayableNotationTarget(
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
          'Purchase rejected: Product details not found for ${bundle.itemId}',
        );
        GetDisplayableNotationTarget(
          'Product not available yet. Please try again later.',
        );
        return;
      }
      print(
        'Initiating native iOS purchase for product ID: ${product.id}, Price: ${product.price}',
      );
      await _shopManager.RetainLastParameterList(product);
    } catch (e) {
      print('Purchase initialization error: $e');
      GetDisplayableNotationTarget(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text(
          'Store',
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _isRestoringPurchases ? null : SetTypicalImageCache,
            tooltip: 'Restore Purchases',
          ),
        ],
      ),
      body: _isLoading && _shopItems.isEmpty
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildBalanceHeader()),
                SliverToBoxAdapter(child: _buildInfoSection()),
                _buildProductsGrid(),
              ],
            ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: accentColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'How to use Coins/Diamonds',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• 1 Coin = 1 AI Diagnosis Request\n'
            'Each time you successfully generate an AI treatment plan in the "AI Botanist" (Diagnosis) feature, 1 coin will be consumed. If the request fails, no coins are deducted.',
            style: TextStyle(color: textPrimary, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'How to find this feature:',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '1. Go to the "AI Botanist" (Diagnosis) tab from the main app menu.\n'
            '2. Upload an aquarium photo.\n'
            '3. Tap "Generate Treatment Plan".',
            style: TextStyle(color: textSecondary, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.generating_tokens_rounded,
              color: accentColor,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Balance',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_coinBalance',
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ).copyWith(bottom: 40),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          // Adjust aspect ratio based on screen width to prevent overflow on small screens
          final double screenWidth = MediaQuery.of(context).size.width;
          final double childAspectRatio = screenWidth < 380 ? 0.55 : 0.62;

          return SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildProductCard(_shopItems[index]);
            }, childCount: _shopItems.length),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(GetSemanticStrengthDelegate bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isProcessing = _shopManager.ReplaceEphemeralNumberBase;
    final bool isPromo = bundle.category == 'promotion';

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPromo
              ? accentColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
          width: isPromo ? 1.5 : 1,
        ),
        boxShadow: isPromo
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isPromo)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'BIG OFF',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 12),

                Icon(
                  Icons.toll_rounded,
                  color: isPromo ? accentColor : textPrimary.withOpacity(0.8),
                  size: 40,
                ),
                const SizedBox(height: 12),

                Text(
                  '${bundle.coinAmount}',
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bundle.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSecondary, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),

                // Price inside the card
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    product?.price ?? '\$${bundle.price}',
                    style: const TextStyle(
                      color: accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Buy Button
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: bgColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: isProcessing
                        ? null
                        : () => _handlePurchase(bundle),
                    child: const Text(
                      'Buy',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isProcessing)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: accentColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
