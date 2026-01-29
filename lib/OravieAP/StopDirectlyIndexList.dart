import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'GetSustainableScaleBase.dart';
import 'WrapMediocreVectorCollection.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oravie/core/constants/app_colors.dart';

class CompareGranularProgressBarOwner extends StatefulWidget {
  const CompareGranularProgressBarOwner({Key? key}) : super(key: key);

  @override
  ProvideBackwardColorInstance createState() => ProvideBackwardColorInstance();
}

class ProvideBackwardColorInstance
    extends State<CompareGranularProgressBarOwner>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 2100;
  final GetAutoDescriptorTarget _shopManager = GetAutoDescriptorTarget.instance;
  late List<PrepareEnabledEdgeAdapter> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    EncapsulateMultiEquivalentAdapter();
    _shopManager.onPurchaseComplete = SetDelicateRangeTarget;
    _shopManager.onPurchaseError = CreateNewestOccasionArray;
    _shopManager.onStateChanged = () {
      if (mounted) setState(() {});
    };
    _shopItems = _shopManager.ContinueUnactivatedVarCreator();
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
          final product = await _shopManager.EndPrimaryAssetObserver(
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
      ProvideRelationalMonsterReference(
        'Failed to load store: ${e.toString()}',
      );
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

  Future<void> EncapsulateMultiEquivalentAdapter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 2100;
    });
  }

  Future<void> GetPrimaryCoordDelegate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  void SetDelicateRangeTarget(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      GetPrimaryCoordDelegate();
    });
    ProvideRelationalMonsterReference(
      'Successfully added $purchasedAmount coins!',
    );
  }

  void CreateNewestOccasionArray(String errorMessage) {
    if (mounted) {
      setState(() {}); // Refresh UI to re-enable buttons
    }
    ProvideRelationalMonsterReference('Transaction failed: $errorMessage');
  }

  void ProvideRelationalMonsterReference(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.charcoal,
      ),
    );
  }

  Future<void> _handlePurchase(PrepareEnabledEdgeAdapter bundle) async {
    if (_shopManager.ContinueIntermediateParameterBase) {
      return;
    }

    try {
      // Try to get the product from our cache
      ProductDetails? product = _productDetails[bundle.itemId];

      // If not in cache, try to fetch it dynamically from the store
      if (product == null) {
        product = await _shopManager.querySingleProduct(bundle.itemId);
      }

      // If still null, we cannot proceed with a real purchase
      if (product == null) {
        ProvideRelationalMonsterReference(
          'Product not found in App Store. Please check your internet connection.',
        );
        return;
      }

      await _shopManager.GetLostInterfaceExtension(product);
    } catch (e) {
      ProvideRelationalMonsterReference(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.slateGreen,
                    ),
                  ),
                )
              : CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(),
                    SliverToBoxAdapter(child: _buildBalanceSection()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: _buildProductGrid(),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        // Top Left Blob
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.slateGreen.withOpacity(0.15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slateGreen.withOpacity(0.15),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Center Right Blob (Warm tone)
        Positioned(
          top: 200,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0C3A5).withOpacity(0.2), // Warm beige
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE0C3A5).withOpacity(0.2),
                  blurRadius: 80,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        // Blur Filter
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(color: Colors.white.withOpacity(0.3)),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120.0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.charcoal,
            size: 18,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: const Text(
          'Store',
          style: TextStyle(
            color: AppColors.charcoal,
            fontWeight: FontWeight.w900,
            fontFamily: 'Playfair Display',
            fontSize: 24,
          ),
        ),
        background: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.slateGreen, Color(0xFF3A5F5F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.slateGreen.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.coins,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$_coinBalance',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        // Hint Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Requests in AI Discourse and AI Visualization consume 1 coin each.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProductGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.56, // Adjusted for small screens
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildProductCard(_shopItems[index]),
        childCount: _shopItems.length,
      ),
    );
  }

  Widget _buildProductCard(PrepareEnabledEdgeAdapter bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAnyProcessing = _shopManager.ContinueIntermediateParameterBase;
    final bool isProcessingThis =
        _shopManager.pendingProductId == bundle.itemId;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProductIcon(bundle),
              const SizedBox(height: 12), // Reduced spacing
              Text(
                bundle.name,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.coins,
                    color: AppColors.slateGreen,
                    size: 12, // Reduced icon size
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${bundle.coinAmount}',
                    style: const TextStyle(
                      color: AppColors.slateGreen,
                      fontSize: 13, // Reduced font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  bundle.description,
                  style: TextStyle(
                    color: AppColors.charcoal.withOpacity(0.5),
                    fontSize: 11, // Reduced font size
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  product?.price ?? bundle.price,
                  style: const TextStyle(
                    color: AppColors.charcoal,
                    fontSize: 16, // Reduced font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: isAnyProcessing ? null : () => _handlePurchase(bundle),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10, // Reduced padding
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isProcessingThis
                        ? Colors.grey
                        : AppColors.slateGreen,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isProcessingThis
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.slateGreen.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Center(
                    child: isProcessingThis
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Purchase',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
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

  Widget _buildProductIcon(PrepareEnabledEdgeAdapter bundle) {
    return Container(
      width: 48, // Reduced size
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.slateGreen.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          bundle.category == 'subscription'
              ? FontAwesomeIcons.crown
              : FontAwesomeIcons.bagShopping,
          color: AppColors.slateGreen,
          size: 20, // Reduced icon size
        ),
      ),
    );
  }
}
