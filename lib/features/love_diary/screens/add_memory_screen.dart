import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/enhanced_form_elements.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/input_utils.dart';
import '../../../shared/utils/app_strings.dart';
import '../../../theme.dart';
import '../models/memory.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<String> _imageUrls = [];
  final List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    InputUtils.hideKeyboard(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.selectImageSource,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      title: AppStrings.camera,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      title: AppStrings.gallery,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.deepPurple, AppTheme.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentPurple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 36, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _imageFiles.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  Future<List<String>> _saveImages() async {
    if (_imageFiles.isEmpty) return [];

    final List<String> savedImagePaths = [];
    final appDir = await getApplicationDocumentsDirectory();
    final memoryDir = Directory('${appDir.path}/memories');

    if (!await memoryDir.exists()) {
      await memoryDir.create(recursive: true);
    }

    for (var file in _imageFiles) {
      final uuid = const Uuid().v4();
      final newPath = '${memoryDir.path}/$uuid.jpg';
      await file.copy(newPath);
      savedImagePaths.add(newPath);
    }

    return savedImagePaths;
  }

  Future<void> _saveMemory() async {
    InputUtils.hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final savedImagePaths = await _saveImages();

      final memory = Memory(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        imageUrls: savedImagePaths,
      );

      final prefs = await SharedPreferences.getInstance();
      final memoriesJson = prefs.getString(AppConstants.prefMemories);

      List<Memory> memories = [];
      if (memoriesJson != null) {
        final List<dynamic> memoriesList =
            jsonDecode(memoriesJson) as List<dynamic>;
        memories = memoriesList
            .map((item) => Memory.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      memories.add(memory);

      await prefs.setString(
        AppConstants.prefMemories,
        jsonEncode(memories.map((m) => m.toJson()).toList()),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.saveFailed}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardScaffold(
      appBar: AppBar(title: Text(AppStrings.addLoveRecord), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EnhancedTextField(
                    controller: _titleController,
                    label: AppStrings.title,
                    hint: 'Enter a title for this memory',
                    prefixIcon: const Icon(Icons.bookmark),
                    maxLength: InputUtils.titleMaxLength,
                    validator: InputUtils.validateTitle,
                  ),
                  const SizedBox(height: 24),
                  EnhancedDatePicker(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    label: AppStrings.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ),
                  const SizedBox(height: 24),
                  EnhancedTextField(
                    controller: _descriptionController,
                    label: AppStrings.description,
                    hint: 'Describe this special moment',
                    prefixIcon: const Icon(Icons.description),
                    maxLength: InputUtils.descriptionMaxLength,
                    maxLines: 5,
                    validator: InputUtils.validateDescription,
                  ),
                  const SizedBox(height: 24),
                  FormSection(
                    title: AppStrings.images,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_imageFiles.length} images selected',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          TextButton.icon(
                            onPressed: _showImageSourceDialog,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: Text(AppStrings.addImage),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.lightPurple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildImagesList(),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GradientButton(
                    text: AppStrings.saveRecord,
                    icon: Icons.save,
                    onPressed: _isLoading ? null : _saveMemory,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.lightPurple),
                    ),
                    const SizedBox(height: 16),
                    const Text('Saving memory...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagesList() {
    if (_imageFiles.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.darkBlue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.deepPurple.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: Colors.grey.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.noImages),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(_imageFiles.length, (index) {
          return Stack(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 80) / 3,
                height: (MediaQuery.of(context).size.width - 80) / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFiles[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
