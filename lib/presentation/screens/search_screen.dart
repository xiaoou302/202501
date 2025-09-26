import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/data/repositories/memory_repository.dart';
import 'dart:io';
import 'package:soli/presentation/widgets/memory_card.dart';
import 'package:soli/presentation/widgets/tag_chip.dart';
import 'package:intl/intl.dart';

/// 搜索页面
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MemoryRepository _memoryRepository = MemoryRepository();

  List<MemoryModel> _allMemories = [];
  List<MemoryModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadAllMemories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 加载所有回忆
  Future<void> _loadAllMemories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _allMemories = await _memoryRepository.getAllMemories();
    } catch (e) {
      // 处理错误
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 执行搜索
  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    setState(() {
      _searchResults = _allMemories.where((memory) {
        final titleMatch = memory.title.toLowerCase().contains(lowercaseQuery);
        final descMatch =
            memory.description?.toLowerCase().contains(lowercaseQuery) ?? false;
        final tagMatch = memory.tags.any(
          (tag) => tag.toLowerCase().contains(lowercaseQuery),
        );

        return titleMatch || descMatch || tagMatch;
      }).toList();
      _hasSearched = true;
    });
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
          title: const Text('Search memories'),
          foregroundColor: AppTheme.moonlight,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 搜索框
              _buildSearchBox(),
              const SizedBox(height: 20),

              // 搜索结果
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.champagne,
                        ),
                      )
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建搜索框
  Widget _buildSearchBox() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: AppTheme.moonlight),
      decoration: InputDecoration(
        hintText: 'Search title, description or label...',
        hintStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.5),
        ),
        prefixIcon: const Icon(Icons.search, color: AppTheme.champagne),
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
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppTheme.moonlight),
                onPressed: () {
                  _searchController.clear();
                  _performSearch('');
                },
              )
            : null,
        counterText: '${_searchController.text.length}/50',
        counterStyle: TextStyle(
          color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
          fontSize: 12,
        ),
      ),
      onChanged: _performSearch,
      autofocus: true,
      maxLength: 50, // 设置最大输入长度为50个字符
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textInputAction: TextInputAction.search, // 设置键盘搜索按钮
      onSubmitted: _performSearch, // 点击搜索按钮时执行搜索
    );
  }

  // 构建搜索结果
  Widget _buildSearchResults() {
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 60,
              color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter keywords to start searching',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: 60,
              color: ColorUtils.withOpacity(AppTheme.silverstone, 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              '没有找到匹配的回忆',
              style: TextStyle(
                color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return Animations.fadeSlideIn(
          delay: 100 + (index * 50),
          slideBegin: const Offset(0.0, 0.3),
          child: MemoryCard(
            memory: _searchResults[index],
            onTap: () {
              _showMemoryDetails(_searchResults[index]);
            },
          ),
        );
      },
    );
  }

  // 检查图片是否是本地路径
  bool _isLocalImage(MemoryModel memory) {
    return !memory.imageUrl.startsWith('http');
  }

  // 显示删除确认对话框
  void _showDeleteConfirmation(BuildContext context, MemoryModel memory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.deepSpace,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '确认删除',
            style: TextStyle(
              color: AppTheme.moonlight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '您确定要删除这条回忆吗？此操作无法撤销。',
            style: TextStyle(color: AppTheme.moonlight),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '取消',
                style: TextStyle(color: AppTheme.champagne),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.coral,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                // 关闭对话框
                Navigator.of(context).pop();
                // 关闭详情抽屉
                Navigator.of(context).pop();

                try {
                  // 删除回忆
                  await _memoryRepository.deleteMemory(memory.id);
                  // 重新加载所有回忆
                  _loadAllMemories();
                  // 重新执行搜索以更新结果
                  _performSearch(_searchController.text);

                  if (!mounted) return;

                  // 显示成功提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Memory has been successfully deleted'),
                      backgroundColor: AppTheme.champagne,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  // 显示错误提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete, please try again'),
                      backgroundColor: AppTheme.coral,
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // 显示回忆详情
  void _showMemoryDetails(MemoryModel memory) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.deepSpace,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部拖动条
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorUtils.withOpacity(AppTheme.moonlight, 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // 图片
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _isLocalImage(memory)
                            ? Image.file(
                                File(memory.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : Image.network(memory.imageUrl, fit: BoxFit.cover),
                        // 渐变遮罩
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                ColorUtils.withOpacity(AppTheme.deepSpace, 0.8),
                              ],
                            ),
                          ),
                        ),
                        // 关闭按钮
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ColorUtils.withOpacity(
                                  AppTheme.deepSpace,
                                  0.7,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppTheme.moonlight,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 内容
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Text(
                          memory.title,
                          style: const TextStyle(
                            color: AppTheme.moonlight,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 日期
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorUtils.withOpacity(
                                  AppTheme.champagne,
                                  0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: AppTheme.champagne,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('MMMM dd, yyyy').format(memory.date),

                              style: TextStyle(
                                color: ColorUtils.withOpacity(
                                  AppTheme.moonlight,
                                  0.9,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 标签
                        if (memory.tags.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '标签',
                                style: TextStyle(
                                  color: AppTheme.champagne,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: memory.tags
                                    .map((tag) => TagChip(label: tag))
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),

                        // 描述
                        if (memory.description != null &&
                            memory.description!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '描述',
                                style: TextStyle(
                                  color: AppTheme.champagne,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                memory.description!,
                                style: const TextStyle(
                                  color: AppTheme.moonlight,
                                  fontSize: 17,
                                  height: 1.8,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),

                        // 操作按钮组
                        Row(
                          children: [
                            // 返回按钮
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Return to search'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.champagne,
                                  side: const BorderSide(
                                    color: AppTheme.champagne,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 删除按钮
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showDeleteConfirmation(context, memory);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('删除'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.coral,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
