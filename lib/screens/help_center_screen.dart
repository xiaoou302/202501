import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';

  // 搜索框输入限制
  static const int _maxSearchLength = 50;

  final List<FAQCategory> _categories = [
    FAQCategory(
      title: 'Getting Started',
      icon: FontAwesomeIcons.rocket,
      color: AppTheme.accentBlue,
      faqs: [
        FAQ(
          question: 'How do I create my first journal entry?',
          answer:
              'To create your first journal entry:\n\n'
              '1. Go to the Journal tab\n'
              '2. Tap the + button\n'
              '3. Choose a color theme\n'
              '4. Write your thoughts\n'
              '5. Tap Save',
        ),
        FAQ(
          question: 'How do breathing exercises work?',
          answer:
              'Breathing exercises guide you through timed breathing patterns. '
              'Each mode has different timing for inhaling, holding, and exhaling. '
              'Follow the on-screen animations and instructions.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Account & Privacy',
      icon: FontAwesomeIcons.shield,
      color: AppTheme.accentGreen,
      faqs: [
        FAQ(
          question: 'Is my data private?',
          answer:
              'Yes, your journal entries are stored locally on your device. '
              'We don\'t collect or store any personal data. '
              'Entries are only shared when you explicitly generate a QR code.',
        ),
        FAQ(
          question: 'How can I delete my data?',
          answer:
              'You can delete individual journal entries by swiping left. '
              'To clear all data, go to Settings > Privacy & Security > Clear Data.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Sharing & Export',
      icon: FontAwesomeIcons.share,
      color: AppTheme.accentPurple,
      faqs: [
        FAQ(
          question: 'How do I share my journal entries?',
          answer:
              'To share a journal entry:\n\n'
              '1. Select the entry you want to share\n'
              '2. Tap the Share button\n'
              '3. Choose to generate a QR code\n'
              '4. Save or share the QR code',
        ),
        FAQ(
          question: 'Can I export my journal entries?',
          answer:
              'Currently, you can share individual entries via QR codes. '
              'Full export functionality is coming in a future update.',
        ),
      ],
    ),
    FAQCategory(
      title: 'Troubleshooting',
      icon: FontAwesomeIcons.wrench,
      color: AppTheme.accentPink,
      faqs: [
        FAQ(
          question: 'The app is running slowly',
          answer:
              'Try these steps:\n\n'
              '1. Restart the app\n'
              '2. Clear app cache\n'
              '3. Ensure you have enough storage space\n'
              '4. Update to the latest version',
        ),
        FAQ(
          question: 'QR code generation fails',
          answer:
              'QR code generation requires:\n\n'
              '1. Active internet connection\n'
              '2. Sufficient storage space\n'
              '3. Latest app version\n\n'
              'Try again with a stable connection.',
        ),
      ],
    ),
  ];

  List<FAQCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories
        .map((category) {
          final filteredFaqs = category.faqs.where((faq) {
            return faq.question.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
          return FAQCategory(
            title: category.title,
            icon: category.icon,
            color: category.color,
            faqs: filteredFaqs,
          );
        })
        .where((category) => category.faqs.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Help Center'),
          backgroundColor: AppTheme.surfaceColor,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.darkGradient,
                  borderRadius: AppTheme.borderRadius,
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: TextStyle(color: AppTheme.textColor),
                  maxLength: _maxSearchLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'^\s')), // 禁止以空格开头
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9\s\-_]'),
                    ), // 只允许字母、数字、空格、连字符和下划线
                  ],
                  decoration: InputDecoration(
                    hintText: 'Search for help...',
                    hintStyle: TextStyle(
                      color: AppTheme.textColor.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textColor.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    counterText: '', // 隐藏字符计数器
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppTheme.textColor.withOpacity(0.7),
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: _filteredCategories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchQuery.isEmpty
                                ? FontAwesomeIcons.search
                                : FontAwesomeIcons.searchMinus,
                            size: 48,
                            color: AppTheme.textColor.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Start typing to search'
                                : 'No results found',
                            style: TextStyle(
                              color: AppTheme.textColor.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Text(
                              'Try different keywords',
                              style: TextStyle(
                                color: AppTheme.textColor.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = _filteredCategories[index];
                        return _buildCategorySection(category);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(FAQCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: category.color, size: 20),
            ),
            SizedBox(width: 12),
            Text(category.title, style: AppTheme.subheadingStyle),
          ],
        ),
        SizedBox(height: 16),
        ...category.faqs
            .map((faq) => _buildFAQItem(faq, category.color))
            .toList(),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFAQItem(FAQ faq, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.darkGradient,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faq.question,
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconColor: color,
          collapsedIconColor: color.withOpacity(0.7),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq.answer,
                style: TextStyle(
                  color: AppTheme.textColor.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<FAQ> faqs;

  FAQCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.faqs,
  });
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
