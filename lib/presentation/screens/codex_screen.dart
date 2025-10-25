import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/chapter_model.dart';
import '../../core/models/user_stats_model.dart';
import '../../core/models/game_state_model.dart';
import '../../core/services/game_service.dart';
import '../../core/utils/text_parser.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/chapter_repository.dart';
import '../../data/local/storage_service.dart';
import '../theme/app_colors.dart';

/// Codex screen - Main gameplay with glow and drag mechanics
class CodexScreen extends StatefulWidget {
  final Chapter chapter;

  const CodexScreen({super.key, required this.chapter});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  late GameService _gameService;
  late UserRepository _userRepository;
  late List<ParsedWord> _parsedWords;
  bool _isInitialized = false;
  final Map<int, TextEditingController> _inputControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final storage = await StorageService.init();
    _userRepository = UserRepository(storage);
    _parsedWords = TextParser.parseText(widget.chapter.content);

    print('=== Game Initialization Debug ===');
    print('Chapter content: ${widget.chapter.content}');
    print('Total parsed words: ${_parsedWords.length}');
    print('Keywords: ${widget.chapter.keywords}');
    for (int i = 0; i < _parsedWords.length; i++) {
      final word = _parsedWords[i];
      print('Position $i: "${word.text}" (isKeyword: ${word.isKeyword})');
    }
    print('================================');

