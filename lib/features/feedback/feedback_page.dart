import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/dynamic_island.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedCategory = 'Feature Request';
  DynamicIslandController? _dynamicIslandController;

  final List<String> _categories = [
    'Feature Request',
    'Bug Report',
    'UI/UX Feedback',
    'Performance Issue',
    'Other',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dynamicIslandController = DynamicIslandController(context);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    _dynamicIslandController?.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement feedback submission
      _dynamicIslandController?.show(
        message: 'Thank you for your feedback!',
        icon: Icons.check_circle,
        duration: const Duration(seconds: 2),
      );

      // Clear form
      _feedbackController.clear();
      _emailController.clear();
      setState(() {
        _selectedCategory = 'Feature Request';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const CustomAppBar(
                  title: 'Help Us Improve',
                  showBackButton: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppStyles.paddingMedium),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderSection(),
                          const SizedBox(height: AppStyles.paddingLarge),
                          _buildCategoryDropdown(),
                          const SizedBox(height: AppStyles.paddingLarge),
                          _buildFeedbackField(),
                          const SizedBox(height: AppStyles.paddingLarge),
                          _buildEmailField(),
                          const SizedBox(height: AppStyles.paddingXLarge),
                          _buildSubmitButton(),
                        ],
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingMedium),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.accentPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppStyles.paddingMedium),
              const Expanded(
                child: Text(
                  'Share Your Thoughts',
                  style: AppStyles.heading3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppStyles.paddingMedium),
          Text(
            'Your feedback helps us improve and create a better experience for everyone.',
            style: AppStyles.bodyText.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Category',
          style: AppStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppStyles.paddingSmall),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppStyles.paddingMedium,
                vertical: AppStyles.paddingMedium,
              ),
              hintStyle: AppStyles.bodyText.copyWith(
                color: Colors.white38,
              ),
            ),
            style: AppStyles.bodyText,
            dropdownColor: AppColors.deepBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Feedback',
          style: AppStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppStyles.paddingSmall),
        TextFormField(
          controller: _feedbackController,
          decoration:
              AppStyles.inputDecoration('Share your thoughts...').copyWith(
            alignLabelWithHint: true,
          ),
          style: AppStyles.bodyText,
          maxLines: 5,
          maxLength: 1000,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your feedback';
            }
            if (value.trim().length < 10) {
              return 'Feedback must be at least 10 characters long';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email (Optional)',
          style: AppStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppStyles.paddingSmall),
        TextFormField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration('your@email.com'),
          style: AppStyles.bodyText,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
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
        onPressed: _submitFeedback,
        style: AppStyles.primaryButtonStyle,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: AppStyles.paddingMedium),
          child: Text('Submit Feedback'),
        ),
      ),
    );
  }
}
