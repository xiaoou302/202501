import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/pet_model.dart';
import '../../data/models/reminder_model.dart';
import '../../data/repositories/pet_repository.dart';

class AddPetScreen extends StatefulWidget {
  final PetRepository repository;

  const AddPetScreen({Key? key, required this.repository}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  DateTime _birthday = DateTime.now();
  DateTime _gotchaDay = DateTime.now();
  String? _selectedImagePath;
  bool _isSaving = false;

  final List<String> _speciesList = [
    'Dog',
    'Cat',
    'Hamster',
    'Rabbit',
    'Bird',
    'Fish',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _hobbiesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isBirthday) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthday ? _birthday : _gotchaDay,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
        if (isBirthday) {
          _birthday = picked;
        } else {
          _gotchaDay = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      // Show options: Camera or Gallery
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppConstants.darkGray : AppConstants.panelWhite,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusXL),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppConstants.spacingM),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.mediumGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  Text('Select Photo', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppConstants.spacingM),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.softCoral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppConstants.softCoral,
                      ),
                    ),
                    title: const Text('Take Photo'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppConstants.softCoral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: AppConstants.softCoral,
                      ),
                    ),
                    title: const Text('Choose from Library'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                ],
              ),
            ),
          );
        },
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 90,
        );

        if (image != null) {
          // Crop the image
          final croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              IOSUiSettings(
                title: 'Crop Photo',
                cancelButtonTitle: 'Cancel',
                doneButtonTitle: 'Done',
                aspectRatioLockEnabled: false,
                resetAspectRatioEnabled: true,
                aspectRatioPickerButtonHidden: false,
                rotateButtonsHidden: false,
                minimumAspectRatio: 0.5,
              ),
            ],
          );

          if (croppedFile != null) {
            setState(() {
              _selectedImagePath = croppedFile.path;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final pet = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        breed: _breedController.text.trim(),
        gender: _selectedGender,
        birthday: _birthday,
        gotchaDay: _gotchaDay,
        avatarUrl: _selectedImagePath,
        hobbies: _hobbiesController.text.trim(),
        isActive: true,
        createdAt: DateTime.now(),
      );

      await widget.repository.addPet(pet);

      // Create automatic reminders for birthday and gotcha day
      final birthdayReminder = Reminder(
        id: '${pet.id}_birthday',
        petId: pet.id,
        title: '${pet.name}\'s Birthday',
        description: 'Celebrate ${pet.name}\'s special day!',
        dueDate: DateTime(DateTime.now().year, _birthday.month, _birthday.day),
        type: ReminderType.birthday,
        createdAt: DateTime.now(),
      );

      final gotchaDayReminder = Reminder(
        id: '${pet.id}_gotcha',
        petId: pet.id,
        title: '${pet.name}\'s Gotcha Day',
        description: 'Anniversary of the day ${pet.name} joined your family!',
        dueDate: DateTime(
          DateTime.now().year,
          _gotchaDay.month,
          _gotchaDay.day,
        ),
        type: ReminderType.gotchaDay,
        createdAt: DateTime.now(),
      );

      await widget.repository.addReminder(birthdayReminder);
      await widget.repository.addReminder(gotchaDayReminder);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving pet: $e'),
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
          title: const Text('Add New Pet'),
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
                // Avatar Selector
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppConstants.deepPlum
                            : AppConstants.shellWhite,
                        border: Border.all(
                          color: AppConstants.softCoral,
                          width: 3,
                        ),
                      ),
                      child: _selectedImagePath != null
                          ? ClipOval(
                              child: Image.file(
                                File(_selectedImagePath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.pets,
                              size: 48,
                              color: AppConstants.mediumGray,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingS),
                Center(
                  child: TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      _selectedImagePath == null
                          ? 'Select Avatar'
                          : 'Change Avatar',
                      style: const TextStyle(color: AppConstants.softCoral),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Name
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: 'Pet Name *',
                    hintText: 'e.g., Max, Luna',
                    counterText: '',
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
                      return 'Please enter pet name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Species
                DropdownButtonFormField<String>(
                  value: _selectedSpecies,
                  decoration: InputDecoration(
                    labelText: 'Species *',
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
                  items: _speciesList.map((species) {
                    return DropdownMenuItem(
                      value: species,
                      child: Text(species),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecies = value!;
                    });
                  },
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Breed
                TextFormField(
                  controller: _breedController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    hintText: 'e.g., Golden Retriever',
                    counterText: '',
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

                // Gender
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender *', style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppConstants.spacingS),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: _selectedGender,
                            activeColor: AppConstants.softCoral,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: _selectedGender,
                            activeColor: AppConstants.softCoral,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Birthday
                ListTile(
                  title: const Text('Birthday *'),
                  subtitle: Text(
                    '${_birthday.month}/${_birthday.day}/${_birthday.year}',
                    style: const TextStyle(
                      color: AppConstants.softCoral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: AppConstants.softCoral,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    side: BorderSide(
                      color: isDark
                          ? AppConstants.mediumGray
                          : AppConstants.mediumGray.withOpacity(0.3),
                    ),
                  ),
                  onTap: () => _selectDate(context, true),
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Gotcha Day
                ListTile(
                  title: const Text('Gotcha Day *'),
                  subtitle: Text(
                    '${_gotchaDay.month}/${_gotchaDay.day}/${_gotchaDay.year}',
                    style: const TextStyle(
                      color: AppConstants.softCoral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: AppConstants.softCoral,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    side: BorderSide(
                      color: isDark
                          ? AppConstants.mediumGray
                          : AppConstants.mediumGray.withOpacity(0.3),
                    ),
                  ),
                  onTap: () => _selectDate(context, false),
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Hobbies
                TextFormField(
                  controller: _hobbiesController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 200,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Hobbies',
                    hintText: 'e.g., Loves chasing balls, enjoys napping',
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
                const SizedBox(height: AppConstants.spacingXL),

                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _savePet,
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
                          'Add Pet',
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
