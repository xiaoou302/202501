import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/enhanced_form_elements.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/input_utils.dart';
import '../../../shared/utils/app_strings.dart';
import '../../../theme.dart';
import '../models/relationship.dart';
import '../../../routes.dart';

class SetupRelationshipScreen extends StatefulWidget {
  const SetupRelationshipScreen({super.key});

  @override
  State<SetupRelationshipScreen> createState() =>
      _SetupRelationshipScreenState();
}

class _SetupRelationshipScreenState extends State<SetupRelationshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  DateTime _userBirthday = DateTime(2000, 1, 1);
  DateTime _partnerBirthday = DateTime(2000, 1, 1);
  DateTime _anniversaryDate = DateTime.now();
  String _userGender = 'male';

  @override
  void dispose() {
    _userNameController.dispose();
    _partnerNameController.dispose();
    super.dispose();
  }

  Future<void> _saveRelationship() async {
    // Hide keyboard
    InputUtils.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    final relationship = Relationship(
      userGender: _userGender,
      userBirthday: _userBirthday,
      partnerBirthday: _partnerBirthday,
      anniversaryDate: _anniversaryDate,
      userName: _userNameController.text,
      partnerName: _partnerNameController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefRelationship,
      jsonEncode(relationship.toJson()),
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.loveDiary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScaffold(
      appBar: AppBar(
        title: Text(AppStrings.setupInfo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormSection(
                title: AppStrings.fillBasicInfo,
                children: [
                  EnhancedRadioGroup<String>(
                    title: AppStrings.yourGender,
                    value: _userGender,
                    options: const ['male', 'female'],
                    labels: [AppStrings.male, AppStrings.female],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _userGender = value;
                        });
                      }
                    },
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: 24),
                  EnhancedTextField(
                    controller: _userNameController,
                    label: AppStrings.yourName,
                    hint: 'Enter your name',
                    prefixIcon: const Icon(Icons.person),
                    maxLength: InputUtils.nameMaxLength,
                    validator: InputUtils.validateName,
                  ),
                  const SizedBox(height: 24),
                  EnhancedTextField(
                    controller: _partnerNameController,
                    label: AppStrings.partnerName,
                    hint: 'Enter your partner\'s name',
                    prefixIcon: const Icon(Icons.favorite),
                    maxLength: InputUtils.nameMaxLength,
                    validator: InputUtils.validateName,
                  ),
                ],
              ),
              FormSection(
                title: 'Important Dates',
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  EnhancedDatePicker(
                    selectedDate: _userBirthday,
                    onDateSelected: (date) {
                      setState(() {
                        _userBirthday = date;
                      });
                    },
                    label: AppStrings.yourBirthday,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ),
                  const SizedBox(height: 24),
                  EnhancedDatePicker(
                    selectedDate: _partnerBirthday,
                    onDateSelected: (date) {
                      setState(() {
                        _partnerBirthday = date;
                      });
                    },
                    label: AppStrings.partnerBirthday,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ),
                  const SizedBox(height: 24),
                  EnhancedDatePicker(
                    selectedDate: _anniversaryDate,
                    onDateSelected: (date) {
                      setState(() {
                        _anniversaryDate = date;
                      });
                    },
                    label: AppStrings.anniversaryDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    helperText: 'The day you started your relationship',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: AppStrings.saveInfo,
                icon: Icons.check,
                onPressed: _saveRelationship,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
