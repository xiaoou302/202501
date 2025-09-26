import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/core/utils/error_handler.dart';
import 'package:soli/core/utils/image_picker_util.dart';
import 'package:soli/data/repositories/memory_repository.dart';

/// 添加回忆页面
class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  //sdasdasdasd
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final MemoryRepository _memoryRepository = MemoryRepository();

  DateTime _selectedDate = DateTime.now();
  final List<String> _selectedTags = [];
  bool _isLoading = false;
  String? _selectedImagePath;
  bool _imageError = false;
  bool _imageExists = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 选择日期
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.champagne,
              onPrimary: AppTheme.deepSpace,
              surface: AppTheme.silverstone,
              onSurface: AppTheme.moonlight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 切换标签选择
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  // 选择图片
  Future<void> _pickImage() async {
    try {
      debugPrint('AddMemoryScreen: 开始选择图片');
      final imagePath = await ImagePickerUtil.showImagePickerOptions(context);

      debugPrint('AddMemoryScreen: 返回的图片路径: $imagePath');
      if (imagePath != null) {
        // 检查组件是否仍然挂载
        if (!mounted) return;

        // 验证文件是否存在
        final file = File(imagePath);
        final exists = await file.exists();
        final fileSize = exists ? await file.length() : 0;
        debugPrint('AddMemoryScreen: 图片文件是否存在: $exists, 大小: $fileSize 字节');

        setState(() {
          _selectedImagePath = imagePath;
          _imageError = !exists;
          _imageExists = exists;
        });
      }
    } catch (e) {
      debugPrint('AddMemoryScreen: 选择图片时出错: $e');
      // 检查组件是否仍然挂载
      if (!mounted) return;

      setState(() {
        _imageError = true;
        _imageExists = false;
      });

      ErrorHandler.showError(
        context,
        'Failed to select image: ${e.toString()}',
      );
    }
  }

  // Save memory
  Future<void> _saveMemory() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTags.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one tag'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedImagePath == null || !_imageExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a valid image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        await _memoryRepository.addMemory(
          title: _titleController.text.trim(),
          imageUrl: _selectedImagePath!,
          date: _selectedDate,
          tags: _selectedTags,
          description: _descriptionController.text.trim(),
        );

        if (mounted) {
          ErrorHandler.showSuccess(context, 'Memory added successfully!');
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('AddMemoryScreen: Error saving memory: $e');
        if (mounted) {
          ErrorHandler.showError(context, 'Failed to add: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // 隐藏键盘
  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域隐藏键盘
      onTap: _hideKeyboard,
      child: Scaffold(
        backgroundColor: AppTheme.deepSpace,
        appBar: AppBar(
          backgroundColor: AppTheme.deepSpace,
          title: const Text('Add new memories'),
          foregroundColor: AppTheme.moonlight,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.champagne),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题输入
                      _buildTitleInput(),
                      const SizedBox(height: 20),

                      // 图片选择
                      _buildImageSelector(),
                      const SizedBox(height: 20),

                      // 日期选择
                      _buildDatePicker(),
                      const SizedBox(height: 24),

                      // 标签选择
                      _buildTagSelection(),
                      const SizedBox(height: 24),

                      // 描述输入
                      _buildDescriptionInput(),
                      const SizedBox(height: 32),

                      // 保存按钮
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveMemory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.champagne,
                            foregroundColor: AppTheme.deepSpace,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save memories',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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

  // 构建标题输入
  Widget _buildTitleInput() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: AppTheme.moonlight),
      decoration: InputDecoration(
        labelText: 'Recall title',
        labelStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
        ),
        filled: true,
        fillColor: AppTheme.silverstone,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.champagne),
        ),
        counterText: '${_titleController.text.length}/30',
        counterStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          fontSize: 12,
        ),
      ),
      maxLength: 30, // 设置最大输入长度为30个字符
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textInputAction: TextInputAction.next, // 设置键盘下一步按钮
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a memory title';
        }
        if (value.trim().length < 2) {
          return 'The title must be at least 2 characters long';
        }
        return null;
      },
    );
  }

  // 构建图片选择器
  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Picture',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // 图片预览区域
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.silverstone,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _imageError
                    ? Colors.red
                    : ColorUtils.withOpacity(AppTheme.champagne, 0.3),
                width: _imageError ? 2 : 1,
              ),
            ),
            child: _buildImagePreview(),
          ),
        ),
        if (_imageError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Image loading failed, please select again',
              style: TextStyle(color: Colors.red[300], fontSize: 12),
            ),
          ),
      ],
    );
  }

  // 构建图片预览
  Widget _buildImagePreview() {
    if (_selectedImagePath == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate,
              color: AppTheme.champagne,
              size: 50,
            ),
            const SizedBox(height: 12),
            Text(
              'Click to select image',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // 直接尝试显示本地图片
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(_selectedImagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('AddMemoryScreen: Error loading image: $error');
          // 图片加载失败时，标记错误状态
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _imageError = true;
                _imageExists = false;
              });
            }
          });
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, color: Colors.red, size: 50),
                const SizedBox(height: 8),
                const Text(
                  'Image loading failed',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.champagne,
                    foregroundColor: AppTheme.deepSpace,
                  ),
                  child: const Text('Reselect'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 构建日期选择器
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.silverstone,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy/MM/dd').format(_selectedDate),
                  style: const TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: AppTheme.champagne,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 构建标签选择
  Widget _buildTagSelection() {
    // 过滤掉"所有回忆"标签
    final availableTags =
        AppConstants.memoryTags.where((tag) => tag != 'All memories').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Label',
          style: TextStyle(
            color: AppTheme.moonlight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.champagne : AppTheme.silverstone,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? AppTheme.deepSpace : AppTheme.moonlight,
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 构建描述输入
  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _descriptionController,
      style: const TextStyle(color: AppTheme.moonlight),
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
        ),
        filled: true,
        fillColor: AppTheme.silverstone,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.champagne),
        ),
        counterText: '${_descriptionController.text.length}/500',
        counterStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          fontSize: 12,
        ),
        hintText: 'Describe your memory (optional)',
        hintStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
          fontSize: 14,
        ),
      ),
      maxLength: 500, // 设置最大输入长度为500个字符
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textInputAction: TextInputAction.done, // 设置键盘完成按钮
    );
  }
}
