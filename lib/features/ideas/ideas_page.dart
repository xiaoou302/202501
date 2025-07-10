import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/dynamic_island.dart';
import '../../data/models/idea_model.dart';
import '../../data/repositories/idea_repository.dart';
import 'idea_card.dart';

/// 灵感记录页面
class IdeasPage extends StatefulWidget {
  const IdeasPage({Key? key}) : super(key: key);

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  final List<IdeaModel> _ideas = [];
  final TextEditingController _searchController = TextEditingController();
  DynamicIslandController? _dynamicIslandController;
  final _uuid = const Uuid();
  bool _isLoading = false;
  String? _selectedTag;
  late IdeaRepository _ideaRepository;

  final List<String> _availableTags = [
    'Fantasy',
    'Sci-Fi',
    'Adventure',
    'Modern',
    'Mystery',
    'Ocean',
    'Supernatural',
    'Epic',
  ];

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final prefs = await SharedPreferences.getInstance();
    _ideaRepository = IdeaRepository(prefs);
    _loadIdeas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dynamicIslandController = DynamicIslandController(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dynamicIslandController?.dispose();
    super.dispose();
  }

  Future<void> _loadIdeas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ideas = await _ideaRepository.getAllIdeas();
      setState(() {
        _ideas.clear();
        _ideas.addAll(ideas);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading ideas: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load ideas');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _updateIdea(IdeaModel idea) async {
    try {
      final success = await _ideaRepository.updateIdea(idea);
      if (success) {
        final index = _ideas.indexWhere((e) => e.id == idea.id);
        if (index != -1) {
          setState(() {
            _ideas[index] = idea;
          });
          _dynamicIslandController?.show(
            message: 'Idea updated',
            icon: Icons.check_circle,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        _showErrorSnackBar('Failed to update idea');
      }
    } catch (e) {
      print('Error updating idea: $e');
      _showErrorSnackBar('Failed to update idea');
    }
  }

  Future<void> _deleteIdea(String id) async {
    final index = _ideas.indexWhere((idea) => idea.id == id);
    if (index == -1) return;

    final deletedIdea = _ideas[index];
    setState(() {
      _ideas.removeAt(index);
    });

    try {
      final success = await _ideaRepository.deleteIdea(id);
      if (!success) {
        // 恢复删除的灵感
        setState(() {
          _ideas.insert(index, deletedIdea);
        });
        _showErrorSnackBar('Failed to delete idea');
      } else {
        _dynamicIslandController?.show(
          message: 'Idea deleted',
          icon: Icons.delete,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error deleting idea: $e');
      // 恢复删除的灵感
      setState(() {
        _ideas.insert(index, deletedIdea);
      });
      _showErrorSnackBar('Failed to delete idea');
    }
  }

  Future<void> _addIdea(IdeaModel idea) async {
    try {
      final success = await _ideaRepository.addIdea(idea);
      if (success) {
        setState(() {
          _ideas.insert(0, idea);
        });
        _dynamicIslandController?.show(
          message: 'Idea added',
          icon: Icons.lightbulb,
          duration: const Duration(seconds: 2),
        );
      } else {
        _showErrorSnackBar('Failed to add idea');
      }
    } catch (e) {
      print('Error adding idea: $e');
      _showErrorSnackBar('Failed to add idea');
    }
  }

  void _showAddIdeaDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController chapterTitleController =
        TextEditingController(text: 'Chapter 1');
    final TextEditingController contentController = TextEditingController();
    final List<String> selectedTags = [];
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: AppColors.deepBlue,
            title: Text(
              'Add New Idea',
              style: AppStyles.buttonText.copyWith(
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration:
                        AppStyles.inputDecoration('Story Title (max 30 chars)'),
                    style: AppStyles.bodyText,
                    maxLength: 30,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: chapterTitleController,
                    decoration: AppStyles.inputDecoration(
                        'Chapter Title (max 20 chars)'),
                    style: AppStyles.bodyText,
                    maxLength: 20,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    decoration: AppStyles.inputDecoration(
                        'Chapter Content (max 2000 chars)'),
                    style: AppStyles.bodyText,
                    maxLength: 2000,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Tags', style: AppStyles.bodyText),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: _availableTags.map((tag) {
                      final isSelected = selectedTags.contains(tag);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTags.remove(tag);
                              } else {
                                selectedTags.add(tag);
                              }
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 16 : 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accentPurple.withOpacity(0.2)
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 16 : 20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accentPurple
                                    : Colors.white.withOpacity(0.3),
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accentPurple
                                            .withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.local_offer,
                                  size: isSmallScreen ? 14 : 16,
                                  color: isSelected
                                      ? AppColors.accentPurple
                                      : Colors.white.withOpacity(0.7),
                                ),
                                SizedBox(width: isSmallScreen ? 4 : 6),
                                Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: isSelected
                                        ? AppColors.accentPurple
                                        : Colors.white.withOpacity(0.9),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppStyles.buttonText.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter story title')),
                    );
                    return;
                  }

                  if (chapterTitleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter chapter title')),
                    );
                    return;
                  }

                  if (contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter chapter content')),
                    );
                    return;
                  }

                  if (selectedTags.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select at least one tag')),
                    );
                    return;
                  }

