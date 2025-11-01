import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_app_bar.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Gameplay';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Dismiss keyboard
      FocusScope.of(context).unfocus();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.voidCharcoal,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.largeRadius,
            side: BorderSide(
              color: AppColors.alchemicalGold.withOpacity(0.5),
              width: 2,
            ),
          ),
          title: const Text(
            'Report Submitted',
            style: TextStyle(color: AppColors.alchemicalGold),
          ),
          content: const Text(
            'Thank you for your feedback! We\'ll review your report and work on improvements.',
            style: TextStyle(color: AppColors.alabasterWhite),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.alchemicalGold),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.voidCharcoal,
        appBar: CustomAppBar(
          title: 'Bug Report',
          onHomePressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl),
                _buildCategorySelector(),
                const SizedBox(height: AppSpacing.lg),
                _buildTitleField(),
                const SizedBox(height: AppSpacing.lg),
                _buildDescriptionField(),
                const SizedBox(height: AppSpacing.xl),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.rubedoRed.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: AppColors.rubedoRed.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bug_report,
            size: 40,
            color: AppColors.rubedoRed,
            shadows: [
              Shadow(
                color: AppColors.rubedoRed.withOpacity(0.6),
                blurRadius: 15,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(
              'Help us improve Cognifex by reporting bugs or issues you encounter.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.alabasterWhite,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      'Gameplay',
      'UI/UX',
      'Performance',
      'Audio',
      'Other'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.alchemicalGold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: AppColors.neutralSteel.withOpacity(0.2),
              selectedColor: AppColors.alchemicalGold.withOpacity(0.3),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.alchemicalGold
                    : AppColors.alabasterWhite,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.alchemicalGold
                    : AppColors.neutralSteel.withOpacity(0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Title',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.alchemicalGold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _titleController,
          maxLength: 100,
          style: const TextStyle(color: AppColors.alabasterWhite),
          decoration: InputDecoration(
            hintText: 'Brief description of the issue',
            hintStyle: TextStyle(
              color: AppColors.neutralSteel.withOpacity(0.7),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: BorderSide(
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: BorderSide(
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: const BorderSide(
                color: AppColors.alchemicalGold,
                width: 2,
              ),
            ),
            counterStyle: const TextStyle(color: AppColors.neutralSteel),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            if (value.trim().length < 5) {
              return 'Title must be at least 5 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.alchemicalGold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _descriptionController,
          maxLength: 500,
          maxLines: 8,
          style: const TextStyle(color: AppColors.alabasterWhite),
          decoration: InputDecoration(
            hintText:
                'Describe the bug in detail:\n• What happened?\n• What were you doing?\n• Can you reproduce it?',
            hintStyle: TextStyle(
              color: AppColors.neutralSteel.withOpacity(0.7),
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: BorderSide(
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: BorderSide(
                color: AppColors.neutralSteel.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.mediumRadius,
              borderSide: const BorderSide(
                color: AppColors.alchemicalGold,
                width: 2,
              ),
            ),
            counterStyle: const TextStyle(color: AppColors.neutralSteel),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please describe the issue';
            }
            if (value.trim().length < 20) {
              return 'Please provide more details (at least 20 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rubedoRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          elevation: 8,
          shadowColor: AppColors.rubedoRed.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mediumRadius,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.send, size: 20),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Submit Report',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

