import 'chapter_model.dart';

/// Game phase enum
enum GamePhase {
  notStarted,
  glowingPhase, // Phase 1: Keywords glow randomly 3 times each
  reconstructionPhase, // Phase 2: Drag keywords to blanks
  gameOver,
}

/// Keyword glow state
class KeywordGlowState {
  final String keyword;
  final int position; // Position in text
  final int glowCount; // How many times it has glowed (max 3)
  final bool isCurrentlyGlowing;

  const KeywordGlowState({
    required this.keyword,
    required this.position,
    this.glowCount = 0,
    this.isCurrentlyGlowing = false,
  });

  KeywordGlowState copyWith({
    String? keyword,
    int? position,
    int? glowCount,
    bool? isCurrentlyGlowing,
  }) {
    return KeywordGlowState(
      keyword: keyword ?? this.keyword,
      position: position ?? this.position,
      glowCount: glowCount ?? this.glowCount,
      isCurrentlyGlowing: isCurrentlyGlowing ?? this.isCurrentlyGlowing,
    );
  }
}

/// Game state model for managing current gameplay
class GameState {
  final Chapter? currentChapter;
  final Set<String> collectedKeywords; // Keywords player clicked during glow
  final Map<int, String?> placedKeywords; // position -> placed keyword
  final Map<int, KeywordGlowState> glowStates; // position -> glow state
  final int? currentGlowingPosition; // Currently glowing keyword position
  final bool isGameRunning;
  final GamePhase phase;

  const GameState({
    this.currentChapter,
    this.collectedKeywords = const {},
    this.placedKeywords = const {},
    this.glowStates = const {},
    this.currentGlowingPosition,
    this.isGameRunning = false,
    this.phase = GamePhase.notStarted,
  });

  GameState copyWith({
    Chapter? currentChapter,
    Set<String>? collectedKeywords,
    Map<int, String?>? placedKeywords,
    Map<int, KeywordGlowState>? glowStates,
    int? currentGlowingPosition,
    bool? clearGlowingPosition = false,
    bool? isGameRunning,
    GamePhase? phase,
  }) {
    return GameState(
      currentChapter: currentChapter ?? this.currentChapter,
      collectedKeywords: collectedKeywords ?? this.collectedKeywords,
      placedKeywords: placedKeywords ?? this.placedKeywords,
      glowStates: glowStates ?? this.glowStates,
      currentGlowingPosition: clearGlowingPosition == true
          ? null
          : (currentGlowingPosition ?? this.currentGlowingPosition),
      isGameRunning: isGameRunning ?? this.isGameRunning,
      phase: phase ?? this.phase,
    );
  }

  /// Check if all keywords have glowed 3 times
  bool get isGlowingComplete {
    if (glowStates.isEmpty) return false;
    return glowStates.values.every((state) => state.glowCount >= 3);
  }

  /// Check if all blanks are filled
  bool get allBlanksFilled {
    if (currentChapter == null) return false;
    final keywordPositions = glowStates.keys.toList();
    return keywordPositions.every((pos) {
      final word = placedKeywords[pos];
      return word != null && word.trim().isNotEmpty;
    });
  }

  /// Calculate accuracy: correct keywords in correct positions
  double calculateAccuracy() {
    if (currentChapter == null || glowStates.isEmpty) return 0.0;

    int correctCount = 0;
    glowStates.forEach((position, glowState) {
      final placedWord = placedKeywords[position];
      if (placedWord != null &&
          placedWord.toLowerCase().trim() ==
              glowState.keyword.toLowerCase().trim()) {
        correctCount++;
      }
    });

    return correctCount / glowStates.length;
  }

  /// Check if game is won (all correct)
  bool get isWon {
    return calculateAccuracy() == 1.0;
  }

  /// Calculate star rating
  int calculateStarRating() {
    final accuracy = calculateAccuracy();
    if (accuracy == 1.0) return 3; // Perfect
    if (accuracy >= 0.8) return 2; // Good
    if (accuracy >= 0.6) return 1; // Pass
    return 0; // Fail
  }
}
