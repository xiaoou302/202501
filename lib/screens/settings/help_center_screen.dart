import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // FAQ categories
  final List<String> _categories = [
    'General',
    'Caffeine Tracker',
    'Coupon Manager',
    'Color Generator',
    'Account',
  ];

  // Selected category
  String _selectedCategory = 'General';

  // FAQ items
  final Map<String, List<FAQItem>> _faqItems = {
    'General': [
      FAQItem(
        question: 'What is Luxanvoryx?',
        answer:
            'Luxanvoryx is a multi-functional app that includes caffeine tracking, coupon management, and color generation tools. It\'s designed to help you manage different aspects of your daily life in one sleek interface.',
      ),
      FAQItem(
        question: 'How do I navigate between different features?',
        answer:
            'You can easily switch between different features using the bottom navigation bar. The app has four main sections: Caffeine Tracker, Coupon Manager, Color Generator, and Settings.',
      ),
      FAQItem(
        question: 'Is my data stored securely?',
        answer:
            'Yes, all your data is stored securely on your device. We do not collect or share your personal information with third parties. For more information, please refer to our Privacy Policy.',
      ),
    ],
    'Caffeine Tracker': [
      FAQItem(
        question: 'How does the caffeine tracker calculate metabolism time?',
        answer:
            'The caffeine tracker uses a half-life model to estimate how caffeine is metabolized in your body. The average half-life of caffeine is about 5-6 hours, meaning half of the caffeine is eliminated from your body in that time period.',
      ),
      FAQItem(
        question: 'Can I add custom drinks?',
        answer:
            'Yes, you can add custom drinks with specific caffeine content. Simply tap the + button in the caffeine tracker screen and select "Custom" from the drink options.',
      ),
      FAQItem(
        question: 'What is the recommended daily caffeine intake?',
        answer:
            'According to health experts, the recommended maximum daily caffeine intake is 400mg for most healthy adults. The app will warn you if you exceed this limit.',
      ),
    ],
    'Coupon Manager': [
      FAQItem(
        question: 'How do I add a new coupon?',
        answer:
            'To add a new coupon, tap the + button in the coupon manager screen. You can manually enter coupon details or scan a barcode if available.',
      ),
      FAQItem(
        question: 'Can I set expiration reminders?',
        answer:
            'Yes, when adding or editing a coupon, you can enable expiration reminders. The app will notify you before your coupons expire.',
      ),
      FAQItem(
        question: 'How do I organize my coupons?',
        answer:
            'Coupons are automatically organized by categories like Dining, Shopping, etc. You can also filter them by expiration date or search for specific coupons.',
      ),
    ],
    'Color Generator': [
      FAQItem(
        question: 'How do I save a color scheme?',
        answer:
            'To save a color scheme, tap the save icon in the top right corner of the color generator screen. You\'ll be prompted to enter a name for your scheme.',
      ),
      FAQItem(
        question: 'What are the different color harmony options?',
        answer:
            'The app offers several color harmony options including Analogous, Monochromatic, Complementary, Triadic, Tetradic, and Split Complementary. Each creates a different relationship between colors on the color wheel.',
      ),
      FAQItem(
        question: 'How do I export colors to use in other apps?',
        answer:
            'Tap the export icon to copy color values in different formats (HEX, RGB, HSL). You can then paste these values into other design applications.',
      ),
    ],
    'Account': [
      FAQItem(
        question: 'How do I update my profile?',
        answer:
            'Currently, profile management features are under development. In future updates, you\'ll be able to customize your profile from the Settings screen.',
      ),
      FAQItem(
        question: 'Is there a premium version of the app?',
        answer:
            'We\'re currently developing premium features that will be available through a subscription. Stay tuned for updates!',
      ),
      FAQItem(
        question: 'How do I delete my account?',
        answer:
            'Account deletion options will be available in future updates. For now, please contact our support team if you need assistance with account management.',
      ),
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Search bar
                  _buildSearchBar(),
                  const SizedBox(height: 24),

                  // Category tabs
                  _buildCategoryTabs(),
                  const SizedBox(height: 20),

                  // FAQ list
                  Expanded(
                    child: _buildFAQList(),
                  ),

                  // Contact support button
                  _buildContactSupportButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build header with back button
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        const Text(
          "Help Center",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Build search bar
  Widget _buildSearchBar() {
    return Container(
      decoration: UIHelper.glassDecoration(
        radius: 50,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search for help",
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textColor.withOpacity(0.7),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: AppColors.textColor.withOpacity(0.7),
            ),
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // Build category tabs
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.electricBlue.withOpacity(0.7),
                          AppColors.hologramPurple.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.deepSpace.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.hologramPurple
                      : AppColors.hologramPurple.withOpacity(0.2),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppColors.textColor.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Build FAQ list
  Widget _buildFAQList() {
    // Get FAQs for selected category
    final faqs = _faqItems[_selectedCategory] ?? [];

    // Filter by search query if any
    final searchQuery = _searchController.text.toLowerCase();
    final filteredFaqs = searchQuery.isEmpty
        ? faqs
        : faqs.where((faq) {
            return faq.question.toLowerCase().contains(searchQuery) ||
                faq.answer.toLowerCase().contains(searchQuery);
          }).toList();

    if (filteredFaqs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 48,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No results found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredFaqs.length,
      itemBuilder: (context, index) {
        final faq = filteredFaqs[index];
        return _buildFAQItem(faq);
      },
    );
  }

  // Build FAQ item
  Widget _buildFAQItem(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: UIHelper.glassDecoration(
        radius: 16,
        opacity: 0.1,
        borderColor: AppColors.hologramPurple.withOpacity(0.2),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        iconColor: AppColors.electricBlue,
        collapsedIconColor: AppColors.textColor,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            faq.answer,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // Build contact support button
  Widget _buildContactSupportButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to contact us screen
          Navigator.pop(context);
          Navigator.pushNamed(context, '/settings/contact_us');
        },
        icon: const Icon(FontAwesomeIcons.headset),
        label: const Text("Contact Support"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.electricBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// FAQ item model
class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
