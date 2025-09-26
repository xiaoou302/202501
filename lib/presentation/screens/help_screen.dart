import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// Help screen with FAQs and guides
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // Track which guide is currently selected
  int? _selectedGuideIndex;

  // General FAQs
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I create a new memory?',
      'answer':
          'To create a new memory, go to the Memory Gallery tab and tap the "+" button at the bottom of the screen. Select images from your gallery or take new photos, add a title, description, and tags, then save your memory.',
      'isExpanded': false,
    },
    {
      'question': 'Can I edit my memories after creating them?',
      'answer':
          'Yes, you can edit your memories. Open the memory you want to edit, tap the three dots menu in the top right corner, and select "Edit". Make your changes and save.',
      'isExpanded': false,
    },
    {
      'question': 'How do I create a proposal plan?',
      'answer':
          'Navigate to the Planner tab and tap "Create New Plan". Fill in the details for your proposal including date, location, and activities. You can also use our AI assistant for personalized suggestions.',
      'isExpanded': false,
    },
    {
      'question': 'How can I share memories with my partner?',
      'answer':
          'Your memories are automatically shared with your connected partner. To connect with your partner, go to Settings > Partner Connection and follow the instructions to send an invitation.',
      'isExpanded': false,
    },
    {
      'question': 'Is my data secure and private?',
      'answer':
          'Yes, we take your privacy seriously. All your data is encrypted and stored securely. Your memories are only visible to you and your connected partner unless you explicitly share them in the community section.',
      'isExpanded': false,
    },
    {
      'question': 'How do I reset my password?',
      'answer':
          'Go to the login screen and tap "Forgot Password". Enter your email address, and we\'ll send you instructions to reset your password.',
      'isExpanded': false,
    },
  ];

  // Guide items with their associated FAQs
  final List<Map<String, dynamic>> _guideItems = [
    {
      'title': 'Getting Started',
      'icon': Icons.play_circle_outline,
      'color': Colors.green,
      'faqs': [
        {
          'question': 'How do I create an account?',
          'answer':
              'To create an account, download our app from the App Store or Google Play Store, open it, and tap "Sign Up". Enter your email, create a password, and follow the verification steps to complete your registration.',
          'isExpanded': false,
        },
        {
          'question': 'What are the system requirements?',
          'answer':
              'Our app requires iOS 13+ or Android 8.0+ to run smoothly. For the best experience, we recommend using a device manufactured in the last 3-4 years with at least 2GB of RAM.',
          'isExpanded': false,
        },
        {
          'question': 'How do I navigate the app?',
          'answer':
              'The app has a bottom navigation bar with main sections: Home, Memory Gallery, Planner, Community, and Profile. Tap on these icons to switch between different features of the app.',
          'isExpanded': false,
        },
      ],
    },
    {
      'title': 'Creating Memories',
      'icon': Icons.photo_library_outlined,
      'color': Colors.blue,
      'faqs': [
        {
          'question': 'How do I add photos to my memory?',
          'answer':
              'When creating a new memory, tap the "Add Photos" button to select images from your gallery or take new photos. You can select multiple photos at once and rearrange their order by dragging.',
          'isExpanded': false,
        },
        {
          'question': 'Can I add location information to memories?',
          'answer':
              'Yes, when creating or editing a memory, tap the "Add Location" option to search for and tag the location where the memory took place. This helps organize memories by location for easier browsing.',
          'isExpanded': false,
        },
        {
          'question': 'How do I create memory collections?',
          'answer':
              'To create a collection, go to the Memory Gallery and tap the "Collections" tab. Then tap the "+" button to create a new collection. You can then add existing memories to this collection or create new ones directly.',
          'isExpanded': false,
        },
      ],
    },
    {
      'title': 'Planning Proposals',
      'icon': Icons.favorite_border,
      'color': Colors.red,
      'faqs': [
        {
          'question': 'How far in advance should I plan my proposal?',
          'answer':
              'We recommend starting to plan at least 2-3 months before your intended proposal date. This gives you enough time to secure venues, arrange special elements, and handle any unexpected changes.',
          'isExpanded': false,
        },
        {
          'question': 'Can I get custom proposal ideas?',
          'answer':
              'Yes! Our AI assistant can generate personalized proposal ideas based on your partner\'s interests, your relationship history, and your preferences. Just tap "Get Custom Ideas" in the Planner section.',
          'isExpanded': false,
        },
        {
          'question': 'How do I share my proposal plan with vendors?',
          'answer':
              'In your proposal plan, tap the "Share" button and select "Vendor View". This creates a special link that shows relevant details to your vendors without revealing personal notes or budget information.',
          'isExpanded': false,
        },
      ],
    },
    {
      'title': 'Using the Community',
      'icon': Icons.people_outline,
      'color': Colors.orange,
      'faqs': [
        {
          'question': 'How do I join community discussions?',
          'answer':
              'Navigate to the Community tab and browse through available discussion topics. Tap on any topic to view the conversation, and use the comment field at the bottom to join in.',
          'isExpanded': false,
        },
        {
          'question': 'Can I create my own community posts?',
          'answer':
              'Yes, in the Community tab, tap the "+" button to create a new post. You can add text, photos, and tags to make your post more engaging and help others find it.',
          'isExpanded': false,
        },
        {
          'question': 'How do I control what I share with the community?',
          'answer':
              'When creating a memory or post, you\'ll see privacy options that let you choose whether it\'s visible to just you and your partner, friends only, or the wider community. You can change these settings at any time.',
          'isExpanded': false,
        },
      ],
    },
    {
      'title': 'Account Settings',
      'icon': Icons.settings_outlined,
      'color': Colors.purple,
      'faqs': [
        {
          'question': 'How do I change my profile information?',
          'answer':
              'Go to the Profile tab and tap the "Edit Profile" button. From there, you can update your name, profile picture, bio, and other personal information.',
          'isExpanded': false,
        },
        {
          'question': 'How do I manage notification settings?',
          'answer':
              'In the Profile tab, tap "Settings" and then "Notifications". You can toggle different types of notifications on or off according to your preferences.',
          'isExpanded': false,
        },
        {
          'question': 'How do I delete my account?',
          'answer':
              'Go to Profile > Settings > Account > Delete Account. Please note that this action is permanent and will delete all your data including memories, plans, and community contributions.',
          'isExpanded': false,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text(
          'Help',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.champagne),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar

            // User guides section
            Animations.fadeSlideIn(
              delay: 100,
              child: const Text(
                'User Guides',
                style: TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Guide items
            Animations.fadeSlideIn(
              delay: 150,
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _guideItems.length,
                  itemBuilder: (context, index) {
                    final guide = _guideItems[index];
                    return _buildGuideItem(
                      guide['title'],
                      guide['icon'],
                      guide['color'],
                      index,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            // FAQs section
            Animations.fadeSlideIn(
              delay: 200,
              child: const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: AppTheme.moonlight,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // FAQ items - show guide specific FAQs if a guide is selected, otherwise show general FAQs
            Animations.fadeSlideIn(
              delay: 250,
              child: _selectedGuideIndex != null
                  ? _buildGuideFaqList(_selectedGuideIndex!)
                  : _buildFaqList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Build guide item
  Widget _buildGuideItem(String title, IconData icon, Color color, int index) {
    bool isSelected = _selectedGuideIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection - if already selected, deselect it
          _selectedGuideIndex = _selectedGuideIndex == index ? null : index;
        });
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : AppTheme.silverstone,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : AppTheme.moonlight,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build guide-specific FAQ list
  Widget _buildGuideFaqList(int guideIndex) {
    final guideFaqs =
        _guideItems[guideIndex]['faqs'] as List<Map<String, dynamic>>;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: guideFaqs.length,
      itemBuilder: (context, index) {
        final faq = guideFaqs[index];
        return _buildFaqItem(
          question: faq['question'],
          answer: faq['answer'],
        );
      },
    );
  }

  // Build general FAQ list
  Widget _buildFaqList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _faqItems.length,
      itemBuilder: (context, index) {
        final faq = _faqItems[index];
        return _buildFaqItem(
          question: faq['question'],
          answer: faq['answer'],
        );
      },
    );
  }

  // Build FAQ item
  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: AppTheme.champagne,
        collapsedIconColor: AppTheme.moonlight,
        title: Text(
          question,
          style: const TextStyle(
            color: AppTheme.moonlight,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                  color: AppTheme.moonlight.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
