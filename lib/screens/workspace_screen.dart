import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../models/draft.dart';
import '../models/poem.dart';
import '../services/storage_service.dart';
import '../services/mock_data_service.dart';
import '../styles/app_colors.dart';
import '../styles/text_styles.dart';
import '../widgets/poem_detail_dialog.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> with AutomaticKeepAliveClientMixin {
  bool _isCreationMode = true;
  bool _isGridView = false; // 新增：控制 Creation Studio 的视图模式
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _editorController = TextEditingController();
  final StorageService _storage = StorageService();
  final ImagePicker _imagePicker = ImagePicker();
  List<Draft> _drafts = [];
  Draft? _currentDraft;
  List<Poem> _bookmarkedPoems = [];
  bool _showDraftList = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
    _loadBookmarkedPoems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面依赖变化时（包括从其他页面返回），刷新收藏列表并重置到 Creation Studio
    _refreshBookmarkedPoems();
    // 默认选择 Creation Studio
    if (mounted) {
      setState(() {
        _isCreationMode = true;
      });
    }
  }

  // 刷新收藏列表
  void _refreshBookmarkedPoems() async {
    final bookmarkIds = await _storage.loadBookmarks();
    
    // 获取所有诗歌（包括 Discovery 和 Author Profile 的）
    final allPoems = <Poem>[];
    
    // 从 Discovery 获取诗歌
    allPoems.addAll(MockDataService.getMockPoems());
    
    // 从所有作者获取作品
    final authors = MockDataService.getAllAuthors();
    for (var author in authors) {
      final authorWorks = MockDataService.getAuthorWorks(author.id);
      for (var work in authorWorks) {
        // 避免重复添加
        if (!allPoems.any((p) => p.id == work.id)) {
          allPoems.add(work);
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _bookmarkedPoems = allPoems.where((poem) {
          return bookmarkIds.contains(poem.id);
        }).toList();
        
        // 设置收藏状态
        for (var poem in _bookmarkedPoems) {
          poem.isBookmarked = true;
        }
      });
    }
  }

  void _loadDrafts() async {
    final drafts = await _storage.loadDrafts();
    setState(() {
      _drafts = drafts;
      if (_drafts.isEmpty) {
        _createNewDraft();
      } else {
        _currentDraft = _drafts.first;
        _titleController.text = _currentDraft!.title;
        _editorController.text = _currentDraft!.content;
      }
    });
  }

  void _loadBookmarkedPoems() async {
    final bookmarkIds = await _storage.loadBookmarks();
    
    // 获取所有诗歌（包括 Discovery 和 Author Profile 的）
    final allPoems = <Poem>[];
    
    // 从 Discovery 获取诗歌
    allPoems.addAll(MockDataService.getMockPoems());
    
    // 从所有作者获取作品
    final authors = MockDataService.getAllAuthors();
    for (var author in authors) {
      final authorWorks = MockDataService.getAuthorWorks(author.id);
      for (var work in authorWorks) {
        // 避免重复添加
        if (!allPoems.any((p) => p.id == work.id)) {
          allPoems.add(work);
        }
      }
    }
    
    setState(() {
      _bookmarkedPoems = allPoems.where((poem) {
        return bookmarkIds.contains(poem.id);
      }).toList();
      
      // 设置收藏状态
      for (var poem in _bookmarkedPoems) {
        poem.isBookmarked = true;
      }
    });
  }

  void _removeBookmark(Poem poem) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.ribbon.withValues(alpha: 0.15),
                      AppColors.olive.withValues(alpha: 0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_remove,
                  color: AppColors.ribbon,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Remove from Collection?',
                style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This poem will be removed from your collection.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.ribbon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      await _storage.removeBookmark(poem.id);
      setState(() {
        _bookmarkedPoems.removeWhere((p) => p.id == poem.id);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "${poem.title}" from collection'),
            backgroundColor: AppColors.ink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _createNewDraft() async {
    final newDraft = Draft(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      lastModified: DateTime.now(),
    );
    setState(() {
      _currentDraft = newDraft;
      _drafts.insert(0, newDraft);
      _titleController.clear();
      _editorController.clear();
      _showDraftList = false;
    });
    await _saveDraft();
  }

  void _switchDraft(Draft draft) {
    if (_currentDraft != null) {
      _currentDraft!.title = _titleController.text;
      _currentDraft!.content = _editorController.text;
      _currentDraft!.lastModified = DateTime.now();
    }
    
    setState(() {
      _currentDraft = draft;
      _titleController.text = draft.title;
      _editorController.text = draft.content;
      _showDraftList = false;
    });
  }

  void _deleteDraft(Draft draft) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, AppColors.paperLight],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.ribbon.withValues(alpha: 0.15),
                      AppColors.olive.withValues(alpha: 0.15),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.ribbon, size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Draft?',
                style: AppTextStyles.poemTitle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.ribbon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      setState(() {
        _drafts.remove(draft);
        if (_currentDraft?.id == draft.id) {
          if (_drafts.isNotEmpty) {
            _currentDraft = _drafts.first;
            _titleController.text = _currentDraft!.title;
            _editorController.text = _currentDraft!.content;
          } else {
            _createNewDraft();
          }
        }
      });
      await _storage.saveDrafts(_drafts);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Draft deleted'),
            backgroundColor: AppColors.ink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveDraft() async {
    if (_currentDraft != null) {
      _currentDraft!.title = _titleController.text;
      _currentDraft!.content = _editorController.text;
      _currentDraft!.lastModified = DateTime.now();
      await _storage.saveDrafts(_drafts);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Draft saved'),
            backgroundColor: AppColors.olive,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null && _currentDraft != null) {
        // 裁剪图片
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          uiSettings: [
            IOSUiSettings(
              title: 'Crop Image',
              doneButtonTitle: 'Done',
              cancelButtonTitle: 'Cancel',
              aspectRatioLockEnabled: false,
              resetAspectRatioEnabled: true,
              aspectRatioPickerButtonHidden: false,
            ),
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppColors.olive,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
          ],
        );
        
        if (croppedFile != null) {
          setState(() {
            _currentDraft!.associatedImageUrl = croppedFile.path;
          });
          await _saveDraft();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Image added to draft'),
                backgroundColor: AppColors.olive,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.ribbon,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _editImage() async {
    if (_currentDraft?.associatedImageUrl == null) return;
    
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _currentDraft!.associatedImageUrl!,
        uiSettings: [
          IOSUiSettings(
            title: 'Adjust Image',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            aspectRatioPickerButtonHidden: false,
          ),
          AndroidUiSettings(
            toolbarTitle: 'Adjust Image',
            toolbarColor: AppColors.olive,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );
      
      if (croppedFile != null) {
        setState(() {
          _currentDraft!.associatedImageUrl = croppedFile.path;
        });
        await _saveDraft();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Image updated'),
              backgroundColor: AppColors.olive,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit image: $e'),
            backgroundColor: AppColors.ribbon,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _removeImage() {
    if (_currentDraft != null) {
      setState(() {
        _currentDraft!.associatedImageUrl = null;
      });
      _saveDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用以支持 AutomaticKeepAliveClientMixin
    return GestureDetector(
      onTap: () {
        // 点击非输入框区域时收起键盘
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.paper,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSegmentedControl(),
                const SizedBox(height: 24),
                Expanded(
                  child: _isCreationMode ? _buildCreationStudio() : _buildCollection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.ribbon.withValues(alpha: 0.03),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isCreationMode = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: _isCreationMode
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.ribbon,
                            AppColors.ribbon.withValues(alpha: 0.9),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isCreationMode
                      ? [
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 18,
                      color: _isCreationMode ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Creation Studio',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: _isCreationMode ? FontWeight.bold : FontWeight.w500,
                        color: _isCreationMode ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isCreationMode = false);
                _refreshBookmarkedPoems();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: !_isCreationMode
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.ribbon,
                            AppColors.ribbon.withValues(alpha: 0.9),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: !_isCreationMode
                      ? [
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_rounded,
                      size: 18,
                      color: !_isCreationMode ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Collection',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: !_isCreationMode ? FontWeight.bold : FontWeight.w500,
                        color: !_isCreationMode ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreationStudio() {
    // 如果没有当前草稿，显示加载状态
    if (_currentDraft == null && !_isGridView) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.olive,
        ),
      );
    }
    
    return Stack(
      children: [
        Column(
          children: [
            // Toolbar
            _buildToolbar(),
            const SizedBox(height: 12),
            
            // 根据视图模式显示不同内容
            Expanded(
              child: _isGridView ? _buildDraftsGridView() : _buildEditorView(),
            ),
          ],
        ),
        
        // Draft list overlay
        if (_showDraftList && !_isGridView) _buildDraftListOverlay(),
      ],
    );
  }

  // 编辑器视图
  Widget _buildEditorView() {
    if (_currentDraft == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.olive,
        ),
      );
    }
    
    return Column(
      children: [
            
        // Title field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.paperLight.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.06),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.olive.withValues(alpha: 0.04),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: TextField(
            controller: _titleController,
            maxLength: 100,
            style: AppTextStyles.poemTitle.copyWith(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Untitled Poem',
              hintStyle: AppTextStyles.poemTitle.copyWith(
                fontSize: 18,
                color: AppColors.textTertiary,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              counterText: '', // 隐藏字符计数器
            ),
            onChanged: (value) {
              if (_currentDraft != null) {
                _currentDraft!.title = value;
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        
        // Image preview (if exists)
        if (_currentDraft?.associatedImageUrl != null) ...[
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_currentDraft!.associatedImageUrl!),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.paper,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 40, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                ),
                // 编辑按钮
                Positioned(
                  top: 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _editImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.olive,
                              AppColors.olive.withValues(alpha: 0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.olive.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.crop_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                // 删除按钮
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _removeImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.white.withValues(alpha: 0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.ribbon.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.close_rounded, size: 18, color: AppColors.ribbon),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Editor
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.paperLight,
                  Colors.white,
                  AppColors.paper.withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.cardBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.olive.withValues(alpha: 0.05),
                  blurRadius: 35,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.ribbon.withValues(alpha: 0.15),
                            AppColors.ribbon.withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.ribbon.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 12,
                            color: AppColors.ribbon,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'DRAFT',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.ribbon,
                              fontFamily: 'serif',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _editorController,
                  maxLength: 5000,
                  maxLines: null,
                  expands: true,
                  style: AppTextStyles.poemContent.copyWith(height: 1.8),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Start your poem here...\n\nThe paper is waiting for your words.\nLet inspiration flow freely.',
                    hintStyle: AppTextStyles.poemContent.copyWith(
                      color: AppColors.textTertiary,
                      height: 1.8,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(right: 80),
                    counterText: '', // 隐藏字符计数器
                  ),
                  onChanged: (value) {
                    if (_currentDraft != null) {
                      _currentDraft!.content = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 网格视图 - 显示所有草稿
  Widget _buildDraftsGridView() {
    if (_drafts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.olive.withValues(alpha: 0.1),
                    AppColors.ribbon.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_note,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Drafts Yet',
              style: AppTextStyles.poemTitle.copyWith(
                fontSize: 20,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Start creating your first poem by tapping the + button',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: _drafts.length,
      itemBuilder: (context, index) {
        final draft = _drafts[index];
        return _buildDraftCard(draft);
      },
    );
  }

  // 草稿卡片
  Widget _buildDraftCard(Draft draft) {
    final isActive = draft.id == _currentDraft?.id;
    
    return GestureDetector(
      onTap: () {
        // 切换到编辑器视图并加载该草稿
        setState(() {
          _isGridView = false;
          _switchDraft(draft);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    Colors.white,
                    AppColors.olive.withValues(alpha: 0.05),
                  ]
                : [
                    Colors.white,
                    AppColors.paperLight.withValues(alpha: 0.5),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.olive.withValues(alpha: 0.3)
                : AppColors.cardBorder.withValues(alpha: 0.5),
            width: isActive ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.olive.withValues(alpha: 0.15)
                  : AppColors.ink.withValues(alpha: 0.08),
              blurRadius: isActive ? 20 : 15,
              offset: Offset(0, isActive ? 8 : 5),
            ),
            BoxShadow(
              color: isActive
                  ? AppColors.olive.withValues(alpha: 0.08)
                  : AppColors.ribbon.withValues(alpha: 0.04),
              blurRadius: isActive ? 30 : 20,
              offset: Offset(0, isActive ? 12 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片或占位符
            if (draft.associatedImageUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.file(
                      File(draft.associatedImageUrl!),
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 110,
                        color: AppColors.paper,
                        child: const Icon(Icons.image, size: 30, color: AppColors.textTertiary),
                      ),
                    ),
                  ),
                  // DRAFT 标签
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.ribbon,
                            AppColors.ribbon.withValues(alpha: 0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ribbon.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'DRAFT',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.paperLight,
                      AppColors.paper.withValues(alpha: 0.8),
                      AppColors.olive.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.olive.withValues(alpha: 0.1),
                              AppColors.olive.withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          size: 32,
                          color: AppColors.olive.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    // DRAFT 标签
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.ribbon,
                              AppColors.ribbon.withValues(alpha: 0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ribbon.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'DRAFT',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // 内容区域
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.title.isEmpty ? 'Untitled Draft' : draft.title,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(draft.lastModified),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        draft.content.isEmpty
                            ? 'Empty draft'
                            : draft.content,
                        style: AppTextStyles.caption.copyWith(
                          fontFamily: 'serif',
                          fontSize: 11,
                          height: 1.4,
                          color: draft.content.isEmpty
                              ? AppColors.textTertiary
                              : AppColors.ink,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.olive.withValues(alpha: 0.12),
                            AppColors.olive.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.olive.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 11,
                            color: AppColors.olive,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tap to edit',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              color: AppColors.olive,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.paperLight.withValues(alpha: 0.6),
            AppColors.paper.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.olive.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Draft selector
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showDraftList = !_showDraftList),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.olive.withValues(alpha: 0.1),
                      AppColors.olive.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.olive.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, size: 16, color: AppColors.olive),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentDraft == null
                            ? 'No Draft'
                            : (_currentDraft!.title.isEmpty
                                ? 'Draft ${_drafts.indexOf(_currentDraft!) + 1}'
                                : _currentDraft!.title),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.olive,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      _showDraftList ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: AppColors.olive,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // View toggle button
          _buildToolbarButton(
            icon: _isGridView ? Icons.edit_note : Icons.grid_view,
            color: AppColors.olive,
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
                _showDraftList = false; // 关闭草稿列表
              });
            },
            tooltip: _isGridView ? 'Editor View' : 'Grid View',
          ),
          
          // New draft button (只在编辑器视图显示)
          if (!_isGridView)
            _buildToolbarButton(
              icon: Icons.add,
              color: AppColors.olive,
              onPressed: _createNewDraft,
              tooltip: 'New Draft',
            ),
          
          // Image picker (只在编辑器视图显示)
          if (!_isGridView)
            _buildToolbarButton(
              icon: Icons.image_outlined,
              color: AppColors.textSecondary,
              onPressed: _pickImage,
              tooltip: 'Add Image',
            ),
          
          // Save button (只在编辑器视图显示)
          if (!_isGridView)
            _buildToolbarButton(
            icon: Icons.save,
            color: AppColors.ribbon,
            onPressed: _saveDraft,
            tooltip: 'Save Draft',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildDraftListOverlay() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppColors.paperLight],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.folder_open, size: 20, color: AppColors.olive),
                  const SizedBox(width: 8),
                  Text(
                    'My Drafts (${_drafts.length})',
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _showDraftList = false),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Draft list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _drafts.length,
                itemBuilder: (context, index) {
                  final draft = _drafts[index];
                  final isActive = draft.id == _currentDraft?.id;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? LinearGradient(
                              colors: [
                                AppColors.olive.withValues(alpha: 0.15),
                                AppColors.olive.withValues(alpha: 0.08),
                              ],
                            )
                          : null,
                      color: isActive ? null : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? AppColors.olive.withValues(alpha: 0.4)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => _switchDraft(draft),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.olive.withValues(alpha: 0.2),
                              AppColors.olive.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description,
                          size: 20,
                          color: AppColors.olive,
                        ),
                      ),
                      title: Text(
                        draft.title.isEmpty ? 'Untitled Draft' : draft.title,
                        style: AppTextStyles.bodyText.copyWith(
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? AppColors.olive : AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        draft.content.isEmpty
                            ? 'Empty draft'
                            : draft.content.split('\n').first,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () => _deleteDraft(draft),
                        color: AppColors.ribbon,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollection() {
    if (_bookmarkedPoems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.olive.withValues(alpha: 0.1),
                    AppColors.ribbon.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border,
                size: 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Collections Yet',
              style: AppTextStyles.poemTitle.copyWith(
                fontSize: 20,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Poems you bookmark from Discovery or Author profiles will appear here',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: _bookmarkedPoems.length,
      itemBuilder: (context, index) {
        final poem = _bookmarkedPoems[index];
        return _buildCollectionCard(poem);
      },
    );
  }

  Widget _buildCollectionCard(Poem poem) {
    return GestureDetector(
      onTap: () {
        PoemDetailDialog.show(context, poem);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.white.withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: AppColors.ribbon.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (poem.imageUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Stack(
                      children: [
                        poem.imageUrl!.startsWith('assets/')
                            ? Image.asset(
                                poem.imageUrl!,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 110,
                                  color: AppColors.paper,
                                  child: const Icon(Icons.image, size: 30, color: AppColors.textTertiary),
                                ),
                              )
                            : Image.network(
                                poem.imageUrl!,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 110,
                                  color: AppColors.paper,
                                  child: const Icon(Icons.image, size: 30, color: AppColors.textTertiary),
                                ),
                              ),
                        Container(
                          height: 110,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _removeBookmark(poem),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.95),
                              Colors.white.withValues(alpha: 0.85),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bookmark,
                          color: AppColors.ribbon,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poem.title,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${poem.authorName}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        poem.content,
                        style: AppTextStyles.caption.copyWith(
                          fontFamily: 'serif',
                          fontSize: 11,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          '${poem.likes}',
                          style: AppTextStyles.caption.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _editorController.dispose();
    super.dispose();
  }
}
