import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import 'gallery_screen.dart';
import 'relic_screen.dart';
import 'guide_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const GalleryScreen(),
    const RelicScreen(),
    const GuideScreen(),
    const SettingsScreen(),
  ];

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.vellum,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.leather, width: 2),
        ),
        title: Row(
          children: [
            const Icon(FontAwesomeIcons.circleInfo, color: AppColors.brass),
            const SizedBox(width: 12),
            Text(
              "About Rue",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Rue, your digital steampunk archive for restoring and preserving history.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              "FEATURES:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.leather),
            ),
            const SizedBox(height: 8),
            _buildInfoItem(
                "Gallery", "Browse the archive of discovered artifacts."),
            _buildInfoItem(
                "Relic", "Use AI to restore damaged vintage photos."),
            _buildInfoItem(
                "Guide", "Learn traditional restoration techniques."),
            _buildInfoItem(
                "Workshop", "Manage your restorer profile and settings."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE", style: TextStyle(color: AppColors.soot)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: AppColors.brass),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Global Noise Overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.transparenttextures.com/patterns/cream-paper.png'),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Column(
              children: [
                // Custom App Bar
                _buildAppBar(),
                // Main Content
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.vellum.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: AppColors.brass.withValues(alpha: 0.5),
            width: 2,
            style: BorderStyle
                .solid, // Double border simulation needed usually, but solid is fine for now
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.subTitle.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 2.0,
                      color: AppColors.leather,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.clock,
                      color: AppColors.brass, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          height: 1.0,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.leather.withValues(alpha: 0.2)),
            ),
            child: IconButton(
              icon: const Icon(FontAwesomeIcons.circleInfo, size: 18),
              color: AppColors.leather,
              onPressed: _showAppInfo,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.leatherGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, FontAwesomeIcons.compass, AppStrings.navGallery),
              _buildNavItem(1, FontAwesomeIcons.eye, AppStrings.navRelic),
              _buildNavItem(2, FontAwesomeIcons.scroll, AppStrings.navGuide),
              _buildNavItem(3, FontAwesomeIcons.gears, AppStrings.navWorkshop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.brass : Colors.transparent,
                width: 2,
              ),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF5D4037), Color(0xFF4A332C)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                        color: Colors.black38,
                        offset: Offset(3, 3),
                        blurRadius: 8,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? AppColors.brass
                  : AppColors.shale.withValues(alpha: 0.5),
              size: 20,
              shadows: isSelected
                  ? [const Shadow(color: AppColors.brass, blurRadius: 5)]
                  : [],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: isSelected
                      ? AppColors.brass
                      : AppColors.shale.withValues(alpha: 0.5),
                ),
          ),
        ],
      ),
    );
  }
}