    _gameService = GameService(
      onStateChanged: (state) {
        if (mounted) {
          setState(() {});

          // Check if glowing is complete and move to reconstruction
          if (state.phase == GamePhase.glowingPhase &&
              state.isGlowingComplete) {
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted &&
                  _gameService.gameState.phase == GamePhase.glowingPhase) {
                setState(() {}); // Will show reconstruction phase
              }
            });
          }
        }
      },
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _gameService.dispose();
    _inputControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _startGame() {
    _gameService.startGame(widget.chapter);
  }

  void _handleWordTap(int position) {
    print('=== Word Tap Debug ===');
    print('Tapped position: $position');
    print('Current phase: ${_gameService.gameState.phase}');
    print(
      'Current glowing position: ${_gameService.gameState.currentGlowingPosition}',
    );
    print(
      'Glow state at position: ${_gameService.gameState.glowStates[position]}',
    );
    print(
      'Is currently glowing: ${_gameService.gameState.glowStates[position]?.isCurrentlyGlowing}',
    );
    print(
      'Collected keywords before: ${_gameService.gameState.collectedKeywords}',
    );

    final success = _gameService.collectKeyword(position);
    print('Collect success: $success');
    print(
      'Collected keywords after: ${_gameService.gameState.collectedKeywords}',
    );
    print('======================');

    if (success) {
      final keyword =
          _gameService.gameState.glowStates[position]?.keyword ?? "";
      setState(() {}); // Force UI update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Collected: $keyword'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: AppColors.accentBlue,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _submitReconstruction() {
    final gameState = _gameService.gameState;
    final accuracy = _gameService.getAccuracy();
    final starRating = _gameService.getStarRating();
    final isPerfect = accuracy == 1.0; // 100% 正确才算通关

    // Save progress
    final progress = ChapterProgress(
      chapterId: widget.chapter.id,
      starRating: starRating,
      savedKeywords: gameState.collectedKeywords,
      isCompleted: isPerfect, // 只有完美通关才算完成
      lastPlayed: DateTime.now(),
    );
    _userRepository.updateChapterProgress(widget.chapter.id, progress);

    _gameService.submitReconstruction();

    // Show result dialog
    _showResultDialog(accuracy, starRating, isPerfect);
  }

  void _showResultDialog(double accuracy, int starRating, bool isPerfect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.parchmentLight, AppColors.parchmentMedium],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPerfect ? AppColors.magicGold : AppColors.borderMedium,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: isPerfect
                    ? AppColors.magicGold.withOpacity(0.3)
                    : AppColors.shadowBrown.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部装饰区域
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPerfect
                        ? [
                            AppColors.magicGold.withOpacity(0.2),
                            AppColors.magicBlue.withOpacity(0.1),
                          ]
                        : [
                            AppColors.dangerRed.withOpacity(0.15),
                            AppColors.parchmentMedium.withOpacity(0.1),
                          ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                ),
                child: Column(
                  children: [
                    // 图标
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isPerfect
                            ? AppColors.magicGold.withOpacity(0.2)
                            : AppColors.dangerRed.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isPerfect
                              ? AppColors.magicGold
                              : AppColors.dangerRed,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isPerfect
                            ? Icons.auto_awesome_rounded
                            : Icons.info_outline_rounded,
                        size: 48,
                        color: isPerfect
                            ? AppColors.magicGold
                            : AppColors.dangerRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 标题
                    Text(
                      isPerfect
                          ? 'Perfect Restoration!'
                          : 'Incomplete Restoration',
                      style: TextStyle(
                        color: isPerfect
                            ? AppColors.magicGold
                            : AppColors.dangerRed,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // 内容区域
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 星级显示
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.parchmentDark.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              index < starRating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: index < starRating
                                  ? AppColors.magicGold
                                  : AppColors.borderMedium,
                              size: 40,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 正确率
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isPerfect
                              ? [
                                  AppColors.magicBlue.withOpacity(0.1),
                                  AppColors.magicPurple.withOpacity(0.1),
                                ]
                              : [
                                  AppColors.dangerRed.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPerfect
                              ? AppColors.magicBlue.withOpacity(0.3)
                              : AppColors.dangerRed.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Accuracy',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.inkFaded,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(accuracy * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: isPerfect
                                  ? AppColors.magicBlue
                                  : AppColors.dangerRed,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keywords: ${_gameService.gameState.collectedKeywords.length}/${widget.chapter.keywords.length}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.inkFaded,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (!isPerfect) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.dangerRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.dangerRed.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.dangerRed,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You need 100% accuracy to unlock the next chapter!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.dangerRed,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // 按钮区域
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 主要操作按钮
                    if (isPerfect)
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.magicGradient,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.magicBlue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            await _navigateToNextChapter();
                          },
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 24,
                          ),
                          label: const Text(
                            'Next Chapter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // 重试按钮
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.goldGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.magicGold.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _inputControllers.forEach(
                              (_, controller) => controller.dispose(),
                            );
                            _inputControllers.clear();
                          });
                          _startGame();
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 24),
                        label: const Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 返回图书馆按钮
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.parchmentDark.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.borderMedium,
                          width: 1.5,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.library_books_rounded,
                          size: 20,
                          color: AppColors.inkBrown,
                        ),
                        label: Text(
                          'Return to Library',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkBrown,
                            letterSpacing: 0.3,
                          ),
                        ),
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
  }

  Future<void> _navigateToNextChapter() async {
    // 获取下一章
    final chapterRepository = ChapterRepository();
    final nextChapter = chapterRepository.getNextChapter(widget.chapter.id);

    if (nextChapter != null) {
      // 导航到下一章
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CodexScreen(chapter: nextChapter),
        ),
      );
    } else {
      // 没有下一章了，显示提示并返回图书馆
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎊 Congratulations! You have completed all chapters!'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.accentBlue,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context); // 返回图书馆
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final gameState = _gameService.gameState;
    final isGameActive = gameState.isGameRunning;

    return Scaffold(
      body: GestureDetector(
        // 点击空白区域收起键盘
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.parchmentGradient,
              stops: const [0.0, 1.0],
            ),
            // 添加羊皮纸纹理效果
            image: DecorationImage(
              image: NetworkImage(
                'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVQI12P4//8/AwMDAwMDAwMAFwMBAweciQsAAAAASUVORK5CYII=',
              ),
              repeat: ImageRepeat.repeat,
              opacity: 0.03,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with ancient book decoration
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.parchmentDark.withOpacity(0.3),
                        AppColors.parchmentMedium.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderMedium, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowBrown.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 古典返回按钮
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.inkBlack.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded),
                          iconSize: 20,
                          onPressed: () => Navigator.pop(context),
                          color: AppColors.inkBrown,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 章节标题
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.chapter.title,
                              style: TextStyle(
                                color: AppColors.inkBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              widget.chapter.subtitle,
                              style: TextStyle(
                                color: AppColors.inkFaded,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phase indicator
                      if (isGameActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gameState.phase == GamePhase.glowingPhase
                                  ? [
                                      AppColors.magicBlue.withOpacity(0.2),
                                      AppColors.glowCyan.withOpacity(0.1),
                                    ]
                                  : [
                                      AppColors.glowAmber.withOpacity(0.2),
                                      AppColors.magicGold.withOpacity(0.1),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: gameState.phase == GamePhase.glowingPhase
                                  ? AppColors.magicBlue.withOpacity(0.3)
                                  : AppColors.magicGold.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (gameState.phase == GamePhase.glowingPhase
                                            ? AppColors.magicBlue
                                            : AppColors.magicGold)
                                        .withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                gameState.phase == GamePhase.glowingPhase
                                    ? Icons.auto_fix_high_rounded
                                    : Icons.build_circle_outlined,
                                size: 16,
                                color: gameState.phase == GamePhase.glowingPhase
                                    ? AppColors.magicBlue
                                    : AppColors.magicGold,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                gameState.phase == GamePhase.glowingPhase
                                    ? 'Collecting'
                                    : 'Restoring',
                                style: TextStyle(
                                  color:
                                      gameState.phase == GamePhase.glowingPhase
                                      ? AppColors.magicBlue
                                      : AppColors.magicGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Story text area - Ancient book page
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.parchmentLight,
                                  AppColors.parchmentMedium.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.borderMedium,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadowBrown.withOpacity(
                                    0.25,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: AppColors.magicGold.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Stack(
                              children: [
                                // 装饰性角落花纹
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    color: AppColors.magicGold.withOpacity(
                                      0.15,
                                    ),
                                    size: 32,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    color: AppColors.magicGold.withOpacity(
                                      0.15,
                                    ),
                                    size: 32,
                                  ),
                                ),
                                // 主要内容
                                Center(
                                  child: !isGameActive
                                      ? _buildWelcomeScreen()
                                      : _buildGameContent(gameState),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Collection panel - Magical scroll
                        Container(
                          width: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.magicPurple.withOpacity(0.15),
                                AppColors.magicBlue.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.magicPurple.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.magicPurple.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 标题与图标
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.magicPurple.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.collections_bookmark_rounded,
                                      color: AppColors.magicPurple,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'SAVED',
                                      style: TextStyle(
                                        color: AppColors.magicPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Divider(
                                color: AppColors.magicPurple.withOpacity(0.3),
                                thickness: 1.5,
                              ),
                              Expanded(
                                child: gameState.collectedKeywords.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.touch_app_outlined,
                                              color: AppColors.textTertiary
                                                  .withOpacity(0.4),
                                              size: 32,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap glowing\nwords',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textTertiary
                                                    .withOpacity(0.7),
                                                fontSize: 11,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _buildCollectionList(gameState),
                              ),
                              Divider(
                                color: AppColors.magicPurple.withOpacity(0.3),
                                thickness: 1.5,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.magicGold.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.magicGold.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${gameState.collectedKeywords.length} / ${widget.chapter.keywords.length}',
                                  style: TextStyle(
                                    color: AppColors.magicGold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom controls - Full width button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isGameActive)
                        // Start button
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.goldGradient,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.magicGold.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.magicGold.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _startGame,
                            icon: const Icon(
                              Icons.auto_stories_rounded,
                              size: 24,
                            ),
                            label: const Text(
                              'Begin Restoration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        )
                      else if (gameState.phase == GamePhase.reconstructionPhase)
                        // Repair button
                        Builder(
                          builder: (context) {
                            final filledCount = gameState.placedKeywords.values
                                .where((v) => v != null && v.trim().isNotEmpty)
                                .length;
                            final totalCount = gameState.glowStates.length;
                            final allFilled = gameState.allBlanksFilled;

                            print('=== Button State Debug ===');
                            print('Filled: $filledCount / $totalCount');
                            print('allBlanksFilled: $allFilled');

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: allFilled
                                          ? AppColors.magicGradient
                                          : [
                                              Colors.grey[400]!,
                                              Colors.grey[500]!,
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: allFilled
                                          ? AppColors.magicBlue.withOpacity(0.5)
                                          : Colors.grey.withOpacity(0.5),
                                      width: 2,
                                    ),
                                    boxShadow: allFilled
                                        ? [
                                            BoxShadow(
                                              color: AppColors.magicBlue
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: allFilled
                                        ? _submitReconstruction
                                        : null,
                                    icon: Icon(
                                      allFilled
                                          ? Icons.check_circle_rounded
                                          : Icons.pending_outlined,
                                      size: 24,
                                    ),
                                    label: Text(
                                      allFilled
                                          ? 'Complete Restoration'
                                          : 'Fill All Blanks ($filledCount/$totalCount)',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      disabledForegroundColor: Colors.white
                                          .withOpacity(0.5),
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                if (!allFilled)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.info_outline_rounded,
                                          size: 14,
                                          color: AppColors.inkFaded,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Complete all repairs to proceed',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.inkFaded,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_stories, size: 64, color: AppColors.accentBlue),
        const SizedBox(height: 16),
        Text(
          widget.chapter.title,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 8),
        Text(
          widget.chapter.subtitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 32),
        const Text(
          'Phase 1: Click glowing keywords to collect\nPhase 2: Drag words to fill the blanks',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildGameContent(GameState gameState) {
    if (gameState.phase == GamePhase.glowingPhase) {
      return _buildGlowingPhase(gameState);
    } else {
      return _buildReconstructionPhase(gameState);
    }
  }

  Widget _buildGlowingPhase(GameState gameState) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: _buildGlowingWords(gameState),
      ),
    );
  }

  List<Widget> _buildGlowingWords(GameState gameState) {
    final widgets = <Widget>[];
    int position = 0;

    for (final parsedWord in _parsedWords) {
      final glowState = gameState.glowStates[position];
      final isGlowing = glowState?.isCurrentlyGlowing ?? false;
      final isCollected = gameState.collectedKeywords.contains(parsedWord.text);
      final currentPosition = position; // Capture position for closure

      // Only add tap handler for keywords that are currently glowing
      final widget = isGlowing
          ? GestureDetector(
              onTap: () {
                print(
                  '>>> User tapped on position $currentPosition (keyword: "${parsedWord.text}")',
                );
                _handleWordTap(currentPosition);
              },
              child: _buildGlowingKeyword(parsedWord.text),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                parsedWord.text,
                style: TextStyle(
                  color: isCollected
                      ? AppColors.accentBlue.withOpacity(0.7)
                      : AppColors.textDark,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  height: 1.6,
                ),
              ),
            );

      widgets.add(widget);
      position++;
    }

    return widgets;
  }

  /// Build a smoothly glowing keyword with pulsing animation
  Widget _buildGlowingKeyword(String keyword) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        // Pulsing effect: oscillate between 0.85 and 1.0
        final pulse = 0.85 + (0.15 * value);
        final glowIntensity = 0.5 + (0.3 * value);

        return Transform.scale(
          scale: pulse,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.magicBlue.withOpacity(0.3),
                  AppColors.glowCyan.withOpacity(0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.magicBlue.withOpacity(0.8),
                width: 2.5,
              ),
              boxShadow: [
                // Inner glow
                BoxShadow(
                  color: AppColors.magicBlue.withOpacity(glowIntensity),
                  blurRadius: 15 * pulse,
                  spreadRadius: 2 * pulse,
                ),
                // Outer glow
                BoxShadow(
                  color: AppColors.glowCyan.withOpacity(glowIntensity * 0.6),
                  blurRadius: 25 * pulse,
                  spreadRadius: 4 * pulse,
                ),
                // Soft outer rim
                BoxShadow(
                  color: AppColors.magicBlue.withOpacity(0.2),
                  blurRadius: 35 * pulse,
                  spreadRadius: 6 * pulse,
                ),
              ],
            ),
            child: Text(
              keyword,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.6,
                shadows: [
                  Shadow(
                    color: AppColors.magicBlue.withOpacity(0.8),
                    blurRadius: 8 * pulse,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop the animation for continuous pulsing
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildReconstructionPhase(GameState gameState) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: _buildReconstructionWords(gameState),
      ),
    );
  }

  List<Widget> _buildReconstructionWords(GameState gameState) {
    final widgets = <Widget>[];
    int position = 0;

    print('=== Building Reconstruction Words ===');
    print('Total parsed words: ${_parsedWords.length}');
    print('Glow states: ${gameState.glowStates.keys.toList()}');
    print('Placed keywords: ${gameState.placedKeywords}');

    for (final parsedWord in _parsedWords) {
      final glowState = gameState.glowStates[position];

      if (glowState != null) {
        // This is a keyword position - show blank/input/dragtarget
        final placedWord = gameState.placedKeywords[position];
        print(
          'Position $position: keyword="${glowState.keyword}", placed="$placedWord"',
        );

        if (placedWord != null && placedWord.trim().isNotEmpty) {
          // Already filled - show the filled word
          final currentPosition = position; // Capture position for closure
          widgets.add(
            GestureDetector(
              onTap: () {
                // Allow removing the placed word
                print('>>> Removing keyword from position $currentPosition');
                _gameService.removeKeywordFromPosition(currentPosition);
                _inputControllers[currentPosition]?.clear();
                setState(() {}); // Force UI update
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accentBlue, width: 2),
                ),
                child: Text(
                  placedWord,
                  style: const TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        } else {
          // Empty - show DragTarget with TextField
          final currentPosition = position; // Capture position for closure
          final controller = _inputControllers.putIfAbsent(
            currentPosition,
            () => TextEditingController(),
          );

          widgets.add(
            DragTarget<String>(
              onAccept: (keyword) {
                print(
                  '>>> DragTarget.onAccept at position $currentPosition: "$keyword"',
                );
                _gameService.placeKeyword(currentPosition, keyword);
                controller.text = keyword;
                setState(() {}); // Force UI update to check allBlanksFilled
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;

                return Container(
                  width: 110,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? AppColors.accentOrange.withOpacity(0.3)
                        : AppColors.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accentOrange,
                      width: isHovering ? 3 : 2,
                    ),
                  ),
                  child: TextField(
                    key: ValueKey('input_$currentPosition'),
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        print(
                          '>>> TextField.onSubmitted at position $currentPosition: "$value"',
                        );
                        _gameService.placeKeyword(
                          currentPosition,
                          value.trim(),
                        );
                        setState(() {}); // Force UI update
                      }
                    },
                    onChanged: (value) {
                      if (value.trim().isNotEmpty) {
                        print(
                          '>>> TextField.onChanged at position $currentPosition: "$value"',
                        );
                        _gameService.placeKeyword(
                          currentPosition,
                          value.trim(),
                        );
                      } else {
                        _gameService.removeKeywordFromPosition(currentPosition);
                      }
                      setState(
                        () {},
                      ); // Force UI update to check allBlanksFilled
                    },
                  ),
                );
              },
            ),
          );
        }
      } else {
        // Normal word
        widgets.add(
          Text(
            parsedWord.text,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 22,
              height: 1.6,
            ),
          ),
        );
      }

      position++;
    }

    return widgets;
  }

  Widget _buildCollectionList(GameState gameState) {
    return ListView(
      physics: const ClampingScrollPhysics(), // Prevent scroll interference
      children: gameState.collectedKeywords.map((keyword) {
        // Check if already used
        final isUsed = gameState.placedKeywords.values.contains(keyword);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Draggable<String>(
            data: keyword,
            feedback: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  keyword,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Text(
                keyword,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUsed
                    ? Colors.grey.withOpacity(0.3)
                    : AppColors.accentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isUsed
                      ? Colors.grey.withOpacity(0.5)
                      : AppColors.accentBlue.withOpacity(0.4),
                ),
              ),
              child: Text(
                keyword,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isUsed ? Colors.grey : AppColors.textDark,
                  fontSize: 12,
                  decoration: isUsed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
