import 'package:flutter/material.dart';
import 'package:soli/core/constants/app_constants.dart';
import 'package:soli/core/theme/app_theme.dart';
import 'package:soli/core/utils/animations.dart';
import 'package:soli/core/utils/color_utils.dart';
import 'package:soli/core/utils/page_transitions.dart';
import 'package:soli/data/datasources/shared_memories_data.dart';
import 'package:soli/data/models/memory_model.dart';
import 'package:soli/data/models/shared_memory_model.dart';
import 'package:soli/data/repositories/memory_repository.dart';
import 'package:soli/presentation/screens/add_memory_screen.dart';
import 'dart:io';
import 'package:soli/presentation/screens/search_screen.dart';
import 'package:intl/intl.dart';
import 'package:soli/presentation/widgets/shared_memory_card.dart';
import 'package:soli/presentation/widgets/tag_chip.dart';

/// 回忆艺术馆页面
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0; // 0: Inspiration, 1: My Memories
  int _selectedTagIndex = 0;
  final MemoryRepository _memoryRepository = MemoryRepository();
  List<MemoryModel> _memories = [];
  List<SharedMemoryModel> _sharedMemories = [];
  Map<String, bool> _pendingLikeStates = {}; // 临时存储点赞状态，用于立即反馈
  bool _isLoading = true;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // 保持页面状态

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadMemories();
    // 异步加载共享回忆，包含持久化的点赞状态
    _initializeSharedMemories();
  }

  // 初始化共享回忆
  Future<void> _initializeSharedMemories() async {
    // 初始化默认点赞数到存储
    await SharedMemoriesData.initializeDefaultLikeCounts();
    // 加载共享回忆（包含持久化的点赞状态和点赞数）
    await _loadSharedMemories();
  }

  // 加载分享的回忆
  Future<void> _loadSharedMemories() async {
    // 从数据源加载分享的回忆，包含持久化的点赞状态
    _sharedMemories = await SharedMemoriesData.getSharedMemories();
    // 清空临时点赞状态
    _pendingLikeStates.clear();

    // 确保UI更新
    if (mounted) {
      setState(() {});
    }
  }

  // 获取点赞状态（考虑临时状态）
  bool _getLikeState(SharedMemoryModel memory) {
    // 如果存在临时状态，返回临时状态
    if (_pendingLikeStates.containsKey(memory.id)) {
      return _pendingLikeStates[memory.id]!;
    }
    // 否则返回实际状态
    return memory.isLiked;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    }
  }

  // 加载回忆数据
  Future<void> _loadMemories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedTagIndex == 0) {
        // 加载所有回忆
        _memories = await _memoryRepository.getAllMemories();
      } else {
        // 按标签筛选
        _memories = await _memoryRepository.getMemoriesByTag(
          AppConstants.memoryTags[_selectedTagIndex],
        );
      }
    } catch (e) {
      // 处理错误
      _memories = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 导航到添加回忆页面
  Future<void> _navigateToAddMemory() async {
    final result = await Navigator.push(
      context,
      PageTransitions.slideTransition(
        page: const AddMemoryScreen(),
        direction: SlideDirection.up,
      ),
    );

    if (result == true) {
      _loadMemories();
    }
  }

  // 导航到搜索页面
  void _navigateToSearch() {
    Navigator.push(
      context,
      PageTransitions.fadeTransition(page: const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用 super.build

    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 150.0,
              floating: true,
              pinned: true,
              backgroundColor: AppTheme.deepSpace,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppConstants.titleGallery,
                  style: const TextStyle(
                    color: AppTheme.moonlight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 60),
                expandedTitleScale: 1.3,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: AppTheme.champagne,
                    size: 28,
                  ),
                  onPressed: _navigateToSearch,
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.champagne,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppTheme.champagne,
                  unselectedLabelColor: ColorUtils.withOpacity(
                    AppTheme.moonlight,
                    0.7,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'Inspiration'),
                    Tab(text: 'My Memories'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [_buildSharedMemoriesSection(), _buildMyMemoriesSection()],
        ),
      ),
      // 添加浮动按钮（只在"我的回忆"标签页显示）
      floatingActionButton: _selectedTabIndex == 1
          ? Animations.fadeSlideIn(
              delay: 300,
              slideBegin: const Offset(0, 1),
              child: FloatingActionButton.extended(
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
                onPressed: _navigateToAddMemory,
                icon: const Icon(Icons.add),
                label: const Text('New Memory'),
                elevation: 4,
              ),
            )
          : null,
    );
  }

  // 构建网友分享板块
  Widget _buildSharedMemoriesSection() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _sharedMemories.length,
      itemBuilder: (context, index) {
        return Animations.fadeSlideIn(
          delay: 100 + (index * 50),
          slideBegin: const Offset(0.0, 0.3),
          child: SharedMemoryCard(
            sharedMemory: _sharedMemories[index],
            onTap: () {
              // 可以添加点击事件，例如显示详情对话框
              _showSharedMemoryDetails(_sharedMemories[index]);
            },
          ),
        );
      },
    );
  }

  // 显示网友分享详情
  void _showSharedMemoryDetails(SharedMemoryModel sharedMemory) {
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
                        Image.asset(sharedMemory.imageAsset, fit: BoxFit.cover),
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
                          sharedMemory.title,
                          style: const TextStyle(
                            color: AppTheme.moonlight,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 作者和点赞
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
                                Icons.person,
                                color: AppTheme.champagne,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              sharedMemory.author,
                              style: TextStyle(
                                color: ColorUtils.withOpacity(
                                  AppTheme.moonlight,
                                  0.9,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorUtils.withOpacity(
                                  AppTheme.coral,
                                  0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: AppTheme.coral,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${sharedMemory.likeCount}',
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
                        const SizedBox(height: 32),

                        // 内容
                        Text(
                          sharedMemory.content,
                          style: const TextStyle(
                            color: AppTheme.moonlight,
                            fontSize: 17,
                            height: 1.8,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // 点赞按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // 找到对应的共享回忆
                              final index = _sharedMemories.indexWhere(
                                (m) => m.id == sharedMemory.id,
                              );

                              if (index != -1) {
                                // 先创建新状态，但不立即更新共享回忆对象
                                bool newIsLiked = !sharedMemory.isLiked;
                                int newLikeCount = sharedMemory.likeCount;
                                if (newIsLiked) {
                                  // 如果点赞，增加点赞数
                                  newLikeCount += 1;
                                } else {
                                  // 如果取消点赞，减少点赞数
                                  newLikeCount -= 1;
                                }

                                // 更新临时状态，立即反馈UI变化
                                setState(() {
                                  _pendingLikeStates[sharedMemory.id] =
                                      newIsLiked;
                                });

                                // 关闭抽屉
                                Navigator.of(context).pop();

                                // 立即显示提示，使用新状态
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          newIsLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: newIsLiked
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.9),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          newIsLiked
                                              ? 'You liked this memory'
                                              : 'You unliked this memory',
                                          style: TextStyle(
                                            fontWeight: newIsLiked
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: newIsLiked
                                        ? AppTheme.coral
                                        : AppTheme.champagne,
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                  ),
                                );

                                // 延迟更新共享回忆对象，模拟网络请求
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () async {
                                    if (mounted) {
                                      // 更新共享回忆
                                      final updatedMemory =
                                          _sharedMemories[index].copyWith(
                                            isLiked: newIsLiked,
                                            likeCount: newLikeCount,
                                          );

                                      // 保存点赞状态和点赞数到持久存储
                                      await SharedMemoriesData.updateLikeStatus(
                                        sharedMemory.id,
                                        newIsLiked,
                                        newLikeCount,
                                      );

                                      if (mounted) {
                                        setState(() {
                                          // 更新内存中的共享回忆
                                          _sharedMemories[index] =
                                              updatedMemory;

                                          // 清除临时状态，现在使用实际状态
                                          _pendingLikeStates.remove(
                                            sharedMemory.id,
                                          );
                                        });
                                      }
                                    }
                                  },
                                );
                              }
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    // 使用组合动画：缩放 + 旋转 + 弹性效果
                                    return ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.elasticOut,
                                      ),
                                      child: RotationTransition(
                                        turns:
                                            Tween<double>(
                                              begin: 0.8,
                                              end: 1.0,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.elasticOut,
                                              ),
                                            ),
                                        child: child,
                                      ),
                                    );
                                  },
                              child: Icon(
                                _getLikeState(sharedMemory)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey<bool>(
                                  _getLikeState(sharedMemory),
                                ),
                                size: _getLikeState(sharedMemory) ? 24 : 20,
                                color: _getLikeState(sharedMemory)
                                    ? Colors.white
                                    : AppTheme.deepSpace,
                              ),
                            ),
                            label: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 0.3),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                              child: Text(
                                _getLikeState(sharedMemory) ? 'Liked' : 'Like',
                                key: ValueKey<bool>(
                                  _getLikeState(sharedMemory),
                                ),
                                style: TextStyle(
                                  fontWeight: _getLikeState(sharedMemory)
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontSize: _getLikeState(sharedMemory)
                                      ? 17
                                      : 16,
                                  letterSpacing: _getLikeState(sharedMemory)
                                      ? 0.5
                                      : 0.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getLikeState(sharedMemory)
                                  ? AppTheme.coral
                                  : AppTheme.champagne,
                              foregroundColor: _getLikeState(sharedMemory)
                                  ? Colors.white
                                  : AppTheme.deepSpace,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: _getLikeState(sharedMemory) ? 4 : 2,
                              shadowColor: _getLikeState(sharedMemory)
                                  ? AppTheme.coral.withOpacity(0.6)
                                  : AppTheme.champagne.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: _getLikeState(sharedMemory)
                                    ? BorderSide(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      )
                                    : BorderSide.none,
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 构建我的回忆板块
  Widget _buildMyMemoriesSection() {
    return Column(
      children: [
        // 标签过滤器
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _buildTagFilter(),
        ),

        // 回忆列表
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.champagne),
                )
              : _buildMemoryList(),
        ),
      ],
    );
  }

  // 构建标签过滤器
  Widget _buildTagFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          AppConstants.memoryTags.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TagChip(
              label: AppConstants.memoryTags[index],
              isSelected: _selectedTagIndex == index,
              onTap: () {
                setState(() {
                  _selectedTagIndex = index;
                });
                _loadMemories();
              },
            ),
          ),
        ),
      ),
    );
  }

  // 构建回忆列表
  Widget _buildMemoryList() {
    if (_memories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        return Animations.fadeSlideIn(
          delay: 150 + (index * 50),
          slideBegin: const Offset(0.0, 0.3),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: AppTheme.silverstone,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                _showMemoryDetails(_memories[index]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图片
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _isLocalImage(_memories[index])
                          ? Image.file(
                              File(_memories[index].imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.silverstone,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppTheme.moonlight,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.network(
                              _memories[index].imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.silverstone,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppTheme.moonlight,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  // 内容
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _memories[index].title,
                          style: const TextStyle(
                            color: AppTheme.moonlight,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_memories[index].tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _memories[index].tags
                                .map((tag) => TagChip(label: tag))
                                .toList(),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            'MMMM dd, yyyy',
                          ).format(_memories[index].date),
                          style: TextStyle(
                            color: ColorUtils.withOpacity(
                              AppTheme.moonlight,
                              0.7,
                            ),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            'Confirm Delete',
            style: TextStyle(
              color: AppTheme.moonlight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this memory? This action cannot be undone.',
            style: TextStyle(color: AppTheme.moonlight),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
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
                  // 刷新列表
                  _loadMemories();

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
                                'Label',
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
                                'Description',
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

                        // 删除按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteConfirmation(context, memory);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete memories'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.coral,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorUtils.withOpacity(AppTheme.silverstone, 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_album,
              size: 60,
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedTagIndex == 0
                ? 'No memories yet. Tap + to add your first memory.'
                : 'No memories in this category yet.',
            style: TextStyle(
              color: ColorUtils.withOpacity(AppTheme.moonlight, 0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (_selectedTagIndex == 0)
            ElevatedButton.icon(
              onPressed: _navigateToAddMemory,
              icon: const Icon(Icons.add),
              label: const Text('Add Memory'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.champagne,
                foregroundColor: AppTheme.deepSpace,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
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
        ],
      ),
    );
  }
}
