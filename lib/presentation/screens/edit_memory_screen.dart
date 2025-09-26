import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/core/utils/error_handler.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/data/repositories/memory_repository.dart';

/// 编辑回忆页面
class EditMemoryScreen extends StatefulWidget {
  final MemoryModel memory;

  const EditMemoryScreen({super.key, required this.memory});

  @override
  State<EditMemoryScreen> createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  final MemoryRepository _memoryRepository = MemoryRepository();

  late DateTime _selectedDate;
  late List<String> _selectedTags;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初始化控制器并填充现有数据
    _titleController = TextEditingController(text: widget.memory.title);
    _imageUrlController = TextEditingController(text: widget.memory.imageUrl);
    _descriptionController = TextEditingController(
      text: widget.memory.description ?? '',
    );
    _selectedDate = widget.memory.date;
    _selectedTags = List.from(widget.memory.tags);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
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

  // 保存回忆
  Future<void> _saveMemory() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTags.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请至少选择一个标签'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // 创建更新后的回忆对象
        final updatedMemory = widget.memory.copyWith(
          title: _titleController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          date: _selectedDate,
          tags: _selectedTags,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
        );

        // 更新回忆
        await _memoryRepository.updateMemory(updatedMemory);

        if (mounted) {
          ErrorHandler.showSuccess(context, '回忆更新成功！');
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showError(context, '更新失败: ${e.toString()}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        backgroundColor: AppTheme.deepSpace,
        title: const Text('编辑回忆'),
        foregroundColor: AppTheme.moonlight,
        elevation: 0,
        actions: [
          // 删除按钮
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _confirmDelete,
          ),
        ],
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

                    // 图片URL输入
                    _buildImageUrlInput(),
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
                          '保存更改',
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
    );
  }

  // 确认删除对话框
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.silverstone,
        title: const Text('删除回忆', style: TextStyle(color: AppTheme.moonlight)),
        content: const Text(
          '确定要删除这个回忆吗？此操作无法撤销。',
          style: TextStyle(color: AppTheme.moonlight),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '取消',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _memoryRepository.deleteMemory(widget.memory.id);
        if (mounted) {
          ErrorHandler.showSuccess(context, '回忆已删除');
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showError(context, '删除失败: ${e.toString()}');
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

  // 构建标题输入
  Widget _buildTitleInput() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(color: AppTheme.moonlight),
      decoration: InputDecoration(
        labelText: '回忆标题',
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
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '请输入回忆标题';
        }
        return null;
      },
    );
  }

  // 构建图片URL输入
  Widget _buildImageUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _imageUrlController,
          style: const TextStyle(color: AppTheme.moonlight),
          decoration: InputDecoration(
            labelText: '图片链接',
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
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入图片链接';
            }
            if (!Uri.tryParse(value)!.isAbsolute) {
              return '请输入有效的URL';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          '提示：可以使用 Unsplash 等网站的图片链接',
          style: TextStyle(
            color: ColorUtils.withOpacity(AppTheme.moonlight, 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // 构建日期选择器
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '日期',
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
                  DateFormat('MMMM d, yyyy').format(_selectedDate),
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
    final availableTags = AppConstants.memoryTags
        .where((tag) => tag != '所有回忆')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '标签',
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
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
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
        labelText: '回忆描述',
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
      ),
    );
  }
}
