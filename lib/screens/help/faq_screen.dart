import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

/// Frequently Asked Questions screen
class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // List of FAQ items with questions and answers
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'What is Virelia?',
      'answer':
          'Virelia is an intelligent travel planning assistant that helps you organize your trips, create packing lists, and stay on top of your travel plans with AI-powered suggestions.',
    },
    {
      'question': 'How do I create a new trip?',
      'answer':
          'To create a new trip, go to the Smart Luggage tab and tap on the "+" button. Enter your destination, duration, and number of travelers, then tap "Generate Packing List".',
    },
    {
      'question': 'Can I customize my packing list?',
      'answer':
          'Yes! After generating a packing list, you can add, remove, or modify items. Tap on an item to mark it as packed, or use the search and filter options to find specific items.',
    },
    {
      'question': 'How does the AI assistant work?',
      'answer':
          'Our AI assistant analyzes your travel details (destination, duration, season) and creates personalized packing lists and travel tips. It also considers weather forecasts and destination-specific requirements.',
    },
    {
      'question': 'Is my data private?',
      'answer':
          'Yes, your privacy is important to us. All your travel plans and personal information are stored locally on your device. We don\'t collect or share your data with third parties.',
    },
    {
      'question': 'Can I use Virelia offline?',
      'answer':
          'Most features work offline, including viewing and managing your existing trips and packing lists. However, creating new trips with AI suggestions requires an internet connection.',
    },
    {
      'question': 'How do I delete a trip?',
      'answer':
          'Open the trip you want to delete, tap the three dots menu in the top right corner, and select "Delete Trip". Confirm your choice in the dialog that appears.',
    },
    {
      'question': 'Can I share my packing list with others?',
      'answer':
          'Currently, direct sharing is not available, but we\'re working on adding this feature in a future update. Stay tuned for more collaboration features!',
    },
  ];

  // Controller for search field
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside input field
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryBackground,
          elevation: 0,
          title: const Text(
            'Frequently Asked Questions',
            style: TextStyle(color: AppTheme.primaryText),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search bar with input restrictions
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  maxLength: 50, // Reasonable limit for search queries
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization:
                      TextCapitalization.words, // Capitalize each word
                  decoration: InputDecoration(
                    hintText: 'Search FAQs',
                    hintStyle: const TextStyle(color: AppTheme.secondaryText),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.secondaryText,
                    ),
                    // Add clear button when text is entered
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppTheme.secondaryText,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              // Trigger rebuild to hide clear button
                              setState(() {});
                              // Hide keyboard
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppTheme.surfaceBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    // Hide character counter
                    counterText: '',
                  ),
                  style: const TextStyle(color: AppTheme.primaryText),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    // Trigger rebuild to show/hide clear button
                    setState(() {});
                    // Implement search functionality here
                  },
                  onSubmitted: (value) {
                    // Implement search functionality here
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              // FAQ list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _faqItems.length,
                  itemBuilder: (context, index) {
                    return _buildFAQItem(_faqItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build an expandable FAQ item
  Widget _buildFAQItem(Map<String, String> item) {
    return Card(
      color: AppTheme.surfaceBackground,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: Text(
          item['question']!,
          style: const TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        iconColor: AppTheme.brandBlue,
        collapsedIconColor: AppTheme.secondaryText,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              item['answer']!,
              style: const TextStyle(color: AppTheme.primaryText, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
