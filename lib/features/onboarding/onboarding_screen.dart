import 'package:flutter/material.dart';
import 'package:zenithsprint/app/app_routes.dart';
import 'package:zenithsprint/core/constants/app_colors.dart';
import 'package:zenithsprint/core/constants/app_values.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildPage(
                context,
                imageUrl:
                    'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                title: 'Turn Pressure into Power.',
                subtitle: 'Translate pressure into strength.',
              ),
              _buildPage(
                context,
                icon: Icons.show_chart_rounded,
                title: 'Train Like a Pro. See Your Growth.',
                subtitle: 'Train like an expert and witness your growth.',
              ),
            ],
          ),
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) => _buildDot(index, context)),
            ),
          ),
          Positioned(
            bottom: 40,
            left: AppValues.padding_large,
            right: AppValues.padding_large,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == 1) {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.goalSelection);
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(_currentPage == 1 ? 'Get Started' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color:
            _currentPage == index ? AppColors.accent : AppColors.neutralLight,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {String? imageUrl,
      IconData? icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_large),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppValues.radius_large),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
                  )
                : _buildPlaceholder(icon: icon),
          ),
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppValues.margin),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18, color: AppColors.neutralLight),
          ),
          const SizedBox(height: 150), // Leave space for buttons and indicators
        ],
      ),
    );
  }

  Widget _buildPlaceholder({IconData? icon}) {
    return Container(
      height: 280,
      width: double.infinity,
      color: Colors.white10,
      child: Icon(
        icon ?? Icons.image_not_supported,
        size: 100,
        color: AppColors.neutralLight,
      ),
    );
  }
}
