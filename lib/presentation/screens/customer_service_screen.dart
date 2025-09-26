import 'package:flutter/material.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';

/// Customer Service screen - Shows contact information and support resources
class CustomerServiceScreen extends StatelessWidget {
  CustomerServiceScreen({super.key});

  // Contact information data
  final List<Map<String, dynamic>> _contactMethods = [
    {
      'title': 'Customer Hotline',
      'description': 'Available: Mon-Sun 9:00-22:00 EST',
      'value': '+1 (800) 123-4567',
      'icon': Icons.phone_outlined,
      'color': Colors.blue,
    },
    {
      'title': 'Email Support',
      'description': 'Response within 24 hours',
      'value': 'support@soliapp.com',
      'icon': Icons.email_outlined,
      'color': Colors.green,
    },
    {
      'title': 'WeChat Support',
      'description': 'Scan QR code to add our service',
      'value': 'SoliGlobal',
      'icon': Icons.wechat,
      'color': Colors.teal,
    },
    {
      'title': 'Support Ticket',
      'description': 'Get professional answers to your questions',
      'value': 'Submit a ticket',
      'icon': Icons.assignment_outlined,
      'color': Colors.orange,
    },
  ];

  // FAQ data
  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer':
          'You can click "Forgot Password" on the login page and follow the instructions. The system will send a reset link to your registered email address.',
    },
    {
      'question': 'How can I update my personal information?',
      'answer':
          'Go to "My Account" page, click "Edit Profile", and you can modify your personal information and save the changes.',
    },
    {
      'question': 'How do I view my order history?',
      'answer':
          'In the "My Orders" section of the app, you can view all historical orders and their status details.',
    },
    {
      'question': 'How do I cancel an order?',
      'answer':
          'Find the order you want to cancel in "My Orders" and click the "Cancel Order" button. Please note that orders in certain statuses cannot be cancelled.',
    },
  ];

  // Business hours data
  final List<Map<String, dynamic>> _businessHours = [
    {'day': 'Monday - Friday', 'hours': '9:00 - 22:00 EST'},
    {'day': 'Saturday - Sunday', 'hours': '10:00 - 20:00 EST'},
    {'day': 'Public Holidays', 'hours': '10:00 - 18:00 EST'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text(
          'Customer Service',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Animations.fadeSlideIn(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.silverstone,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.champagne.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: AppTheme.champagne,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'We\'re Here to Help',
                                  style: TextStyle(
                                    color: AppTheme.moonlight,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Choose any of the following ways to contact our support team',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Contact methods section
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                'Contact Methods',
                style: TextStyle(
                  color: AppTheme.champagne,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Animations.fadeSlideIn(
              delay: 100,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _contactMethods.length,
                itemBuilder: (context, index) {
                  final method = _contactMethods[index];
                  return _buildContactMethodCard(
                    title: method['title'],
                    description: method['description'],
                    value: method['value'],
                    icon: method['icon'],
                    color: method['color'],
                  );
                },
              ),
            ),

            // Business hours section
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                'Business Hours',
                style: TextStyle(
                  color: AppTheme.champagne,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Animations.fadeSlideIn(
              delay: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.silverstone,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: _businessHours.map((hours) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hours['day'],
                              style: const TextStyle(
                                color: AppTheme.moonlight,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              hours['hours'],
                              style: const TextStyle(
                                color: AppTheme.champagne,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // FAQ section
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 8),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: AppTheme.champagne,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Animations.fadeSlideIn(
              delay: 200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _faqItems.length,
                itemBuilder: (context, index) {
                  final faq = _faqItems[index];
                  return _buildFaqItem(
                    question: faq['question'],
                    answer: faq['answer'],
                  );
                },
              ),
            ),

            // Additional support info

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Build contact method card
  Widget _buildContactMethodCard({
    required String title,
    required String description,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.silverstone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.champagne,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
