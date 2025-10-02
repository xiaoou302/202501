import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Screen for Help Center
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<FAQItem> _allFAQs = [
    FAQItem(
      question: 'How do I play Glyphion?',
      answer:
          'Glyphion is a puzzle game where you need to tap arrows in the correct sequence. Each arrow can only be tapped when its path is clear. The goal is to clear all arrows from the board.',
      category: 'Gameplay',
    ),
    FAQItem(
      question: 'What do the different arrow colors mean?',
      answer:
          'The different colors are purely aesthetic and do not affect gameplay. They help you distinguish between different arrows on the board.',
      category: 'Gameplay',
    ),
    FAQItem(
      question: 'How do I unlock new levels?',
      answer:
          'New levels are unlocked automatically as you complete the current levels. Complete a level to unlock the next one in sequence.',
      category: 'Levels',
    ),
    FAQItem(
      question: 'I\'m stuck on a level. What should I do?',
      answer:
          'Try to think about the sequence carefully. Remember that an arrow can only be tapped when its path is clear. Sometimes you need to remove other arrows first to clear a path. If you\'re really stuck, you can restart the level or use a hint.',
      category: 'Gameplay',
    ),
    FAQItem(
      question: 'How do I earn achievements?',
      answer:
          'Achievements are earned by completing specific challenges in the game, such as completing a certain number of levels, solving levels without mistakes, or achieving perfect solutions.',
      category: 'Achievements',
    ),
    FAQItem(
      question: 'How do I change game settings?',
      answer:
          'You can access game settings from the main menu. Tap on the Settings icon and adjust sound, music, and haptic feedback according to your preferences.',
      category: 'Settings',
    ),
    FAQItem(
      question: 'The game is crashing. What should I do?',
      answer:
          'First, try restarting the app. If the problem persists, make sure your device has enough storage space and that you\'re running the latest version of the app. If issues continue, please contact our support team through the Feedback section.',
      category: 'Technical',
    ),
    FAQItem(
      question: 'How do I report a bug?',
      answer:
          'You can report bugs through the Feedback section in the Settings menu. Please provide as much detail as possible about the issue you\'re experiencing to help us fix it quickly.',
      category: 'Technical',
    ),
  ];

  List<FAQItem> _filteredFAQs = [];
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Gameplay',
    'Levels',
    'Achievements',
    'Settings',
    'Technical',
  ];

  @override
  void initState() {
    super.initState();
    _filteredFAQs = _allFAQs;
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFAQs);
    _searchController.dispose();
    super.dispose();
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty && _selectedCategory == 'All') {
        _filteredFAQs = _allFAQs;
      } else {
        _filteredFAQs = _allFAQs.where((faq) {
          final matchesQuery =
              query.isEmpty ||
              faq.question.toLowerCase().contains(query) ||
              faq.answer.toLowerCase().contains(query);

          final matchesCategory =
              _selectedCategory == 'All' || faq.category == _selectedCategory;

          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterFAQs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside of text fields
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background, Color(0xFFEAE5E1)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => Navigator.pop(context),
                        color: AppColors.textGraphite,
                      ),
                      const Expanded(
                        child: Text(
                          'Help Center',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGraphite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the header
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for help',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.disabledGray,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Category filters
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return GestureDetector(
                        onTap: () => _selectCategory(category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentCoral
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentCoral
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textGraphite,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // FAQ list
                Expanded(
                  child: _filteredFAQs.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredFAQs.length,
                          itemBuilder: (context, index) {
                            return _buildFAQItem(_filteredFAQs[index]);
                          },
                        ),
                ),

                // Contact support button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.contactSupport,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.arrowBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.support_agent),
                      label: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 16,
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.disabledGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.disabledGray.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search term or category',
            style: TextStyle(fontSize: 14, color: AppColors.disabledGray),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textGraphite,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: AppColors.accentCoral,
        collapsedIconColor: AppColors.textGraphite,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            faq.answer,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textGraphite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(faq.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  faq.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getCategoryColor(faq.category),
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Mark as helpful
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you for your feedback!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
                label: const Text('Helpful'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.disabledGray,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Gameplay':
        return AppColors.arrowGreen;
      case 'Levels':
        return AppColors.arrowBlue;
      case 'Achievements':
        return AppColors.accentCoral;
      case 'Settings':
        return AppColors.arrowPink;
      case 'Technical':
        return AppColors.arrowTerracotta;
      default:
        return AppColors.textGraphite;
    }
  }
}

/// Model class for FAQ items
class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
