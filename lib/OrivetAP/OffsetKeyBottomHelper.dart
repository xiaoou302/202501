import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SetDiscardedSkewXContainer.dart';
import 'GetAsynchronousContrastHandler.dart';
import 'MoveDirectParamObserver.dart';
import '../core/constants/colors.dart';

class ContinueEasyChapterHandler extends StatefulWidget {
  const ContinueEasyChapterHandler({Key? key}) : super(key: key);

  @override
  TrainRequiredStyleImplement createState() => TrainRequiredStyleImplement();
}

class TrainRequiredStyleImplement extends State<ContinueEasyChapterHandler> {
  int _coinBalance = 0;
  final GetSecondBufferList _shopManager = GetSecondBufferList.instance;
  late List<StopCustomPreviewCreator> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    ExecuteSophisticatedOptionManager();
    _shopManager.onPurchaseComplete = SkipElasticVertexGroup;
    _shopManager.onPurchaseError = RestartOpaqueGridReference;
    _shopItems = _shopManager.KeepFusedUtilHandler();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      // Get all available products first to avoid multiple calls if possible,
      // but FinishSubtleShaderFactory calls are fine.

      // We will try to load each item. Even if some fail, we continue.
      for (var bundle in _shopItems) {
        try {
          // If the product is not found in store, this throws.
          // But maybe the user wants to see the button enabled anyway for testing?
          // No, "don't simulate". So we must rely on store.

          final product =
              await _shopManager.FinishSubtleShaderFactory(bundle.itemId);
          if (mounted) {
            setState(() {
              _productDetails[bundle.itemId] = product;
            });
          }
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      if (mounted) {
        CancelDiscardedScreenOwner('Failed to load store: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> ExecuteSophisticatedOptionManager() async {
    final balance =
        await StopSubtleOpacityGroup.FinishTensorParameterObserver();
    if (mounted) {
      setState(() {
        _coinBalance = balance;
      });
    }
  }

  Future<void> RestartUsedMenuImplement() async {
    // Balance is now managed by StopSubtleOpacityGroup directly
    // This method is kept for compatibility or can be removed if not used elsewhere
  }

  void SkipElasticVertexGroup(int purchasedAmount) async {
    if (!mounted) return;
    // Reload the updated balance from storage
    final balance =
        await StopSubtleOpacityGroup.FinishTensorParameterObserver();
    setState(() {
      _coinBalance = balance;
    });
    CancelDiscardedScreenOwner('Successfully added $purchasedAmount coins!');
  }

  void RestartOpaqueGridReference(String errorMessage) {
    if (!mounted) return;
    CancelDiscardedScreenOwner(errorMessage);
  }

  void CancelDiscardedScreenOwner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: GoogleFonts.lato(color: AppColors.vellum)),
        backgroundColor: AppColors.leather,
      ),
    );
  }

  Future<void> _handlePurchase(StopCustomPreviewCreator bundle) async {
    if (_shopManager.KeepFusedMenuHelper) {
      CancelDiscardedScreenOwner(
          'Please wait for the current transaction to complete.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Try to get product details, but if not found, we need to create a ProductDetails object manually
      // or try to fetch it again. StoreKit requires a ProductDetails object to initiate purchase.
      ProductDetails? product = _productDetails[bundle.itemId];

      if (product == null) {
        // Attempt one last fetch
        try {
          product = await _shopManager.FinishSubtleShaderFactory(bundle.itemId);
        } catch (e) {
          print("Final fetch failed: $e");
        }
      }

      if (product == null) {
        // If we absolutely cannot get ProductDetails, we cannot proceed with StoreKit purchase
        // because buyConsumable requires it.
        // However, the user insists IDs are valid.
        // If they are valid, FinishSubtleShaderFactory should have found them.
        // If it failed, it means network issue or configuration mismatch.

        CancelDiscardedScreenOwner(
            'Cannot connect to store. Please check internet or try again.');
        return;
      }

      await _shopManager.WrapDedicatedFeatureStack(product);
    } catch (e) {
      CancelDiscardedScreenOwner(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vellum,
      appBar: AppBar(
        backgroundColor: AppColors.leather,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(FontAwesomeIcons.chevronLeft, color: AppColors.vellum),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'STORE',
          style: GoogleFonts.cinzel(
            color: AppColors.vellum,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.leather))
          : Column(
              children: [
                _buildBalanceHeader(),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65, // Taller cards for better fit
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _shopItems.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_shopItems[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.leather,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Text(
            "CURRENT BALANCE",
            style: GoogleFonts.lato(
              color: AppColors.vellum.withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.coins,
                  color: AppColors.brass, size: 28),
              const SizedBox(width: 12),
              Text(
                "$_coinBalance",
                style: GoogleFonts.cinzel(
                  color: AppColors.vellum,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Note: Each request in Guide & Relic features consumes 1 coin.",
            style: GoogleFonts.lato(
              color: AppColors.vellum.withOpacity(0.6),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(StopCustomPreviewCreator bundle) {
    // We trust the IDs are valid as per user request.
    // We try to get product details for price display, but if not available,
    // we still enable the button using the bundle info.
    final product = _productDetails[bundle.itemId];

    // Always enable button if not loading, regardless of product details availability
    // because the user guaranteed IDs are valid.
    final bool isAvailable = true;
    final bool isPromo = bundle.category == 'promo';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.shale.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPromo ? AppColors.wax : AppColors.leather.withOpacity(0.1),
          width: isPromo ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.leather.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.vellum,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.leather.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    FontAwesomeIcons.sackDollar,
                    color: isPromo ? AppColors.wax : AppColors.brass,
                    size: 32,
                  ),
                ),

                // Content
                Column(
                  children: [
                    Text(
                      "${bundle.coinAmount} Coins",
                      style: GoogleFonts.cinzel(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bundle.name, // e.g. Rue Package 1
                      style: GoogleFonts.lato(
                        color: AppColors.soot,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Price and Button
                Column(
                  children: [
                    Text(
                      product?.price ?? bundle.price, // Price inside card
                      style: GoogleFonts.lato(
                        color: AppColors.leather,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            isAvailable ? () => _handlePurchase(bundle) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isPromo ? AppColors.wax : AppColors.leather,
                          foregroundColor: AppColors.vellum,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          "PURCHASE",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isPromo)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.wax,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "SALE",
                  style: GoogleFonts.lato(
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
