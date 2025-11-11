import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/reminder_model.dart';
import '../../data/repositories/pet_repository.dart';

class AddReminderScreen extends StatefulWidget {
  final PetRepository repository;
  final String petId;
  final String petName;

  const AddReminderScreen({
    Key? key,
    required this.repository,
    required this.petId,
    required this.petName,
  }) : super(key: key);

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReminderType _selectedType = ReminderType.custom;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  bool _isSaving = false;

  final Map<ReminderType, String> _reminderTypeLabels = {
    ReminderType.deworming: 'Deworming',
    ReminderType.vetCheckup: 'Vet Checkup',
    ReminderType.vaccination: 'Vaccination',
    ReminderType.grooming: 'Grooming',
    ReminderType.birthday: 'Birthday',
    ReminderType.gotchaDay: 'Gotcha Day',
    ReminderType.custom: 'Custom',
  };

  final Map<ReminderType, IconData> _reminderTypeIcons = {
    ReminderType.deworming: Icons.medication,
    ReminderType.vetCheckup: Icons.local_hospital,
    ReminderType.vaccination: Icons.vaccines,
    ReminderType.grooming: Icons.shower,
    ReminderType.birthday: Icons.cake,
    ReminderType.gotchaDay: Icons.favorite,
    ReminderType.custom: Icons.notifications,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.softCoral,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppConstants.darkGraphite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final reminder = Reminder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        petId: widget.petId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        type: _selectedType,
        createdAt: DateTime.now(),
      );

      await widget.repository.addReminder(reminder);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Reminder for ${widget.petName}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                // Reminder Type
                Text(
                  'Reminder Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children: _reminderTypeLabels.entries.map((entry) {
                    final isSelected = _selectedType == entry.key;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _reminderTypeIcons[entry.key],
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : AppConstants.mediumGray,
                          ),
                          const SizedBox(width: 4),
                          Text(entry.value),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: AppConstants.softCoral,
                      backgroundColor: isDark
                          ? AppConstants.deepPlum
                          : AppConstants.shellWhite,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedType = entry.key;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Title
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., Monthly Deworming',
                    counterText: '',
                    prefixIcon: Icon(
                      _reminderTypeIcons[_selectedType],
                      color: AppConstants.softCoral,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      borderSide: const BorderSide(
                        color: AppConstants.softCoral,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter reminder title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 200,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add notes about this reminder...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      borderSide: const BorderSide(
                        color: AppConstants.softCoral,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Due Date
                ListTile(
                  title: const Text('Due Date *'),
                  subtitle: Text(
                    '${_dueDate.month}/${_dueDate.day}/${_dueDate.year}',
                    style: const TextStyle(
                      color: AppConstants.softCoral,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.softCoral.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: AppConstants.softCoral,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppConstants.mediumGray,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    side: BorderSide(
                      color: isDark
                          ? AppConstants.mediumGray
                          : AppConstants.mediumGray.withOpacity(0.3),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: AppConstants.spacingXL),

                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.softCoral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Add Reminder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
}
