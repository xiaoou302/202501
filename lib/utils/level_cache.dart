import '../models/game_level.dart';

/// A cache for game levels to improve performance
class LevelCache {
  // Private constructor for singleton pattern
  LevelCache._();

  // Singleton instance
  static final LevelCache _instance = LevelCache._();

  // Factory constructor to return the singleton instance
  factory LevelCache() => _instance;

  // Cache for level metadata (lightweight version without full layout details)
  final Map<int, GameLevelMetadata> _levelMetadataCache = {};

  // Cache for complete levels (with full layout details)
  final Map<int, GameLevel> _levelCache = {};

  /// Get level metadata by ID (lightweight, without full layout)
  GameLevelMetadata? getLevelMetadataById(int levelId) {
    return _levelMetadataCache[levelId];
  }

  /// Get complete level by ID (with full layout)
  GameLevel? getLevelById(int levelId) {
    return _levelCache[levelId];
  }

  /// Cache level metadata
  void cacheLevelMetadata(int levelId, GameLevelMetadata metadata) {
    _levelMetadataCache[levelId] = metadata;
  }

  /// Cache complete level
  void cacheLevel(GameLevel level) {
    _levelCache[level.id] = level;

    // Also cache metadata for this level
    _levelMetadataCache[level.id] = GameLevelMetadata(
      id: level.id,
      name: level.name,
      description: level.description,
      totalMoves: level.totalMoves,
      levelPack: level.levelPack,
    );
  }

  /// Cache multiple levels at once
  void cacheLevels(List<GameLevel> levels) {
    for (final level in levels) {
      cacheLevel(level);
    }
  }

  /// Get all cached level metadata for a specific pack
  List<GameLevelMetadata> getLevelMetadataForPack(String packName) {
    return _levelMetadataCache.values
        .where((metadata) => metadata.levelPack == packName)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  /// Clear the cache
  void clear() {
    _levelMetadataCache.clear();
    _levelCache.clear();
  }
}

/// Lightweight version of GameLevel without full layout details
class GameLevelMetadata {
  final int id;
  final String name;
  final String description;
  final int totalMoves;
  final String levelPack;
  final bool isLocked;

  GameLevelMetadata({
    required this.id,
    required this.name,
    required this.description,
    required this.totalMoves,
    required this.levelPack,
    this.isLocked = false,
  });

  GameLevelMetadata copyWith({
    int? id,
    String? name,
    String? description,
    int? totalMoves,
    String? levelPack,
    bool? isLocked,
  }) {
    return GameLevelMetadata(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      totalMoves: totalMoves ?? this.totalMoves,
      levelPack: levelPack ?? this.levelPack,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
