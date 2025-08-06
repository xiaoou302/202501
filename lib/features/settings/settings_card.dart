import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/settings_item.dart';
import 'screens/faq_screen.dart';
import 'screens/tutorial_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/version_history_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/about_screen.dart';

/// Reusable card for settings items
class SettingsCard extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsCard({Key? key, required this.title, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () => _onItemTap(context, item),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: item.iconColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item.icon, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(item.title, style: AppStyles.bodyText),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.white.withOpacity(0.1),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onItemTap(BuildContext context, SettingsItem item) {
    // 根据路由导航到对应界面
    switch (item.route) {
      case '/faq':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FAQScreen()),
        );
        break;
      case '/tutorial':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TutorialScreen()),
        );
        break;
      case '/terms':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsScreen()),
        );
        break;
      case '/privacy':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrivacyScreen()),
        );
        break;
      case '/version-history':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VersionHistoryScreen()),
        );
        break;
      case '/feedback':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FeedbackScreen()),
        );
        break;
      case '/about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
        break;
      default:
        // 如果没有匹配的路由，显示提示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('功能开发中: ${item.title}')),
        );
    }
  }
}