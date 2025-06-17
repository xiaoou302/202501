import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../../shared/widgets/app_card.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Guide'),
        centerTitle: true,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildGuideSection(
          title: 'Love Diary',
          icon: Icons.favorite,
          color: Colors.red,
          steps: [
            'Click on the "Love Diary" icon in the bottom navigation bar to access the feature.',
            'Use the "Add Memory" button to record your special moments.',
            'Upload photos, add descriptions, and select dates to save your memories.',
            'View the timeline of all memories and click to see details.',
          ],
        ),
        const SizedBox(height: 20),
        _buildGuideSection(
          title: 'Luggage',
          icon: Icons.luggage,
          color: Colors.blue,
          steps: [
            'Click on the "Luggage" icon in the bottom navigation bar to access the feature.',
            'Use the "Add Plan" button to create a new travel plan.',
            'Fill in the destination, dates, and other details.',
            'Add items to your packing list for the trip.',
            'Check reminders before departure to ensure you don\'t forget any important items.',
          ],
        ),
        const SizedBox(height: 20),
        _buildGuideSection(
          title: 'Image Generator',
          icon: Icons.auto_fix_high,
          color: Colors.purple,
          steps: [
            'Click on the "Generator" icon in the bottom navigation bar to access the feature.',
            'Select the type of image you want to create.',
            'Enter detailed descriptions to help the AI understand your needs.',
            'Click the generate button and wait for the image creation to complete.',
            'Save or share the generated results you like.',
          ],
        ),
        const SizedBox(height: 20),
        _buildTipsSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppTheme.accentPurple, AppTheme.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPurple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.lightbulb,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'User Guide',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Learn how to make the most of all app features',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildGuideSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> steps,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            steps.length,
            (index) => _buildStepItem(
              stepNumber: index + 1,
              description: steps[index],
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tips_and_updates,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tips & Tricks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: Icons.photo_library,
            color: Colors.green,
            title: 'Batch Upload Photos',
            description:
                'When adding memories, you can select multiple photos at once to save time.',
          ),
          _buildTipItem(
            icon: Icons.notifications_active,
            color: Colors.orange,
            title: 'Enable Notifications',
            description:
                'Turn on notifications in settings to never miss important anniversaries and travel reminders.',
          ),
          _buildTipItem(
            icon: Icons.backup,
            color: Colors.blue,
            title: 'Regular Backups',
            description:
                'To ensure your precious memories are safe, we recommend regular data backups in settings.',
          ),
          _buildTipItem(
            icon: Icons.share,
            color: Colors.purple,
            title: 'Share Your Memories',
            description:
                'Use the share feature to share your beautiful memories with friends and family or save them to other platforms.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
