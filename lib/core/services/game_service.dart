import 'dart:async';
import 'dart:math';
import '../models/chapter_model.dart';
import '../models/game_state_model.dart';
import '../utils/text_parser.dart';

/// Game service for managing game logic
class GameService {
  GameState _gameState = const GameState();
  Timer? _glowTimer;
  final void Function(GameState)? onStateChanged;
  final Random _random = Random();
  List<int> _glowQueue = []; // Queue of positions to glow

  GameService({this.onStateChanged});

  GameState get gameState => _gameState;

  /// Start a new game with a chapter
  void startGame(Chapter chapter) {
    // Parse text and find keyword positions
    final parsedWords = TextParser.parseText(chapter.content);
    final glowStates = <int, KeywordGlowState>{};

    int position = 0;
    for (final word in parsedWords) {
      if (word.isKeyword) {
        glowStates[position] = KeywordGlowState(
          keyword: word.text,
          position: position,
          glowCount: 0,
          isCurrentlyGlowing: false,
        );
      }
      position++;
    }

    _gameState = GameState(
      currentChapter: chapter,
      collectedKeywords: {},
      placedKeywords: {},
      glowStates: glowStates,
      currentGlowingPosition: null,
      isGameRunning: true,
      phase: GamePhase.glowingPhase,
    );

    _startGlowSequence();
    _notifyStateChange();
  }

  /// Start the keyword glowing sequence
  void _startGlowSequence() {
    // Create a queue: randomize all keywords, each will glow 3 times consecutively
    _glowQueue = [];
    final positions = _gameState.glowStates.keys.toList()..shuffle(_random);

    // Add all positions to queue, they will each glow 3 times before moving to next
    _glowQueue.addAll(positions);

    _nextGlow();
  }

  /// Show next keyword glow
  void _nextGlow() {
    if (_glowQueue.isEmpty) {
      // All glowing complete, move to reconstruction phase
      print('All keywords have glowed. Moving to reconstruction phase.');
      _glowTimer?.cancel();
      _startReconstructionPhase();
      return;
    }

    final position = _glowQueue.first;
    final currentState = _gameState.glowStates[position]!;

    // Check if this keyword has glowed 3 times already
    if (currentState.glowCount >= 3) {
      _glowQueue.removeAt(0); // Move to next keyword
      _nextGlow();
      return;
    }

    // Update glow state
    final updatedGlowStates = Map<int, KeywordGlowState>.from(
      _gameState.glowStates,
    );
    updatedGlowStates[position] = currentState.copyWith(
      isCurrentlyGlowing: true,
      glowCount: currentState.glowCount + 1,
    );

    _gameState = _gameState.copyWith(
      glowStates: updatedGlowStates,
      currentGlowingPosition: position,
    );

    print(
      '>>> Glowing position $position, keyword: "${currentState.keyword}", count: ${currentState.glowCount + 1}/3',
    );
    _notifyStateChange();

    // Glow for 2.5 seconds (extended for smoother animation)
    _glowTimer = Timer(const Duration(milliseconds: 2500), () {
      // Stop glowing
      final stopGlowStates = Map<int, KeywordGlowState>.from(
        _gameState.glowStates,
      );
      final updatedState = stopGlowStates[position]!.copyWith(
        isCurrentlyGlowing: false,
      );
      stopGlowStates[position] = updatedState;

      _gameState = _gameState.copyWith(
        glowStates: stopGlowStates,
        clearGlowingPosition: true,
      );
      print('>>> Stopped glowing position $position');
      _notifyStateChange();

      // Wait 0.8 seconds before next glow (slightly longer for smoother transition)
      _glowTimer = Timer(const Duration(milliseconds: 800), () {
        // Check if current keyword needs more glows (it has already glowed once more)
        if (updatedState.glowCount < 3) {
          // Same keyword glows again
          _nextGlow();
        } else {
          // Move to next keyword
          _glowQueue.removeAt(0);
          _nextGlow();
        }
      });
    });
  }

  /// Collect keyword when player clicks during glow
  bool collectKeyword(int position) {
    print('GameService.collectKeyword called for position: $position');

    if (_gameState.phase != GamePhase.glowingPhase) {
      print('Failed: Not in glowing phase. Current phase: ${_gameState.phase}');
      return false;
    }

    if (_gameState.currentGlowingPosition != position) {
      print(
        'Failed: Position mismatch. Expected: ${_gameState.currentGlowingPosition}, Got: $position',
      );
      return false;
    }

    final glowState = _gameState.glowStates[position];
    if (glowState == null) {
      print('Failed: No glow state at position $position');
      return false;
    }

    if (!glowState.isCurrentlyGlowing) {
      print('Failed: Keyword not currently glowing');
      return false;
    }

    // Check if already collected
    if (_gameState.collectedKeywords.contains(glowState.keyword)) {
      print('Failed: Keyword already collected: ${glowState.keyword}');
      return false;
    }

    final updatedKeywords = Set<String>.from(_gameState.collectedKeywords)
      ..add(glowState.keyword);

    _gameState = _gameState.copyWith(collectedKeywords: updatedKeywords);
    print('Success! Collected keyword: ${glowState.keyword}');
    print('Total collected keywords: ${_gameState.collectedKeywords}');
    _notifyStateChange();

    return true;
  }

  /// Start reconstruction phase
  void _startReconstructionPhase() {
    _gameState = _gameState.copyWith(
      phase: GamePhase.reconstructionPhase,
      isGameRunning: true,
    );
    _notifyStateChange();
  }

  /// Place keyword at position (drag or input)
  void placeKeyword(int position, String keyword) {
    if (_gameState.phase != GamePhase.reconstructionPhase) return;

    print('>>> Placing keyword "$keyword" at position $position');

    final updatedPlacements = Map<int, String?>.from(_gameState.placedKeywords)
      ..[position] = keyword;

    _gameState = _gameState.copyWith(placedKeywords: updatedPlacements);

    print('>>> Updated placedKeywords: $updatedPlacements');
    print('>>> All blanks filled: ${_gameState.allBlanksFilled}');

    _notifyStateChange();
  }

  /// Remove keyword from position
  void removeKeywordFromPosition(int position) {
    if (_gameState.phase != GamePhase.reconstructionPhase) return;

    final updatedPlacements = Map<int, String?>.from(_gameState.placedKeywords)
      ..[position] = null;

    _gameState = _gameState.copyWith(placedKeywords: updatedPlacements);
    _notifyStateChange();
  }

  /// Submit and verify reconstruction
  bool submitReconstruction() {
    if (_gameState.phase != GamePhase.reconstructionPhase) return false;

    _gameState = _gameState.copyWith(
      phase: GamePhase.gameOver,
      isGameRunning: false,
    );
    _notifyStateChange();

    return _gameState.isWon;
  }

  /// Get current star rating
  int getStarRating() {
    return _gameState.calculateStarRating();
  }

  /// Get accuracy
  double getAccuracy() {
    return _gameState.calculateAccuracy();
  }

  /// Notify state change
  void _notifyStateChange() {
    onStateChanged?.call(_gameState);
  }

  /// Dispose service
  void dispose() {
    _glowTimer?.cancel();
  }
}
