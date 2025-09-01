import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/common/keyboard_dismissible.dart';

/// Help Center Screen
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Selected category
  String _selectedCategory = 'All';

  // List of FAQ categories
  final List<String> _categories = [
    'All',
    'Gameplay',
    'Account',
    'Technical',
    'Billing',
  ];

  // List of FAQs
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I unlock new levels?',
      'answer':
          'Complete the current level with a passing score to unlock the next level. '
          'Your progress is automatically saved.',
      'category': 'Gameplay',
    },
    {
      'question': 'Why can\'t I see my achievements?',
      'answer':
          'Achievements are unlocked as you play and complete specific challenges. '
          'Check the Achievements screen to see your progress and which ones you\'ve unlocked.',
      'category': 'Gameplay',
    },
    {
      'question': 'How do I reset my game progress?',
      'answer':
          'Go to Settings > Account > Reset Progress. Note that this action cannot be undone.',
      'category': 'Account',
    },
    {
      'question': 'The game is lagging on my device',
      'answer':
          'Try closing other apps running in the background. If the issue persists, '
          'restart your device or check if your device meets the minimum requirements.',
      'category': 'Technical',
    },
    {
      'question': 'How do I report a bug?',
      'answer':
          'Go to Settings > Customer Support and use the bug report form. '
          'Please provide as much detail as possible about the issue.',
      'category': 'Technical',
    },
    {
      'question': 'Is there a subscription option?',
      'answer':
          'Currently, Hyquinoxa is completely free to play with no subscription required.',
      'category': 'Billing',
    },
    {
      'question': 'How do the difficulty levels work?',
      'answer':
          'Each game has multiple difficulty levels that increase the challenge. '
          'Higher difficulties may have more items to remember, faster gameplay, or additional obstacles.',
      'category': 'Gameplay',
    },
    {
      'question': 'Can I play offline?',
      'answer':
          'Yes, all games in Hyquinoxa can be played without an internet connection.',
      'category': 'Technical',
    },
  ];

  // Filtered FAQs based on search and category
  List<Map<String, dynamic>> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _faqs;

    _searchController.addListener(_filterFaqs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filter FAQs based on search text and selected category
  void _filterFaqs() {
    final String searchText = _searchController.text.toLowerCase();

    setState(() {
      _filteredFaqs = _faqs.where((faq) {
        // Filter by category
        if (_selectedCategory != 'All' &&
            faq['category'] != _selectedCategory) {
          return false;
        }

        // Filter by search text
        if (searchText.isNotEmpty) {
          return faq['question'].toLowerCase().contains(searchText) ||
              faq['answer'].toLowerCase().contains(searchText);
        }

        return true;
      }).toList();
    });
  }

  /// Change the selected category
  void _changeCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissible(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Help Center'),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for help...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.primary,
                maxLength: 50,
                buildCounter:
                    (
                      _, {
                      required currentLength,
                      required isFocused,
                      maxLength,
                    }) => null,
              ),
            ),

            // Category tabs
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () => _changeCategory(category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[400],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // FAQ list
            Expanded(
              child: _filteredFaqs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try different search terms or categories',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final faq = _filteredFaqs[index];
                        return _buildFaqItem(faq);
                      },
                    ),
            ),

            // Contact support button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/customer_support');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Contact Support',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build an FAQ item with expandable answer
  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return NeumorphicCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq['answer'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(faq['category']).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  faq['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _getCategoryColor(faq['category']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get color for category tag
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Gameplay':
        return Colors.green;
      case 'Account':
        return Colors.blue;
      case 'Technical':
        return Colors.orange;
      case 'Billing':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }
}
