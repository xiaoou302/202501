import 'package:flutter/material.dart';
import '../../core/models/chapter_model.dart';
import '../../core/models/user_stats_model.dart';
import '../../data/repositories/chapter_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/local/storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/chapter_card.dart';
import 'codex_screen.dart';

/// Library screen - Chapter selection
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late ChapterRepository _chapterRepository;
  late UserRepository _userRepository;
  List<Chapter> _chapters = [];
  UserStats _userStats = const UserStats();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
  }

  Future<void> _initializeRepositories() async {
    final storage = await StorageService.init();
    _userRepository = UserRepository(storage);
    _chapterRepository = ChapterRepository();

    final userStats = _userRepository.getUserStats();
    final allChapters = _chapterRepository.getAllChapters();

    // 动态设置章节解锁状态
    final unlockedChapters = _getUnlockedChapters(allChapters, userStats);

    setState(() {
      _chapters = unlockedChapters;
      _userStats = userStats;
      _isLoading = false;
    });
  }

  /// 根据用户进度解锁章节
  List<Chapter> _getUnlockedChapters(
    List<Chapter> chapters,
    UserStats userStats,
  ) {
    return chapters.map((chapter) {
      // 第一章默认解锁
      if (chapter.id == 1) {
        return chapter.copyWith(isUnlocked: true);
      }

      // 检查上一章是否完美通关
      final previousChapterProgress = userStats.chapterProgress[chapter.id - 1];
      final isPreviousCompleted = previousChapterProgress?.isCompleted ?? false;

      return chapter.copyWith(isUnlocked: isPreviousCompleted);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgLight, AppColors.bgMedium],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: AppColors.textDark.withOpacity(0.7),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The Library',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose a memory to restore.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textDark.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Chapter list
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = _chapters[index];
                          final progress =
                              _userStats.chapterProgress[chapter.id];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ChapterCard(
                              chapter: chapter,
                              progress: progress,
                              onTap: () {
                                _navigateToCodex(chapter);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCodex(Chapter chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CodexScreen(chapter: chapter)),
    ).then((_) {
      // Refresh stats and unlock status when returning from game
      final userStats = _userRepository.getUserStats();
      final allChapters = _chapterRepository.getAllChapters();
      final unlockedChapters = _getUnlockedChapters(allChapters, userStats);

      setState(() {
        _chapters = unlockedChapters;
        _userStats = userStats;
      });
    });
  }
}
