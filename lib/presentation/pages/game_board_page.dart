import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../domain/usecases/generate_level_usecase.dart';
import '../../domain/usecases/check_match_usecase.dart';
import '../../domain/usecases/update_selectable_tiles_usecase.dart';
import '../viewmodels/game_viewmodel.dart';
import '../widgets/mahjong_tile_widget.dart';
import '../widgets/hand_slot_widget.dart';
import '../widgets/game_over_dialog.dart';

/// Game board screen
class GameBoardPage extends StatefulWidget {
  /// The level number to play
  final int level;

  /// Constructor
  const GameBoardPage({super.key, required this.level});

  @override
  State<GameBoardPage> createState() => _GameBoardPageState();
}

class _GameBoardPageState extends State<GameBoardPage> {
  late GameViewModel _viewModel;
  bool _dialogShown = false;
  bool _isTransitioningToNextLevel = false;

  @override
  void initState() {
    super.initState();

    // Initialize repositories and use cases
    final gameRepository = GameRepository();
    final achievementRepository = AchievementRepository();
    final generateLevelUseCase = GenerateLevelUseCase(gameRepository);
    final checkMatchUseCase = CheckMatchUseCase();
    final updateSelectableTilesUseCase = UpdateSelectableTilesUseCase();

    // Initialize view model
    _viewModel = GameViewModel(
      gameRepository,
      achievementRepository,
      generateLevelUseCase,
      checkMatchUseCase,
      updateSelectableTilesUseCase,
      widget.level,
    );

    // Listen for state changes
    _viewModel.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    // 如果正在切换到下一关，则不显示弹窗
    if (_isTransitioningToNextLevel) {
      setState(() {});
      return;
    }

    // Check for win/loss
    if (!_dialogShown && _viewModel.gameState.isWin) {
      _dialogShown = true;
      _showGameOverDialog(true);
    } else if (!_dialogShown && _viewModel.gameState.isLoss) {
      _dialogShown = true;
      _showGameOverDialog(false);
    }

    setState(() {});
  }

