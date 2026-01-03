enum LevelDifficulty { tutorial, easy, normal, hard, expert }

class LevelModel {
  final String id;
  final int levelNumber;
  final String name;
  final String sector;
  final String description;
  final LevelDifficulty difficulty;
  final bool isUnlocked;
  final bool isCompleted;
  final int starsEarned;
  final Duration? bestTime;
  final int? moveCount;
  final List<String> prerequisites;

  LevelModel({
    required this.id,
    required this.levelNumber,
    required this.name,
    required this.sector,
    required this.description,
    required this.difficulty,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.starsEarned = 0,
    this.bestTime,
    this.moveCount,
    this.prerequisites = const [],
  });

  LevelModel copyWith({
    bool? isUnlocked,
    bool? isCompleted,
    int? starsEarned,
    Duration? bestTime,
    int? moveCount,
  }) {
    return LevelModel(
      id: id,
      levelNumber: levelNumber,
      name: name,
      sector: sector,
      description: description,
      difficulty: difficulty,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      starsEarned: starsEarned ?? this.starsEarned,
      bestTime: bestTime ?? this.bestTime,
      moveCount: moveCount ?? this.moveCount,
      prerequisites: prerequisites,
    );
  }
}
