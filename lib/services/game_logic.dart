import 'dart:math';
import '../models/card_model.dart';

class GameLogic {
  // 生成一副完整的扑克牌
  static List<CardModel> generateDeck() {
    final List<CardModel> deck = [];
    int id = 0;
    
    for (var suit in CardSuit.values) {
      for (var rank in CardRank.values) {
        deck.add(CardModel(
          id: 'card_${id++}',
          suit: suit,
          rank: rank,
          isFaceUp: false,
        ));
      }
    }
    
    return deck;
  }

  // 洗牌
  static List<CardModel> shuffleDeck(List<CardModel> deck) {
    final shuffled = List<CardModel>.from(deck);
    final random = Random();
    
    for (int i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    
    return shuffled;
  }

  // 初始化游戏布局（7列桌面 + 剩余牌堆）
  // 返回: {tableau: 桌面7列, stock: 剩余牌堆}
  static Map<String, dynamic> initializeGame(List<CardModel> deck) {
    final List<List<CardModel>> tableau = List.generate(7, (_) => []);
    final List<CardModel> stock = [];
    int cardIndex = 0;

    // 第1列1张，第2列2张...第7列7张（共28张）
    for (int col = 0; col < 7; col++) {
      for (int row = 0; row <= col; row++) {
        if (cardIndex < deck.length) {
          final card = deck[cardIndex];
          // 每列最后一张牌翻开
          final isFaceUp = row == col;
          tableau[col].add(card.copyWith(
            isFaceUp: isFaceUp,
            status: CardStatus.tableau,
          ));
          cardIndex++;
        }
      }
    }

    // 剩余的24张牌放入牌堆
    while (cardIndex < deck.length) {
      stock.add(deck[cardIndex].copyWith(
        isFaceUp: false,
        status: CardStatus.hand,
      ));
      cardIndex++;
    }

    return {
      'tableau': tableau,
      'stock': stock,
    };
  }

  // 保留旧方法以兼容（已废弃）
  @deprecated
  static List<List<CardModel>> initializeTableau(List<CardModel> deck) {
    return initializeGame(deck)['tableau'] as List<List<CardModel>>;
  }

  // 检查是否可以移动到桌面列
  static bool canMoveToTableau(CardModel card, List<CardModel> targetColumn) {
    if (targetColumn.isEmpty) {
      // 空列只能放K
      return card.rank == CardRank.king;
    }

    final topCard = targetColumn.last;
    // 必须颜色交替且点数递减
    return card.isRed != topCard.isRed && 
           card.rankValue == topCard.rankValue - 1;
  }

  // 检查是否可以移动到核心区
  static bool canMoveToFoundation(CardModel card, List<CardModel> foundation) {
    if (foundation.isEmpty) {
      // 空核心区只能放A
      return card.rank == CardRank.ace;
    }

    final topCard = foundation.last;
    // 必须同花色且点数递增
    return card.suit == topCard.suit && 
           card.rankValue == topCard.rankValue + 1;
  }

  // 检查是否可以移动到缓冲区
  static bool canMoveToBuffer(List<CardModel> buffer, int maxBufferSize) {
    return buffer.length < maxBufferSize;
  }

  // 从牌堆翻牌（每次翻1张）
  static Map<String, List<CardModel>> drawFromDeck(
    List<CardModel> deck,
    List<CardModel> waste,
  ) {
    if (deck.isEmpty) {
      // 如果牌堆空了，将翻牌堆的牌重新放回牌堆
      return {
        'deck': waste.reversed.map((card) => card.copyWith(isFaceUp: false)).toList(),
        'waste': <CardModel>[],
      };
    }

    // 从牌堆顶部翻一张牌到翻牌堆
    final newDeck = List<CardModel>.from(deck);
    final newWaste = List<CardModel>.from(waste);
    
    final drawnCard = newDeck.removeLast().copyWith(isFaceUp: true);
    newWaste.add(drawnCard);

    return {
      'deck': newDeck,
      'waste': newWaste,
    };
  }

  // 检查是否可以从翻牌堆移动牌
  static bool canMoveFromWaste(List<CardModel> waste) {
    return waste.isNotEmpty;
  }

  // 获取可移动的卡牌序列（从某张牌到列底的所有牌）
  static List<CardModel> getMovableSequence(List<CardModel> column, int startIndex) {
    if (startIndex >= column.length) return [];
    
    final sequence = <CardModel>[];
    sequence.add(column[startIndex]);

    // 检查后续牌是否形成有效序列
    for (int i = startIndex + 1; i < column.length; i++) {
      final prevCard = column[i - 1];
      final currentCard = column[i];
      
      if (currentCard.isRed != prevCard.isRed && 
          currentCard.rankValue == prevCard.rankValue - 1) {
        sequence.add(currentCard);
      } else {
        break;
      }
    }

    return sequence;
  }

  // 检查游戏是否胜利
  static bool checkWin(List<List<CardModel>> foundations) {
    for (var foundation in foundations) {
      if (foundation.length != 13) return false;
    }
    return true;
  }

  // 自动完成（当所有牌都翻开且可以直接收集时）
  static bool canAutoComplete(
    List<List<CardModel>> tableau,
    List<CardModel> buffer,
  ) {
    // 检查是否所有牌都已翻开
    for (var column in tableau) {
      for (var card in column) {
        if (!card.isFaceUp) return false;
      }
    }
    return true;
  }

  // 获取提示（找到一个可行的移动）
  static Map<String, dynamic>? getHint(
    List<List<CardModel>> tableau,
    List<CardModel> buffer,
    List<List<CardModel>> foundations,
    List<CardModel> waste,
  ) {
    // 优先检查是否可以移动到核心区
    for (int colIndex = 0; colIndex < tableau.length; colIndex++) {
      final column = tableau[colIndex];
      if (column.isNotEmpty) {
        final card = column.last;
        if (card.isFaceUp) {
          for (int foundIndex = 0; foundIndex < foundations.length; foundIndex++) {
            if (canMoveToFoundation(card, foundations[foundIndex])) {
              return {
                'type': 'tableau_to_foundation',
                'from': colIndex,
                'to': foundIndex,
                'card': card,
              };
            }
          }
        }
      }
    }

    // 检查翻牌堆到核心区
    if (waste.isNotEmpty) {
      final card = waste.last;
      for (int foundIndex = 0; foundIndex < foundations.length; foundIndex++) {
        if (canMoveToFoundation(card, foundations[foundIndex])) {
          return {
            'type': 'waste_to_foundation',
            'to': foundIndex,
            'card': card,
          };
        }
      }
    }

    // 检查缓冲区到核心区
    for (int bufIndex = 0; bufIndex < buffer.length; bufIndex++) {
      final card = buffer[bufIndex];
      for (int foundIndex = 0; foundIndex < foundations.length; foundIndex++) {
        if (canMoveToFoundation(card, foundations[foundIndex])) {
          return {
            'type': 'buffer_to_foundation',
            'from': bufIndex,
            'to': foundIndex,
            'card': card,
          };
        }
      }
    }

    // 检查翻牌堆到桌面
    if (waste.isNotEmpty) {
      final card = waste.last;
      for (int toCol = 0; toCol < tableau.length; toCol++) {
        if (canMoveToTableau(card, tableau[toCol])) {
          return {
            'type': 'waste_to_tableau',
            'to': toCol,
            'card': card,
          };
        }
      }
    }

    // 检查桌面列之间的移动
    for (int fromCol = 0; fromCol < tableau.length; fromCol++) {
      final column = tableau[fromCol];
      if (column.isEmpty) continue;

      for (int cardIndex = 0; cardIndex < column.length; cardIndex++) {
        final card = column[cardIndex];
        if (!card.isFaceUp) continue;

        for (int toCol = 0; toCol < tableau.length; toCol++) {
          if (fromCol == toCol) continue;
          
          if (canMoveToTableau(card, tableau[toCol])) {
            return {
              'type': 'tableau_to_tableau',
              'from': fromCol,
              'to': toCol,
              'cardIndex': cardIndex,
              'card': card,
            };
          }
        }
      }
    }

    return null;
  }

  // 计算星级评价
  static int calculateStars(Duration time, int moves) {
    // 基于时间和步数的简单评分系统
    int stars = 3;
    
    if (time.inSeconds > 300 || moves > 150) stars = 2;
    if (time.inSeconds > 600 || moves > 200) stars = 1;
    
    return stars;
  }
}
