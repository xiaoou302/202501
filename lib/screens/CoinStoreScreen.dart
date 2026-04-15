import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductCatalog.dart';
import 'IAPManager.dart';
import '../utils/theme.dart';

class CoinStoreScreen extends StatefulWidget {
  const CoinStoreScreen({Key? key}) : super(key: key);

  @override
  State<CoinStoreScreen> createState() => _CoinStoreScreenState();
}

class _CoinStoreScreenState extends State<CoinStoreScreen> {
  int _currentCoins = 0;
  final IAPManager _iapManager = IAPManager.shared;
  Map<String, dynamic> _loadedProducts = {};
  bool _dataLoading = true;
  bool _isInfoExpanded = false;

  @override
  void initState() {
    super.initState();
    _setupStore();
  }

  Future<void> _setupStore() async {
    await _fetchCoinBalance();
    _iapManager.purchaseSuccessCallback = _handlePurchaseSuccess;
    _iapManager.purchaseErrorCallback = _handlePurchaseError;
    await _fetchProductDetails();
  }

  Future<void> _fetchCoinBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentCoins = prefs.getInt('accountGemBalance') ?? 0;
      });
    }
  }

  Future<void> _updateCoinBalance(int newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', newBalance);
  }

  Future<void> _fetchProductDetails() async {
    if (!mounted) return;

    setState(() {
      _dataLoading = true;
    });

    try {
      await IAPManager.shared.initializationComplete;

      final catalog = ProductCatalog.getAllProducts();
      for (var item in catalog) {
        try {
          final details = await IAPManager.shared.fetchProductInfo(
            item.productId,
          );
          if (mounted) {
            setState(() {
              _loadedProducts[item.productId] = details;
            });
          }
        } catch (e) {
          debugPrint('Product load failed: ${item.productId} - $e');
        }
      }
    } catch (e) {
      debugPrint('Store initialization failed: $e');
      if (mounted) {
        _displayMessage('Store loading failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _dataLoading = false;
        });
      }
    }
  }

  void _handlePurchaseSuccess(int coinAmount) {
    if (!mounted) return;

    setState(() {
      _currentCoins += coinAmount;
      _updateCoinBalance(_currentCoins);
    });
    _displayMessage('+$coinAmount coins added to your balance!');
  }

  void _handlePurchaseError(String error) {
    if (!mounted) return;
    _displayMessage('Purchase failed: $error');
  }

  void _displayMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: AppTheme.aeroNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _processPurchase(ProductItem item) async {
    if (IAPManager.shared.hasActiveTransaction) {
      _displayMessage('Please wait for the current purchase to finish.');
      return;
    }

    setState(() {
      _dataLoading = true;
    });

    try {
      final productInfo = _loadedProducts[item.productId];
      if (productInfo == null) {
        _displayMessage('This product is not available right now.');
        return;
      }

      await IAPManager.shared.startPurchase(productInfo);
    } catch (e) {
      _displayMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _dataLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.polarIce,
      body: SafeArea(
        child: _dataLoading && _loadedProducts.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.laminarCyan,
                  ),
                ),
              )
            : Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: _buildCoinBalanceWidget()),
                        SliverToBoxAdapter(child: _buildInfoCard()),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              'Choose Your Package',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.aeroNavy,
                              ),
                            ),
                          ),
                        ),
                        _buildProductList(),
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.aeroNavy.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.aeroNavy,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Coin Store',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.aeroNavy,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBalanceWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.aeroNavy, Color(0xFF2C4362)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: Colors.amberAccent,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Balance',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_currentCoins',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentCoins == 0
                      ? 'Purchase coins to start scanning airfoils'
                      : 'Balance updated after purchases',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.laminarCyan.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isInfoExpanded = !_isInfoExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.laminarCyan,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Coin Usage Information',
                          style: TextStyle(
                            color: AppTheme.aeroNavy,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        _isInfoExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppTheme.aeroNavy.withOpacity(0.5),
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '• Each airfoil scan on the Scan page will consume 1 coin.',
                    style: TextStyle(
                      color: AppTheme.aeroNavy,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(
                      width: double.infinity,
                      height: 0,
                    ),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• If your coin balance is insufficient, you will not be able to scan an airfoil.',
                          style: TextStyle(
                            color: AppTheme.aeroNavy,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        const Text(
                          'Q: What can users buy with coins in the app?',
                          style: TextStyle(
                            color: AppTheme.turbulenceMagenta,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A: Users can use coins to pay for the airfoil scanning feature. This feature uses local NACA airfoil generation algorithms to automatically generate airfoil geometry (NURBS/Bezier curves) from user-uploaded sketches, photos, or physical wing profiles.',
                          style: TextStyle(
                            color: AppTheme.aeroNavy.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Q: How to find this feature?',
                          style: TextStyle(
                            color: AppTheme.turbulenceMagenta,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A: 1. Go back to the main navigation bar at the bottom.\n2. Tap the "Scan" icon in the middle.\n3. Tap the "Album" or "Camera" button at the bottom of the Scan page to select or capture an image.\n4. The app will automatically consume 1 coin and process the image to generate a random airfoil model.',
                          style: TextStyle(
                            color: AppTheme.aeroNavy.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    crossFadeState: _isInfoExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    sizeCurve: Curves.easeInOutCubic,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final catalog = ProductCatalog.getAllProducts();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = catalog[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildProductItem(item),
        );
      }, childCount: catalog.length),
    );
  }

  Widget _buildProductItem(ProductItem item) {
    final productInfo = _loadedProducts[item.productId];
    final bool canPurchase = productInfo != null;
    final bool busy = IAPManager.shared.hasActiveTransaction;
    final bool isSpecial = item.productType == 'promotion';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.aeroNavy.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: canPurchase && !busy ? () => _processPurchase(item) : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSpecial
                        ? AppTheme.turbulenceMagenta.withOpacity(0.1)
                        : AppTheme.laminarCyan.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.monetization_on_rounded,
                    color: isSpecial
                        ? AppTheme.turbulenceMagenta
                        : Colors.amber,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${item.coins}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.aeroNavy,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Coins',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.aeroNavy.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.displayName,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.aeroNavy.withOpacity(0.7),
                        ),
                      ),
                      if (isSpecial) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.turbulenceMagenta.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Special Offer',
                            style: TextStyle(
                              color: AppTheme.turbulenceMagenta,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      productInfo?.price ?? '\$${item.fallbackPrice}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.aeroNavy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.laminarCyan, Color(0xFF00B0B0)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
