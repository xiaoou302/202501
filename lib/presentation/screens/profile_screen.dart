import 'package:flutter/material.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/data/datasources/storage_service.dart';
import 'package:soli/data/models/user_model.dart';
import 'package:soli/presentation/screens/about_screen.dart';
import 'package:soli/presentation/screens/feedback_screen.dart';
import 'package:soli/presentation/screens/help_screen.dart';
import 'package:soli/presentation/screens/customer_service_screen.dart';
import 'package:soli/presentation/screens/privacy_screen.dart';
import 'package:soli/presentation/screens/terms_screen.dart';
import 'package:soli/solweaveIAP/SetAdvancedCacheAdapter.dart';

/// Profile screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _storageService.getUser();

      if (!mounted) return;

      setState(() {
        _user = user;
      });
    } catch (e) {
      // Handle error
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
      backgroundColor: AppTheme.deepSpace,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.champagne),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Animations.fadeSlideIn(child: _buildHeader()),
                    const SizedBox(height: 24),

                    // Profile options
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // App Information Card
                            Animations.fadeSlideIn(
                              delay: 100,
                              child: _buildCardSection('App Information', [
                                _buildListItem(
                                  'Love Store',
                                  Icons.store_outlined,
                                  AppTheme.coral,
                                  () =>
                                      _navigateToScreen(const PrepareCurrentTaxonomyReference()),
                                ),
                                _buildListItem(
                                  'About Soli',
                                  Icons.info_outline,
                                  Colors.blue,
                                  () => _navigateToScreen(const AboutScreen()),
                                ),
                                _buildListItem(
                                  'Help',
                                  Icons.help_outline,
                                  Colors.purple,
                                  () => _navigateToScreen(const HelpScreen()),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 16),

                            // Support Card
                            Animations.fadeSlideIn(
                              delay: 200,
                              child: _buildCardSection('Support', [
                                _buildListItem(
                                  'Feedback',
                                  Icons.comment_outlined,
                                  Colors.orange,
                                  () =>
                                      _navigateToScreen(const FeedbackScreen()),
                                ),
                                _buildListItem(
                                  'Customer Service',
                                  Icons.headset_mic_outlined,
                                  Colors.green,
                                  () => _navigateToScreen(
                                    CustomerServiceScreen(),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(height: 16),

                            // Legal Card
                            Animations.fadeSlideIn(
                              delay: 300,
                              child: _buildCardSection('Legal', [
                                _buildListItem(
                                  'Privacy & Security',
                                  Icons.shield_outlined,
                                  Colors.red,
                                  () =>
                                      _navigateToScreen(const PrivacyScreen()),
                                ),
                                _buildListItem(
                                  'Terms of Service',
                                  Icons.description_outlined,
                                  Colors.amber,
                                  () => _navigateToScreen(const TermsScreen()),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Build header section
  Widget _buildHeader() {
    return Text(
      AppConstants.titleProfile,
      style: const TextStyle(
        color: AppTheme.moonlight,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Build card section with title and items
  Widget _buildCardSection(String title, List<Widget> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.champagne,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(color: Color(0xFF2A2A30), height: 1),
          ...items,
        ],
      ),
    );
  }

  // Build list item with icon and navigation
  Widget _buildListItem(
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // Navigate to screen
  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
