import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/growth_track_model.dart';
import '../../data/repositories/pet_repository.dart';

class AddGrowthTrackScreen extends StatefulWidget {
  final PetRepository repository;
  final String petId;
  final String petName;

  const AddGrowthTrackScreen({
    Key? key,
    required this.repository,
    required this.petId,
    required this.petName,
  }) : super(key: key);

  @override
  State<AddGrowthTrackScreen> createState() => _AddGrowthTrackScreenState();
}

class _AddGrowthTrackScreenState extends State<AddGrowthTrackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime _date = DateTime.now();
  String? _selectedImagePath;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
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
        _date = picked;
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
            aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
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

  Future<void> _saveGrowthTrack() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final track = GrowthTrack(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        petId: widget.petId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _date,
        imageUrls: _selectedImagePath != null ? [_selectedImagePath!] : null,
        createdAt: DateTime.now(),
      );

      await widget.repository.addGrowthTrack(track);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving growth track: $e'),
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
          title: Text('Add Growth Track for ${widget.petName}'),
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
                // Image Preview
                if (_selectedImagePath != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    child: Stack(
                      children: [
                        Image.file(
                          File(_selectedImagePath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedImagePath = null;
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                ],

                // Add Photo Button
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(
                    _selectedImagePath == null
                        ? 'Add Photo (Optional)'
                        : 'Change Photo',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.softCoral,
                    side: const BorderSide(
                      color: AppConstants.softCoral,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Date
                ListTile(
                  title: const Text('Date *'),
                  subtitle: Text(
                    '${_date.month}/${_date.day}/${_date.year}',
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
                const SizedBox(height: AppConstants.spacingM),

                // Title
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 60,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., First time learning to shake hands',
                    counterText: '',
                    prefixIcon: const Icon(
                      Icons.title,
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
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Describe this milestone in detail...',
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingXL),

                // Save Button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveGrowthTrack,
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
                          'Add Growth Track',
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
