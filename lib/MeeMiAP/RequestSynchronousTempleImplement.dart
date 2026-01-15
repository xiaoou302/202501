import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SpinRetainedThresholdCreator.dart';
import 'TrainLargeRecursionContainer.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SkipDirectIntensityImplement extends StatefulWidget {
  const SkipDirectIntensityImplement({Key? key}) : super(key: key);

  @override
  DissociateDedicatedTempleList createState() => DissociateDedicatedTempleList();
}

class DissociateDedicatedTempleList extends State<SkipDirectIntensityImplement> {
  int _coinBalance = 3200;
  final EqualMutableParticleBase _shopManager = EqualMutableParticleBase.instance;
  late List<DropoutNumericalLoopPool> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  // App theme colors
  static const goldColor = Color(0xFFC9A66B);
  static const backgroundColor = Color(0xFF181818);
  static const surfaceColor = Color(0xFF252525);
  static const textColor = Color(0xFFE0E0E0);
  static const subtextColor = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    RestartSortedParamCreator();
    _shopManager.onPurchaseComplete = KeepIndependentTempleHelper;
    _shopManager.onPurchaseError = SetAccessibleNameContainer;
    _shopItems = _shopManager.MitigateHierarchicalKernelAdapter();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.PauseConcurrentButtonCollection(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      InitializeOriginalTempleGroup('Failed to load store: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> RestartSortedParamCreator() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 3200;
    });
  }

  Future<void> ClearCrudeMatrixType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  void KeepIndependentTempleHelper(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      ClearCrudeMatrixType();
    });
    InitializeOriginalTempleGroup('Successfully added $purchasedAmount coins!');
  }

  void SetAccessibleNameContainer(String errorMessage) {
    InitializeOriginalTempleGroup('Purchase failed: $errorMessage');
  }

  void InitializeOriginalTempleGroup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handlePurchase(DropoutNumericalLoopPool bundle) async {
    // Check if transaction is in progress
    if (_shopManager.PrepareRetainedGraphContainer) {
      InitializeOriginalTempleGroup('Please wait for the current transaction to complete.');
      return;
    }

    // Check if product is available
    final product = _productDetails[bundle.itemId];
    if (product == null) {
      // Product not loaded yet, show friendly message
      InitializeOriginalTempleGroup('Loading product details... Please try again in a moment.');
      // Try to reload products
      _loadProducts();
      return;
    }

    // Proceed with purchase
    try {
      await _shopManager.EscalatePriorNameContainer(product);
    } catch (e) {
      InitializeOriginalTempleGroup(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  _buildBalanceCard(),
                  _buildCoinsGrid(),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Coin Store',
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              goldColor.withOpacity(0.15),
              goldColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: goldColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: goldColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: goldColor.withOpacity(0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.monetization_on_rounded,
                color: goldColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Balance',
                    style: TextStyle(
                      fontSize: 13,
                      color: subtextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_coinBalance',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                 Text(
                    'Coins Available',
                    style: TextStyle(
                      fontSize: 12,
                      color: goldColor.withOpacity(0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 coin per AI conversation',
                    style: TextStyle(
                      fontSize: 10,
                      color: subtextColor.withOpacity(0.7),
                      letterSpacing: 0.2,
                    ),
                  ), 
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final bundle = _shopItems[index];
            return _buildCoinCard(bundle);
          },
          childCount: _shopItems.length,
        ),
      ),
    );
  }

  Widget _buildCoinCard(DropoutNumericalLoopPool bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.PrepareRetainedGraphContainer;
    final displayPrice = product?.price ?? bundle.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: bundle.isLimited 
              ? goldColor.withOpacity(0.4)
              : Colors.white.withOpacity(0.05),
          width: bundle.isLimited ? 1.5 : 1,
        ),
        boxShadow: bundle.isLimited
            ? [
                BoxShadow(
                  color: goldColor.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon Section
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getCategoryGradient(bundle.category),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getCategoryColor(bundle.category).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _getCategoryIcon(bundle.category),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              // Info Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bundle.isLimited)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: goldColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LIMITED',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: goldColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    if (bundle.isLimited) const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: goldColor,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${bundle.coinAmount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            'Coins',
                            style: TextStyle(
                              fontSize: 11,
                              color: subtextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayPrice,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: goldColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Purchase Button - Always enabled
              SizedBox(
                width: 70,
                height: 36,
                child: ElevatedButton(
                  onPressed: () => _handlePurchase(bundle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: backgroundColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isProcessing
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              backgroundColor,
                            ),
                          ),
                        )
                      : const Text(
                          'Buy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'limited':
        return [
          const Color(0xFFFFD700),
          const Color(0xFFFFA500),
        ];
      case 'premium':
        return [
          const Color(0xFF9C27B0),
          const Color(0xFF673AB7),
        ];
      case 'popular':
        return [
          const Color(0xFF2196F3),
          const Color(0xFF1976D2),
        ];
      default:
        return [
          goldColor,
          goldColor.withOpacity(0.7),
        ];
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'limited':
        return const Color(0xFFFFD700);
      case 'premium':
        return const Color(0xFF9C27B0);
      case 'popular':
        return const Color(0xFF2196F3);
      default:
        return goldColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'limited':
        return Icons.local_fire_department_rounded;
      case 'premium':
        return Icons.diamond_rounded;
      case 'popular':
        return Icons.star_rounded;
      default:
        return Icons.monetization_on_rounded;
    }
  }
}
