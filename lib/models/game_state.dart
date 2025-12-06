import 'dart:async';
import 'tile_model.dart';

enum GameStatus { idle, memorizing, playing, victory, defeat, deadlock }

class GameState {
  int score;
  int currentLevel;
  MahjongTile? handTile;
  List<MahjongTile> gridTiles;
  int suitStreak;
  bool isProcessing;
  GameStatus status;
  Timer? idleTimer;
  Timer? countdownTimer;
  int remainingSeconds;
  int shuffleCount;
  int swapHandCount;
  bool isPaused;
  String? statusMessage;
  String? sageMessage;
  bool isSageLoading;

  GameState({
    this.score = 0,
    this.currentLevel = 1,
    this.handTile,
    List<MahjongTile>? gridTiles,
    this.suitStreak = 0,
    this.isProcessing = false,
    this.status = GameStatus.idle,
    this.idleTimer,
    this.countdownTimer,
    this.remainingSeconds = 0,
    this.shuffleCount = 3,
    this.swapHandCount = 3,
    this.isPaused = false,
    this.statusMessage,
    this.sageMessage,
    this.isSageLoading = false,
  }) : gridTiles = gridTiles ?? [];

  GameState copyWith({
    int? score,
    int? currentLevel,
    MahjongTile? handTile,
    List<MahjongTile>? gridTiles,
    int? suitStreak,
    bool? isProcessing,
    GameStatus? status,
    Timer? idleTimer,
    Timer? countdownTimer,
    int? remainingSeconds,
    int? shuffleCount,
    int? swapHandCount,
    bool? isPaused,
    String? statusMessage,
    String? sageMessage,
    bool? isSageLoading,
    bool clearHandTile = false,
    bool clearStatusMessage = false,
    bool clearSageMessage = false,
  }) {
    return GameState(
      score: score ?? this.score,
      currentLevel: currentLevel ?? this.currentLevel,
      handTile: clearHandTile ? null : (handTile ?? this.handTile),
      gridTiles: gridTiles ?? this.gridTiles,
      suitStreak: suitStreak ?? this.suitStreak,
      isProcessing: isProcessing ?? this.isProcessing,
      status: status ?? this.status,
      idleTimer: idleTimer ?? this.idleTimer,
      countdownTimer: countdownTimer ?? this.countdownTimer,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      shuffleCount: shuffleCount ?? this.shuffleCount,
      swapHandCount: swapHandCount ?? this.swapHandCount,
      isPaused: isPaused ?? this.isPaused,
      statusMessage: clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
      sageMessage: clearSageMessage ? null : (sageMessage ?? this.sageMessage),
      isSageLoading: isSageLoading ?? this.isSageLoading,
    );
  }

  bool get gameStarted => status == GameStatus.playing;
}