  void _showGameOverDialog(bool isWin) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GameOverDialog(
          isWin: isWin,
          level: widget.level,
          onRetry: () {
            Navigator.pop(context);
            _dialogShown = false;
            _viewModel.restartLevel();
          },
          onNextLevel: () {
            Navigator.pop(context);
            // 标记正在切换到下一关，防止触发新的弹窗
            _isTransitioningToNextLevel = true;
            _dialogShown = false;
            _viewModel.nextLevel();
            // 延迟重置标志，确保新关卡加载完成
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  _isTransitioningToNextLevel = false;
                });
              }
            });
          },
          onBack: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/8.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.carvedJadeGreen,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Column(
                        children: [
                          // Game header
                          _buildHeader(),

                          // Game canvas
                          Expanded(child: _buildGameCanvas()),

                          // Hand slots
                          _buildHandSlots(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button with glass effect
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back to Level Select',
                ),
              ),

              // Level info with glass effect
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'LEVEL ${_viewModel.gameState.currentLevel}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Rules button with glass effect
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _showRulesDialog,
                  tooltip: 'Game Rules',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Second row with tiles left counter and power-ups
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tiles left counter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.grid_view, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Tiles: ${_viewModel.gameState.tilesRemaining}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Power-ups row
              Row(
                children: [
                  // Undo button
                  _buildPowerUpButton(
                    icon: Icons.undo,
                    isUsed: _viewModel.gameState.undoUsed,
                    onPressed: _viewModel.gameState.undoUsed
                        ? null
                        : _viewModel.useUndo,
                    tooltip: 'Undo Last Move',
                  ),
                  const SizedBox(width: 12),

                  // Shuffle button
                  _buildPowerUpButton(
                    icon: Icons.shuffle,
                    isUsed: _viewModel.gameState.shuffleUsed,
                    onPressed: _viewModel.gameState.shuffleUsed
                        ? null
                        : _viewModel.useShuffle,
                    tooltip: 'Shuffle Available Tiles',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpButton({
    required IconData icon,
    required bool isUsed,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isUsed
            ? Colors.white.withOpacity(0.05)
            : AppColors.beeswaxAmber.withOpacity(0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUsed
              ? Colors.white.withOpacity(0.1)
              : AppColors.beeswaxAmber.withOpacity(0.7),
          width: 1.5,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: isUsed ? Colors.white.withOpacity(0.3) : Colors.white,
          size: 22,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildGameCanvas() {
    // If there are no tiles left, return an empty container
    if (_viewModel.gameState.boardState.isEmpty) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
      );
    }

    // Calculate the board dimensions
    double minX = double.infinity;
    double maxX = 0;
    double minY = double.infinity;
    double maxY = 0;

    // Find the bounds of all tiles
    for (final tile in _viewModel.gameState.boardState) {
      final tileRight = tile.x + UISizes.tileSizeWidth;
      final tileBottom = tile.y + UISizes.tileSizeHeight;

      if (tile.x < minX) minX = tile.x;
      if (tileRight > maxX) maxX = tileRight;
      if (tile.y < minY) minY = tile.y;
      if (tileBottom > maxY) maxY = tileBottom;
    }

    // Calculate the board width and height
    final boardWidth = maxX - minX;
    final boardHeight = maxY - minY;

    // 检测是否为iPad设备
    final bool isIpad = _isIpadDevice(context);

    // 根据关卡级别和设备类型选择不同的缩放因子
    final level = _viewModel.gameState.currentLevel;
    final double scaleFactor;

    if (isIpad) {
      // iPad专用缩放因子
      if (level <= 3) {
        scaleFactor = UISizes.ipadBoardScaleFactorEasy; // 1-3关卡 (65% 放大)
      } else if (level <= 7) {
        scaleFactor = UISizes.ipadBoardScaleFactorMedium; // 4-7关卡 (55% 放大)
      } else {
        scaleFactor = UISizes.ipadBoardScaleFactorHard; // 8-12关卡 (45% 放大)
      }
    } else {
      // iPhone缩放因子
      if (level <= 3) {
        scaleFactor = UISizes.boardScaleFactorEasy; // 1-3关卡 (35% 放大)
      } else if (level <= 7) {
        scaleFactor = UISizes.boardScaleFactorMedium; // 4-7关卡 (25% 放大)
      } else {
        scaleFactor = UISizes.boardScaleFactorHard; // 8-12关卡 (15% 放大)
      }
    }

    // 应用缩放因子
    final scaledBoardWidth = boardWidth * scaleFactor;
    final scaledBoardHeight = boardHeight * scaleFactor;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      // Center the board in the available space
      child: Center(
        child: SizedBox(
          width: scaledBoardWidth,
          height: scaledBoardHeight,
          child: Stack(
            children: _viewModel.gameState.boardState.map((tile) {
              // Adjust the position relative to the board's top-left corner and apply scaling
              return Positioned(
                left: (tile.x - minX) * scaleFactor,
                top: (tile.y - minY) * scaleFactor,
                child: Transform.scale(
                  scale: scaleFactor,
                  alignment: Alignment.topLeft,
                  child: MahjongTileWidget(
                    tile: tile,
                    onTap: () => _viewModel.selectTile(tile),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildHandSlots() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Hand title
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'YOUR HAND',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ),
          // Hand slots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(AppConstants.maxHandSize, (index) {
              final tile = index < _viewModel.gameState.handState.length
                  ? _viewModel.gameState.handState[index]
                  : null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: HandSlotWidget(
                    tile: tile,
                    isCompact: true, // 使用紧凑模式
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 显示游戏规则对话框
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/3.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'GAME RULES',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Rules content
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _buildRuleSection(
                        title: 'Triple Match',
                        description: 'Three identical tiles can be removed',
                        examples: [
                          'Three East Wind',
                          'Three Red Dragon',
                          'Three 1 Character',
                        ],
                        icon: Icons.filter_3,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        height: 1,
                        color: Colors.white.withOpacity(0),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _buildRuleSection(
                        title: 'Sequence Match',
                        description:
                            'Three consecutive numbers of the same suit can be removed (only applies to Characters, Bamboo, and Dots)',
                        examples: [
                          '1-2-3 Characters',
                          '4-5-6 Bamboo',
                          '7-8-9 Dots',
                        ],
                        icon: Icons.format_list_numbered,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.carvedJadeGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: AppColors.carvedJadeGreen.withOpacity(
                            0.5,
                          ),
                        ),
                        child: const Text(
                          'GOT IT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建规则说明部分
  Widget _buildRuleSection({
    required String title,
    required String description,
    required List<String> examples,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rule icon
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(right: 16, top: 4),
          decoration: BoxDecoration(
            color: AppColors.carvedJadeGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.carvedJadeGreen.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),

        // Rule content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Examples: ${examples.join(', ')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 检测当前设备是否为iPad
  bool _isIpadDevice(BuildContext context) {
    // 获取屏幕尺寸
    final Size screenSize = MediaQuery.of(context).size;
    final double shortestSide = screenSize.shortestSide;

    // iPad通常短边大于600dp
    return shortestSide >= 600;
  }
}
