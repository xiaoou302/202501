import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GenerateSharedInitiativeTarget.dart';
import 'SetPermissiveExponentReference.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class PrepareCurrentTaxonomyReference extends StatefulWidget {
  const PrepareCurrentTaxonomyReference({Key? key}) : super(key: key);

  @override
  TrainUniqueScenarioDelegate createState() => TrainUniqueScenarioDelegate();
}

class TrainUniqueScenarioDelegate extends State<PrepareCurrentTaxonomyReference>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 6000;
  final GetDenseZoneImplement _shopManager = GetDenseZoneImplement.instance;
  late List<CancelPriorBaselineHandler> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  // Brand colors from the app theme
  static const deepSpace = Color(0xFF1C1C22);
  static const champagne = Color(0xFFD3B88C);
  static const moonlight = Color(0xFFEAEAEA);
  static const silverstone = Color(0xFF3A3A42);
  static const coral = Color(0xFFE87A90);

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    FinishPriorGraphAdapter();
    _shopManager.onPurchaseComplete = SetRequiredOpacityList;
    _shopManager.onPurchaseError = ShowUniqueCardFactory;
    _shopItems = _shopManager.GetLargeRendererReference();
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

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
          final product = await _shopManager.GetPermissiveOccasionArray(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      CreateAutoVisiblePool('Failed to load store: ${e.toString()}');
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

  Future<void> FinishPriorGraphAdapter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 6000;
    });
  }

  Future<void> GetTypicalVariableObserver() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> ExtendResilientBufferHandler(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await GetTypicalVariableObserver();
  }

  void SetRequiredOpacityList(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      GetTypicalVariableObserver();
    });
    CreateAutoVisiblePool('Successfully added $purchasedAmount coins!');
  }

  void ShowUniqueCardFactory(String errorMessage) {
    CreateAutoVisiblePool('Transaction failed: $errorMessage');
  }

  void CreateAutoVisiblePool(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: silverstone,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> PausePrevStateCreator() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.PrepareCommonListenerBase();
      CreateAutoVisiblePool('Purchases restored successfully');
    } catch (e) {
      CreateAutoVisiblePool('Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(CancelPriorBaselineHandler bundle) async {
    if (_shopManager.PushCrucialAllocatorImplement) {
      CreateAutoVisiblePool(
          'Please wait for the current transaction to complete.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        CreateAutoVisiblePool(
            'Product not available yet. Please try again later.');
        return;
      }
      await _shopManager.ResetNewestWorkflowType(product);
    } catch (e) {
      CreateAutoVisiblePool(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 375;

    return Scaffold(
      backgroundColor: deepSpace,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: champagne),
                    const SizedBox(height: 16),
                    Text(
                      'Loading Store...',
                      style: TextStyle(
                        color: moonlight.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildModernHeader(isSmallScreen),
                  SliverToBoxAdapter(child: _buildBalanceCard(isSmallScreen)),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16),
                    sliver: _buildPackageGrid(isSmallScreen),
                  ),
                  // SliverToBoxAdapter(child: _buildRestoreButton(isSmallScreen)),
                  SliverPadding(
                      padding:
                          EdgeInsets.only(bottom: isSmallScreen ? 20 : 32)),
                ],
              ),
      ),
    );
  }

  Widget _buildModernHeader(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 80 : 100,
      pinned: true,
      backgroundColor: deepSpace,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            'Love Store',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.w700,
              color: moonlight,
              fontFamily: 'Inter',
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: moonlight, size: isSmallScreen ? 20 : 24),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBalanceCard(bool isSmallScreen) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                champagne.withOpacity(0.15),
                coral.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: champagne.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: champagne.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              AllocateEuclideanParamFactory(isSmallScreen),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Balance',
                      style: TextStyle(
                        color: moonlight.withOpacity(0.7),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_coinBalance',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28 : 32,
                        fontWeight: FontWeight.bold,
                        color: champagne,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      'Each use of the AI ​​function in the app will consume 1 coin',
                      style: TextStyle(
                        color: moonlight.withOpacity(0.6),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: isSmallScreen ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: coral.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.favorite,
                  color: coral,
                  size: isSmallScreen ? 18 : 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget AllocateEuclideanParamFactory(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [champagne.withOpacity(0.3), champagne.withOpacity(0.1)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: champagne.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.diamond_outlined,
        color: champagne,
        size: isSmallScreen ? 24 : 28,
      ),
    );
  }

  Widget _buildPackageGrid(bool isSmallScreen) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmallScreen ? 1 : 2,
        childAspectRatio: isSmallScreen ? 3.2 : 0.7,
        crossAxisSpacing: isSmallScreen ? 8 : 12,
        mainAxisSpacing: isSmallScreen ? 8 : 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) =>
            _buildLovePackageCard(_shopItems[index], isSmallScreen, index),
        childCount: _shopItems.length,
      ),
    );
  }

  Widget _buildLovePackageCard(
      CancelPriorBaselineHandler bundle, bool isSmallScreen, int index) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.PushCrucialAllocatorImplement;
    final bool isPromotion = bundle.category == 'promotion';

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5 + (index * 0.1)),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animController,
          curve:
              Interval(0.1 + (index * 0.05), 1.0, curve: Curves.easeOutCubic),
        )),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPromotion
                  ? [coral.withOpacity(0.15), coral.withOpacity(0.05)]
                  : [
                      silverstone.withOpacity(0.8),
                      silverstone.withOpacity(0.4)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPromotion
                  ? coral.withOpacity(0.3)
                  : champagne.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPromotion ? coral : champagne).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                if (isPromotion)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: coral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SALE',
                        style: TextStyle(
                          color: moonlight,
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Opacity(
                  opacity: (isAvailable && !isProcessing) ? 1.0 : 0.5,
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    child: isSmallScreen
                        ? _buildHorizontalLayout(bundle, product, isPromotion,
                            isAvailable, isProcessing)
                        : _buildVerticalLayout(bundle, product, isPromotion,
                            isAvailable, isProcessing),
                  ),
                ),
                if (isProcessing)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(color: champagne),
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

  Widget _buildHorizontalLayout(CancelPriorBaselineHandler bundle, ProductDetails? product,
      bool isPromotion, bool isAvailable, bool isProcessing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with icon, name and price
        Row(
          children: [
            _buildPackageIcon(isPromotion, true),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bundle.name,
                    style: const TextStyle(
                      color: moonlight,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildCoinInfo(bundle, true),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              product?.price ?? bundle.price,
              style: TextStyle(
                color: isPromotion ? coral : champagne,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Purchase button on its own line
        SizedBox(
          width: double.infinity,
          child: _buildPurchaseButton(bundle, isAvailable, isProcessing, true),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(CancelPriorBaselineHandler bundle, ProductDetails? product,
      bool isPromotion, bool isAvailable, bool isProcessing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPackageIcon(isPromotion, false),
        const SizedBox(height: 12),
        Flexible(
          child: Text(
            bundle.name,
            style: const TextStyle(
              color: moonlight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        _buildCoinInfo(bundle, false),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            bundle.description,
            style: TextStyle(
              color: moonlight.withOpacity(0.6),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product?.price ?? bundle.price,
          style: TextStyle(
            color: isPromotion ? coral : champagne,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildPurchaseButton(bundle, isAvailable, isProcessing, false),
      ],
    );
  }

  Widget _buildPackageIcon(bool isPromotion, bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 8 : 12),
      decoration: BoxDecoration(
        color: (isPromotion ? coral : champagne).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isPromotion ? Icons.local_fire_department : Icons.favorite,
        color: isPromotion ? coral : champagne,
        size: isSmall ? 20 : 24,
      ),
    );
  }

  Widget _buildCoinInfo(CancelPriorBaselineHandler bundle, bool isSmall) {
    return Row(
      children: [
        Icon(
          Icons.diamond_outlined,
          color: champagne,
          size: isSmall ? 16 : 18,
        ),
        const SizedBox(width: 4),
        Text(
          '${bundle.coinAmount}',
          style: TextStyle(
            color: champagne,
            fontSize: isSmall ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'coins',
          style: TextStyle(
            color: moonlight.withOpacity(0.6),
            fontSize: isSmall ? 12 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton(
      CancelPriorBaselineHandler bundle, bool isAvailable, bool isProcessing, bool isSmall) {
    return ElevatedButton(
      onPressed:
          (isAvailable && !isProcessing) ? () => _handlePurchase(bundle) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: champagne,
        foregroundColor: deepSpace,
        elevation: 0,
        minimumSize: const Size(double.infinity, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Purchase',
        style: TextStyle(
          fontSize: isSmall ? 14 : 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
