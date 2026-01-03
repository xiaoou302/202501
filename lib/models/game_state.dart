import 'card_model.dart';

enum GameStatus { notStarted, playing, paused, won, lost }

class GameState {
  final String currentLevelId;
  final DateTime startTime;
  final Duration elapsedTime;
  final int movesCount;
  final List<CardModel> bufferCards;
  final List<List<CardModel>> foundationSlots;
  final List<List<CardModel>> tableauColumns;
  final List<CardModel> deck; // 牌堆（未翻开的牌）
  final List<CardModel> waste; // 翻牌堆（已翻开的牌）
  final GameStatus status;

  GameState({
    required this.currentLevelId,
    required this.startTime,
    this.elapsedTime = Duration.zero,
    this.movesCount = 0,
    this.bufferCards = const [],
    this.foundationSlots = const [],
    this.tableauColumns = const [],
    this.deck = const [],
    this.waste = const [],
    this.status = GameStatus.notStarted,
  });

  GameState copyWith({
    Duration? elapsedTime,
    int? movesCount,
    List<CardModel>? bufferCards,
    List<List<CardModel>>? foundationSlots,
    List<List<CardModel>>? tableauColumns,
    List<CardModel>? deck,
    List<CardModel>? waste,
    GameStatus? status,
  }) {
    return GameState(
      currentLevelId: currentLevelId,
      startTime: startTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      movesCount: movesCount ?? this.movesCount,
      bufferCards: bufferCards ?? this.bufferCards,
      foundationSlots: foundationSlots ?? this.foundationSlots,
      tableauColumns: tableauColumns ?? this.tableauColumns,
      deck: deck ?? this.deck,
      waste: waste ?? this.waste,
      status: status ?? this.status,
    );
  }
}
