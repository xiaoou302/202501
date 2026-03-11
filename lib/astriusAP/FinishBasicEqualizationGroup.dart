import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SchedulePriorDescriptionAdapter.dart';
import 'GetRobustCoordCache.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../utils/app_colors.dart';
import '../../widgets/glass_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptimizeSymmetricNodeHelper extends StatefulWidget {
  const OptimizeSymmetricNodeHelper({Key? key}) : super(key: key);

  @override
  KeepSubtleDurationFilter createState() => KeepSubtleDurationFilter();
}

class KeepSubtleDurationFilter extends State<OptimizeSymmetricNodeHelper>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 1688;
  final GetLiteAllocatorObserver _shopManager =
      GetLiteAllocatorObserver.instance;
  late List<ParsePriorParamCollection> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    SetGeometricAllocatorManager();
    _shopManager.onPurchaseComplete = GetSemanticValueReference;
    _shopManager.onPurchaseError = CancelSharedLatencyDelegate;
    _shopItems = _shopManager.FillLiteIndexInstance();
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
          final product = await _shopManager.PauseMultiPositionImplement(
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
      FinishRetainedPopupGroup('Failed to load store: ${e.toString()}');
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

  Future<void> SetGeometricAllocatorManager() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 1688;
    });
  }

  Future<void> AddCrucialChartInstance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  void GetSemanticValueReference(int purchasedAmount) {
    print(
      '[IAP_LOG] GetSemanticValueReference called. Amount: $purchasedAmount',
    );
    setState(() {
      _coinBalance += purchasedAmount;
      AddCrucialChartInstance();
    });
    FinishRetainedPopupGroup('Successfully added $purchasedAmount coins!');
  }

  void CancelSharedLatencyDelegate(String errorMessage) {
    print('[IAP_LOG] CancelSharedLatencyDelegate called. Error: $errorMessage');
    FinishRetainedPopupGroup('Transaction failed: $errorMessage');
  }

  void FinishRetainedPopupGroup(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.orionPurple),
    );
  }

  Future<void> _handlePurchase(ParsePriorParamCollection bundle) async {
    print('[IAP_LOG] User tapped purchase for ${bundle.itemId}');
    if (_shopManager.ConvertIndependentParamFactory) {
      print('[IAP_LOG] Transaction already in progress (UI check)');
      FinishRetainedPopupGroup(
        'Please wait for the current transaction to complete.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      ProductDetails? product = _productDetails[bundle.itemId];

      if (product == null) {
        print(
          '[IAP_LOG] Product details not found locally for ${bundle.itemId}. Fetching...',
        );
        try {
          product = await _shopManager.FetchSpecificProduct(bundle.itemId);
          if (product != null) {
            print(
              '[IAP_LOG] Product details fetched successfully for ${bundle.itemId}',
            );
            _productDetails[bundle.itemId] = product;
          } else {
            print(
              '[IAP_LOG] FetchSpecificProduct returned null for ${bundle.itemId}',
            );
          }
        } catch (e) {
          print('[IAP_LOG] Error fetching specific product: $e');
        }
      } else {
        print('[IAP_LOG] Product details found locally for ${bundle.itemId}');
      }

      if (product == null) {
        print('[IAP_LOG] Product is still null after fetch attempt');
        FinishRetainedPopupGroup(
          'Product not available yet. Please try again later.',
        );
        return;
      }
      print('[IAP_LOG] Calling EmbedArithmeticHeadAdapter for ${product.id}');
      await _shopManager.EmbedArithmeticHeadAdapter(product);
    } catch (e) {
      print('[IAP_LOG] Exception in _handlePurchase: $e');
      FinishRetainedPopupGroup(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cosmicBlack,
      appBar: AppBar(
        title: const Text(
          'Store',
          style: TextStyle(
            color: AppColors.starlightWhite,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.starlightWhite),
          onPressed: () => Navigator.pop(context),
        ),
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
                  color: AppColors.orionPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.orionPurple.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FontAwesomeIcons.coins,
                      size: 14,
                      color: AppColors.andromedaCyan,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_coinBalance',
                      style: const TextStyle(
                        color: AppColors.starlightWhite,
                        fontWeight: FontWeight.bold,
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.orionPurple,
                ),
              ),
            )
          : FadeTransition(
              opacity: _opacityAnimation,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: GlassPanel(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.circleInfo,
                                  color: AppColors.andromedaCyan,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Coin Usage & Instructions',
                                  style: TextStyle(
                                    color: AppColors.starlightWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInstructionItem(
                              '1. Usage',
                              'Each AI Planner request in the Control Hub consumes 1 Coin. Insufficient balance will prevent new requests.',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionItem(
                              '2. Purchase',
                              'Select a coin package below and tap "Purchase" to top up your balance.',
                            ),
                            const SizedBox(height: 12),
                            _buildInstructionItem(
                              '3. Balance',
                              'Your current balance is displayed at the top right of this screen.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return _buildProductCard(_shopItems[index]);
                      }, childCount: _shopItems.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
    );
  }

  Widget _buildInstructionItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.andromedaCyan.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: TextStyle(
            color: AppColors.meteoriteGrey,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ParsePriorParamCollection bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isProcessing = _shopManager.ConvertIndependentParamFactory;

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.orionPurple.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Icon(
                      bundle.category == 'vip'
                          ? FontAwesomeIcons.crown
                          : FontAwesomeIcons.gem,
                      size: 32,
                      color: AppColors.andromedaCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  bundle.name,
                  style: const TextStyle(
                    color: AppColors.starlightWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${bundle.coinAmount} Coins',
                  style: TextStyle(
                    color: AppColors.meteoriteGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkMatter.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product?.price ?? '\$${bundle.price}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.andromedaCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: (!isProcessing) ? () => _handlePurchase(bundle) : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (!isProcessing)
                            ? [AppColors.orionPurple, const Color(0xFF5E2296)]
                            : [AppColors.meteoriteGrey, Colors.grey],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: (!isProcessing)
                          ? [
                              BoxShadow(
                                color: AppColors.orionPurple.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: const Text(
                      'Purchase',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (bundle.category == 'promo')
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.safelightRed,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Text(
                  'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