                  final chapter = ChapterModel(
                    title: chapterTitleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  );

                  final newIdea = IdeaModel(
                    id: _uuid.v4(),
                    title: titleController.text,
                    chapters: [chapter],
                    tags: selectedTags,
                    createdAt: DateTime.now(),
                  );

                  _addIdea(newIdea);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.paddingLarge,
                    vertical: AppStyles.paddingSmall,
                  ),
                ),
                child: Text(
                  'Add',
                  style: AppStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(IdeaModel idea) {
    final TextEditingController chapterTitleController = TextEditingController(
      text: 'Chapter ${idea.chapterCount + 1}',
    );
    final TextEditingController contentController = TextEditingController();
    final List<String> selectedTags = List.from(idea.tags);
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: AppColors.deepBlue,
            title: Text(
              'Write New Chapter',
              style: AppStyles.buttonText.copyWith(
                color: Colors.white,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 显示原内容
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                          BorderRadius.circular(AppStyles.borderRadiusSmall),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Chapter: ${idea.latestChapter?.title ?? ""}',
                          style: AppStyles.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          idea.latestChapter?.content ?? "",
                          style: AppStyles.bodyText.copyWith(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: chapterTitleController,
                    decoration: AppStyles.inputDecoration(
                        'Chapter Title (max 20 chars)'),
                    style: AppStyles.bodyText,
                    maxLength: 20,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    decoration: AppStyles.inputDecoration(
                        'Chapter Content (max 2000 chars)'),
                    style: AppStyles.bodyText,
                    maxLength: 2000,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  const Text('Tags', style: AppStyles.bodyText),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 6 : 8,
                    children: _availableTags.map((tag) {
                      final isSelected = selectedTags.contains(tag);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTags.remove(tag);
                              } else {
                                selectedTags.add(tag);
                              }
                            });
                          },
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 16 : 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accentPurple.withOpacity(0.2)
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 16 : 20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.accentPurple
                                    : Colors.white.withOpacity(0.3),
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accentPurple
                                            .withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.local_offer,
                                  size: isSmallScreen ? 14 : 16,
                                  color: isSelected
                                      ? AppColors.accentPurple
                                      : Colors.white.withOpacity(0.7),
                                ),
                                SizedBox(width: isSmallScreen ? 4 : 6),
                                Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: isSelected
                                        ? AppColors.accentPurple
                                        : Colors.white.withOpacity(0.9),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppStyles.buttonText.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (chapterTitleController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter chapter title')),
                    );
                    return;
                  }

                  if (contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter chapter content')),
                    );
                    return;
                  }

                  final newChapter = ChapterModel(
                    title: chapterTitleController.text,
                    content: contentController.text,
                    createdAt: DateTime.now(),
                  );

                  final updatedIdea = idea.addChapter(newChapter);
                  _updateIdea(updatedIdea);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.paddingLarge,
                    vertical: AppStyles.paddingSmall,
                  ),
                ),
                child: Text(
                  'Save',
                  style: AppStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<IdeaModel> _getFilteredIdeas() {
    if (_searchController.text.isEmpty && _selectedTag == null) {
      return _ideas;
    }

    return _ideas.where((idea) {
      bool matchesSearch = _searchController.text.isEmpty ||
          idea.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          idea.chapters.any((chapter) => chapter.content
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()));

      bool matchesTag =
          _selectedTag == null || idea.tags.contains(_selectedTag);

      return matchesSearch && matchesTag;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredIdeas = _getFilteredIdeas();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                Padding(
                  padding: const EdgeInsets.all(AppStyles.paddingMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Story Ideas', style: AppStyles.heading2),
                      IconButton(
                        onPressed: _showFilterDialog,
                        icon: Icon(
                          Icons.filter_list,
                          color: _selectedTag != null
                              ? AppColors.accentPurple
                              : AppColors.textPrimary,
                          size: AppStyles.iconSizeMedium,
                        ),
                        tooltip: 'Filter',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.paddingMedium,
                    vertical: AppStyles.paddingSmall,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ideas...',
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.white54),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Colors.white54),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusMedium),
                        borderSide: BorderSide(color: AppColors.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusMedium),
                        borderSide: BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppStyles.borderRadiusMedium),
                        borderSide: const BorderSide(
                          color: AppColors.accentPurple,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.paddingMedium,
                        vertical: AppStyles.paddingSmall,
                      ),
                    ),
                    style: AppStyles.bodyText,
                    maxLength: 50,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                if (_selectedTag != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppStyles.paddingMedium,
                      vertical: AppStyles.paddingSmall,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppStyles.paddingMedium,
                            vertical: AppStyles.paddingSmall,
                          ),
                          decoration:
                              AppStyles.tagDecoration(AppColors.accentPurple),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedTag!,
                                style: AppStyles.bodyTextSmall.copyWith(
                                  color: AppColors.accentPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: AppStyles.paddingTiny),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTag = null;
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: AppStyles.iconSizeSmall,
                                  color: AppColors.accentPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentPurple,
                          ),
                        )
                      : filteredIdeas.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.all(AppStyles.paddingMedium),
                              itemCount: filteredIdeas.length,
                              itemBuilder: (context, index) {
                                return IdeaCard(
                                  idea: filteredIdeas[index],
                                  onDelete: _deleteIdea,
                                  onEdit: _showEditDialog,
                                  onTagTap: (tag) {
                                    setState(() {
                                      _selectedTag = tag;
                                    });
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddIdeaDialog,
          backgroundColor: AppColors.accentPurple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final bool isSearching =
        _searchController.text.isNotEmpty || _selectedTag != null;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSearching) ...[
              // 搜索无结果状态
              Container(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: AppStyles.iconSizeLarge * 2,
                  color: AppColors.accentPurple.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              Text(
                'No Matching Ideas Found',
                style: AppStyles.heading3.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              Text(
                _selectedTag != null
                    ? 'No ideas found with the tag "$_selectedTag"'
                    : 'No ideas match your search "${_searchController.text}"',
                style: AppStyles.bodyText.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedTag != null)
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedTag = null;
                        });
                      },
                      icon: const Icon(Icons.filter_list_off),
                      label: const Text('Clear Filter'),
                      style: AppStyles.outlinedButtonStyle,
                    ),
                  if (_searchController.text.isNotEmpty) ...[
                    if (_selectedTag != null)
                      const SizedBox(width: AppStyles.paddingMedium),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Search'),
                      style: AppStyles.outlinedButtonStyle,
                    ),
                  ],
                ],
              ),
            ] else ...[
              // 完全空状态
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accentPurple.withOpacity(0.2),
                          AppColors.accentPurple.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppStyles.paddingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: AppStyles.iconSizeLarge * 2,
                      color: AppColors.accentPurple.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              Text(
                'Start Your Creative Journey',
                style: AppStyles.heading3.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppStyles.paddingMedium),
              Text(
                'Capture your story ideas and watch them grow chapter by chapter',
                style: AppStyles.bodyText.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              Container(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppStyles.borderRadiusMedium),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      icon: Icons.edit_note,
                      title: 'Write Your Story',
                      description:
                          'Start with a compelling title and first chapter',
                    ),
                    const SizedBox(height: AppStyles.paddingMedium),
                    _buildFeatureItem(
                      icon: Icons.local_offer,
                      title: 'Add Tags',
                      description: 'Organize your ideas with relevant tags',
                    ),
                    const SizedBox(height: AppStyles.paddingMedium),
                    _buildFeatureItem(
                      icon: Icons.history_edu,
                      title: 'Continue Writing',
                      description: 'Add new chapters as your story develops',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              ElevatedButton.icon(
                onPressed: _showAddIdeaDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Your First Story'),
                style: AppStyles.primaryButtonStyle.copyWith(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: AppStyles.paddingXLarge,
                      vertical: AppStyles.paddingMedium,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppStyles.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.accentPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.accentPurple,
            size: AppStyles.iconSizeMedium,
          ),
        ),
        const SizedBox(width: AppStyles.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.bodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                description,
                style: AppStyles.bodyTextSmall.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepBlue,
        title: const Text('Filter by Tag'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: isSmallScreen ? 6 : 8,
                runSpacing: isSmallScreen ? 6 : 8,
                children: [
                  ..._availableTags.map((tag) {
                    final isSelected = tag == _selectedTag;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _selectedTag = isSelected ? null : tag;
                          });
                        },
                        borderRadius:
                            BorderRadius.circular(isSmallScreen ? 16 : 20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 8 : 10,
                            vertical: isSmallScreen ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accentPurple.withOpacity(0.2)
                                : Colors.black12,
                            borderRadius:
                                BorderRadius.circular(isSmallScreen ? 16 : 20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentPurple
                                  : Colors.white.withOpacity(0.3),
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.accentPurple
                                          .withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.local_offer,
                                size: isSmallScreen ? 14 : 16,
                                color: isSelected
                                    ? AppColors.accentPurple
                                    : Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(width: isSmallScreen ? 4 : 6),
                              Text(
                                tag,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  color: isSelected
                                      ? AppColors.accentPurple
                                      : Colors.white.withOpacity(0.9),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  // All tags option
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _selectedTag = null;
                        });
                      },
                      borderRadius:
                          BorderRadius.circular(isSmallScreen ? 16 : 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 10,
                          vertical: isSmallScreen ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTag == null
                              ? AppColors.accentGreen.withOpacity(0.2)
                              : Colors.black12,
                          borderRadius:
                              BorderRadius.circular(isSmallScreen ? 16 : 20),
                          border: Border.all(
                            color: _selectedTag == null
                                ? AppColors.accentGreen
                                : Colors.white.withOpacity(0.3),
                            width: _selectedTag == null ? 1.5 : 1,
                          ),
                          boxShadow: _selectedTag == null
                              ? [
                                  BoxShadow(
                                    color:
                                        AppColors.accentGreen.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectedTag == null
                                  ? Icons.check_circle
                                  : Icons.filter_list,
                              size: isSmallScreen ? 14 : 16,
                              color: _selectedTag == null
                                  ? AppColors.accentGreen
                                  : Colors.white.withOpacity(0.7),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Text(
                              'All Tags',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: _selectedTag == null
                                    ? AppColors.accentGreen
                                    : Colors.white.withOpacity(0.9),
                                fontWeight: _selectedTag == null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.paddingLarge,
                vertical: AppStyles.paddingSmall,
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
