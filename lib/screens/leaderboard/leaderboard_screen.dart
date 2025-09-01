import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/game_constants.dart';
import '../../models/game_statistics.dart';
import '../../services/stats_service.dart';
import '../../utils/demo_data_generator.dart';
import '../../widgets/common/neumorphic_card.dart';
import '../../widgets/leaderboard/stats_card.dart';
import '../../widgets/leaderboard/game_achievement_card.dart';

/// Player Statistics Screen
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final StatsService _statsService = StatsService();
  final DemoDataGenerator _demoDataGenerator = DemoDataGenerator();

  // Selected game for detailed statistics
  String _selectedGameId = GameConstants.memoryGame;

  // Game statistics
  List<GameStatistics> _allGameStats = [];
  Map<String, String> _selectedGameStats = {};
  List<String> _gameInsights = [];

  // Loading state
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load all required data
  Future<void> _loadData() async {
    await _loadGameStatistics();
  }

  /// Load game statistics
  Future<void> _loadGameStatistics() async {
    setState(() {
      _isLoadingStats = true;
    });

    try {
      // Load all game statistics
      _allGameStats = await _statsService.getAllGameStatistics();

      // Load detailed stats for selected game
      await _loadSelectedGameStats();
    } catch (e) {
      // Handle error
      print('Error loading game statistics: $e');
    } finally {
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  /// Load statistics for the selected game
  Future<void> _loadSelectedGameStats() async {
    switch (_selectedGameId) {
      case GameConstants.memoryGame:
        _selectedGameStats = await _statsService.getMemoryGameStats();
        break;
      case GameConstants.rhythmGame:
        _selectedGameStats = await _statsService.getRhythmGameStats();
        break;
      case GameConstants.numberGame:
        _selectedGameStats = await _statsService.getNumberGameStats();
        break;
    }

    // Load insights for selected game
    _gameInsights = await _statsService.getGameInsights(_selectedGameId);
  }

  /// Change selected game
  void _selectGame(String gameId) {
    setState(() {
      _selectedGameId = gameId;
    });

    _loadSelectedGameStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Game Statistics'),
        actions: [
          // Demo data generation button (only for development)
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: 'Generate Demo Data',
            onPressed: () async {
              // Show loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Generating demo data...'),
                  duration: Duration(seconds: 1),
                ),
              );

              // Generate demo data
              await _demoDataGenerator.generateDemoStats();

              // Reload data
              await _loadData();

              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Demo data generated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoadingStats
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game selection cards
                    _buildGameSelectionCards(),
                    const SizedBox(height: 24),

                    // Selected game statistics
                    _buildSelectedGameStatistics(),
                    const SizedBox(height: 24),

                    // Additional game-specific stats
                    _buildAdditionalStats(),
                  ],
                ),
              ),
            ),
    );
  }

  /// Build game selection cards
  Widget _buildGameSelectionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Games',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 16),

        // Memory Match card
        _buildGameSelectionCard(
          GameConstants.memoryGame,
          'Memory Match',
          Icons.grid_view_rounded,
          Colors.blue,
        ),
        const SizedBox(height: 16),

        // Rhythm Flow card
        _buildGameSelectionCard(
          GameConstants.rhythmGame,
          'Flow Rush',
          Icons.music_note_rounded,
          Colors.purple,
        ),
        const SizedBox(height: 16),

        // Number Memory card
        _buildGameSelectionCard(
          GameConstants.numberGame,
          'Number Memory',
          Icons.format_list_numbered_rounded,
          Colors.green,
        ),
      ],
    );
  }

  /// Build a game selection card
  Widget _buildGameSelectionCard(
    String gameId,
    String title,
    IconData icon,
    Color color,
  ) {
    // Find stats for this game
    final stats = _allGameStats.firstWhere(
      (stats) => stats.gameId == gameId,
      orElse: () => GameStatistics.defaultStats(gameId),
    );

    // Calculate achievements (placeholder - in a real app, get from achievements service)
    final achievementsCompleted = stats.gamesPlayed > 0 ? 1 : 0;
    final totalAchievements = 5;

    // Calculate total levels based on game
    int totalLevels;
    switch (gameId) {
      case GameConstants.memoryGame:
        totalLevels = 7; // memory_level1 to memory_level7
        break;
      case GameConstants.rhythmGame:
        totalLevels = 7; // flow_easy to flow_legend
        break;
      case GameConstants.numberGame:
        totalLevels = 7; // number_level1 to number_level7
        break;
      default:
        totalLevels = 7;
    }

    return GameAchievementCard(
      gameTitle: title,
      gameIcon: icon,
      gameColor: color,
      achievementsCompleted: achievementsCompleted,
      totalAchievements: totalAchievements,
      bestScore: stats.bestScore,
      levelsCompleted: stats.levelsCompleted.length,
      totalLevels: totalLevels,
      onTap: () => _selectGame(gameId),
    );
  }

  /// Build selected game statistics
  Widget _buildSelectedGameStatistics() {
    // Get title, icon and color based on selected game
    String title;
    IconData icon;
    Color color;

    switch (_selectedGameId) {
      case GameConstants.memoryGame:
        title = 'Memory Match Statistics';
        icon = Icons.grid_view_rounded;
        color = Colors.blue;
        break;
      case GameConstants.rhythmGame:
        title = 'Flow Rush Statistics';
        icon = Icons.music_note_rounded;
        color = Colors.purple;
        break;
      case GameConstants.numberGame:
        title = 'Number Memory Statistics';
        icon = Icons.format_list_numbered_rounded;
        color = Colors.green;
        break;
      default:
        title = 'Game Statistics';
        icon = Icons.bar_chart;
        color = AppColors.primary;
    }

    return StatsCard(
      title: title,
      icon: icon,
      color: color,
      stats: _selectedGameStats,
      insights: _gameInsights,
    );
  }

  /// Build additional game-specific statistics
  Widget _buildAdditionalStats() {
    // Get stats for this game
    final stats = _allGameStats.firstWhere(
      (stats) => stats.gameId == _selectedGameId,
      orElse: () => GameStatistics.defaultStats(_selectedGameId),
    );

    // If no games played yet, show empty state
    if (stats.gamesPlayed == 0) {
      return _buildEmptyStatsCard();
    }

    // Build game-specific additional stats
    switch (_selectedGameId) {
      case GameConstants.memoryGame:
        return _buildMemoryGameAdditionalStats(stats);
      case GameConstants.rhythmGame:
        return _buildRhythmGameAdditionalStats(stats);
      case GameConstants.numberGame:
        return _buildNumberGameAdditionalStats(stats);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Build Memory Match additional statistics
  Widget _buildMemoryGameAdditionalStats(GameStatistics stats) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          // Display completed levels
          _buildLevelProgressList(stats.levelsCompleted, [
            'Level 1: Nature',
            'Level 2: Animals',
            'Level 3: Food',
            'Level 4: Travel',
            'Level 5: Space',
            'Level 6: Tech',
            'Level 7: Fantasy',
          ], Colors.blue),
        ],
      ),
    );
  }

  /// Build Flow Rush additional statistics
  Widget _buildRhythmGameAdditionalStats(GameStatistics stats) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 16),

          // Display completed levels
          _buildLevelProgressList(stats.levelsCompleted, [
            'Level 1: Beginner',
            'Level 2: Regular',
            'Level 3: Advanced',
            'Level 4: Expert',
            'Level 5: Master',
            'Level 6: Grandmaster',
            'Level 7: Legend',
          ], Colors.purple),
        ],
      ),
    );
  }

  /// Build Number Memory additional statistics
  Widget _buildNumberGameAdditionalStats(GameStatistics stats) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),

          // Display completed levels
          _buildLevelProgressList(stats.levelsCompleted, [
            'Level 1: Easy Numbers',
            'Level 2: Medium Numbers',
            'Level 3: Custom Numbers',
            'Level 4: Letters',
            'Level 5: Advanced Numbers',
            'Level 6: Advanced Letters',
            'Level 7: Expert Numbers',
          ], Colors.green),
        ],
      ),
    );
  }

  /// Build level progress list
  Widget _buildLevelProgressList(
    List<String> completedLevels,
    List<String> allLevels,
    Color color,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: allLevels.length,
      itemBuilder: (context, index) {
        final levelId = 'level_${index + 1}';
        final bool isCompleted = completedLevels.contains(levelId);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? color : Colors.grey[800],
                  border: Border.all(
                    color: isCompleted ? color : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isCompleted ? Icons.check : Icons.lock,
                    size: 14,
                    color: isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                allLevels[index],
                style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.grey[600],
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build empty stats card
  Widget _buildEmptyStatsCard() {
    return NeumorphicCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.bar_chart, color: Colors.grey[600], size: 48),
            const SizedBox(height: 16),
            Text(
              'No game data available',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Play games to see your statistics',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
