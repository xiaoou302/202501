import 'package:flutter/material.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/settings_item.dart';
import 'settings_card.dart';

/// Settings screen with user settings and support options
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Get safe area insets to handle notch/Dynamic Island
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, topPadding + 16.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('设置', style: AppStyles.heading1),
            SizedBox(height: mediaQuery.size.height * 0.02), // 动态调整间距

            // Support Card
            SettingsCard(
              title: '支持',
              items: [
                SettingsItem(
                  title: '常见问题与解答',
                  icon: Icons.help,
                  route: '/faq',
                  iconColor: Colors.red.shade500,
                ),
                SettingsItem(
                  title: '新手引导',
                  icon: Icons.menu_book,
                  route: '/tutorial',
                  iconColor: Colors.amber.shade500,
                ),
              ],
            ),

            // Legal Card
            SettingsCard(
              title: '法律',
              items: [
                SettingsItem(
                  title: '用户协议',
                  icon: Icons.description,
                  route: '/terms',
                  iconColor: Colors.grey.shade500,
                ),
                SettingsItem(
                  title: '隐私说明',
                  icon: Icons.shield,
                  route: '/privacy',
                  iconColor: Colors.blue.shade500,
                ),
              ],
            ),

            // About Card
            SettingsCard(
              title: '关于',
              items: [
                SettingsItem(
                  title: '版本历史',
                  icon: Icons.history,
                  route: '/version-history',
                  iconColor: Colors.purple.shade500,
                ),
                SettingsItem(
                  title: '意见反馈',
                  icon: Icons.feedback,
                  route: '/feedback',
                  iconColor: Colors.green.shade500,
                ),
                SettingsItem(
                  title: '关于我们',
                  icon: Icons.info,
                  route: '/about',
                  iconColor: Colors.cyan.shade500,
                ),
              ],
            ),

            // Add dynamic bottom padding for the tab bar and safe area
            SizedBox(
              height: mediaQuery.padding.bottom + 80, // 考虑底部安全区域
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
