import '../constants/mahjong_constants.dart';
import '../../data/models/mahjong_tile_model.dart';

/// Utility functions for the Jongara game
class GameUtils {
  // Private constructor to prevent instantiation
  GameUtils._();

  /// Checks if two tiles are overlapping
  static bool isOverlapping(MahjongTile tileA, MahjongTile tileB) {
    final rectA = {
      'left': tileA.x,
      'right': tileA.x + 48, // Using fixed width for simplicity
      'top': tileA.y,
      'bottom': tileA.y + 68, // Using fixed height for simplicity
    };

    final rectB = {
      'left': tileB.x,
      'right': tileB.x + 48,
      'top': tileB.y,
      'bottom': tileB.y + 68,
    };

    return !(rectA['right']! < rectB['left']! ||
        rectA['left']! > rectB['right']! ||
        rectA['bottom']! < rectB['top']! ||
        rectA['top']! > rectB['bottom']!);
  }

  /// Determines which tiles are selectable (not blocked by other tiles)
  static List<MahjongTile> getSelectableTiles(List<MahjongTile> boardState) {
    final selectableTiles = <MahjongTile>[];

    for (final tile in boardState) {
      bool isBlocked = false;

      for (final otherTile in boardState) {
        if (tile.id != otherTile.id &&
            otherTile.z > tile.z &&
            isOverlapping(tile, otherTile)) {
          isBlocked = true;
          break;
        }
      }

      if (!isBlocked) {
        selectableTiles.add(tile.copyWith(isSelectable: true));
      }
    }

    return selectableTiles;
  }

  /// Updates the selectable status of tiles in the board state
  static List<MahjongTile> updateSelectableTiles(List<MahjongTile> boardState) {
    final updatedBoard = <MahjongTile>[];

    for (final tile in boardState) {
      bool isBlocked = false;

      for (final otherTile in boardState) {
        if (tile.id != otherTile.id &&
            otherTile.z > tile.z &&
            isOverlapping(tile, otherTile)) {
          isBlocked = true;
          break;
        }
      }

      updatedBoard.add(tile.copyWith(isSelectable: !isBlocked));
    }

    return updatedBoard;
  }

  /// Generates a set of tiles for a level
  static List<String> generateLevelTiles(int tileCount) {
    if (tileCount % 3 != 0) {
      throw ArgumentError('Level tile count must be a multiple of 3');
    }

    final neededTypes = tileCount ~/ 3;
    final shuffledSet = List<String>.from(MahjongConstants.allTiles)..shuffle();
    final selectedTypes = shuffledSet.take(neededTypes).toList();

    final deck = <String>[];
    for (final type in selectedTypes) {
      for (int i = 0; i < 3; i++) {
        deck.add(type);
      }
    }

    return deck..shuffle();
  }

  /// 检查是否有三个相同的牌可以消除
  static bool hasThreeOfAKindMatch(List<MahjongTile> handState) {
    final counts = <String, int>{};

    for (final tile in handState) {
      counts[tile.type] = (counts[tile.type] ?? 0) + 1;
    }

    for (final count in counts.values) {
      if (count >= 3) {
        return true;
      }
    }

    return false;
  }

  /// 检查是否有顺子可以消除（如1万、2万、3万）
  static bool hasSequenceMatch(List<MahjongTile> handState) {
    // 按花色分组
    final wanTiles = <int>[];
    final tongTiles = <int>[];
    final tiaoTiles = <int>[];

    // 收集每种花色的数字
    for (final tile in handState) {
      if (tile.type.startsWith(MahjongConstants.wanSuit)) {
        wanTiles.add(int.parse(tile.type.substring(1)));
      } else if (tile.type.startsWith(MahjongConstants.tongSuit)) {
        tongTiles.add(int.parse(tile.type.substring(1)));
      } else if (tile.type.startsWith(MahjongConstants.tiaoSuit)) {
        tiaoTiles.add(int.parse(tile.type.substring(1)));
      }
    }

    // 检查每种花色是否有连续的三个数字
    return _hasSequenceInSuit(wanTiles) ||
        _hasSequenceInSuit(tongTiles) ||
        _hasSequenceInSuit(tiaoTiles);
  }

  /// 检查某一花色中是否有连续的三个数字
  static bool _hasSequenceInSuit(List<int> numbers) {
    if (numbers.length < 3) return false;

    // 排序
    numbers.sort();

    // 检查是否有连续的三个数字
    for (int i = 0; i <= numbers.length - 3; i++) {
      if (numbers.contains(numbers[i] + 1) &&
          numbers.contains(numbers[i] + 2)) {
        return true;
      }
    }

    return false;
  }

  /// 检查手牌中是否有任何可消除的组合（三个相同或顺子）
  static bool hasMatches(List<MahjongTile> handState) {
    return hasThreeOfAKindMatch(handState) || hasSequenceMatch(handState);
  }

  /// Removes matches from the hand
  static List<MahjongTile> removeMatches(List<MahjongTile> handState) {
    // 先检查是否有三个相同的牌可以消除
    final threeOfAKindMatch = _findThreeOfAKindMatch(handState);
    if (threeOfAKindMatch != null) {
      return _removeThreeOfAKindMatch(handState, threeOfAKindMatch);
    }

    // 如果没有三个相同的牌，检查是否有顺子可以消除
    final sequenceMatch = _findSequenceMatch(handState);
    if (sequenceMatch != null) {
      return _removeSequenceMatch(handState, sequenceMatch);
    }

    // 没有找到任何可消除的组合
    return handState;
  }

  /// 查找三个相同的牌
  static String? _findThreeOfAKindMatch(List<MahjongTile> handState) {
    final counts = <String, int>{};

    for (final tile in handState) {
      counts[tile.type] = (counts[tile.type] ?? 0) + 1;
    }

    for (final type in counts.keys) {
      if (counts[type]! >= 3) {
        return type;
      }
    }

    return null;
  }

  /// 移除三个相同的牌
  static List<MahjongTile> _removeThreeOfAKindMatch(
    List<MahjongTile> handState,
    String type,
  ) {
    final updatedHand = <MahjongTile>[];
    var removedCount = 0;

    for (final tile in handState) {
      if (tile.type == type && removedCount < 3) {
        removedCount++;
      } else {
        updatedHand.add(tile);
      }
    }

    return updatedHand;
  }

  /// 查找顺子
  static List<String>? _findSequenceMatch(List<MahjongTile> handState) {
    // 按花色分组
    final Map<String, List<int>> suitGroups = {
      MahjongConstants.wanSuit: <int>[],
      MahjongConstants.tongSuit: <int>[],
      MahjongConstants.tiaoSuit: <int>[],
    };

    // 收集每种花色的数字
    for (final tile in handState) {
      if (tile.type.startsWith(MahjongConstants.wanSuit)) {
        suitGroups[MahjongConstants.wanSuit]!.add(
          int.parse(tile.type.substring(1)),
        );
      } else if (tile.type.startsWith(MahjongConstants.tongSuit)) {
        suitGroups[MahjongConstants.tongSuit]!.add(
          int.parse(tile.type.substring(1)),
        );
      } else if (tile.type.startsWith(MahjongConstants.tiaoSuit)) {
        suitGroups[MahjongConstants.tiaoSuit]!.add(
          int.parse(tile.type.substring(1)),
        );
      }
    }

    // 检查每种花色是否有顺子
    for (final suit in suitGroups.keys) {
      final numbers = suitGroups[suit]!;
      if (numbers.length < 3) continue;

      numbers.sort();

      for (int i = 0; i <= numbers.length - 3; i++) {
        if (numbers.contains(numbers[i] + 1) &&
            numbers.contains(numbers[i] + 2)) {
          // 找到顺子，返回牌型列表
          return [
            '$suit${numbers[i]}',
            '$suit${numbers[i] + 1}',
            '$suit${numbers[i] + 2}',
          ];
        }
      }
    }

    return null;
  }

  /// 移除顺子
  static List<MahjongTile> _removeSequenceMatch(
    List<MahjongTile> handState,
    List<String> sequence,
  ) {
    final updatedHand = <MahjongTile>[];
    final tilesToRemove = List<String>.from(sequence);

    for (final tile in handState) {
      if (tilesToRemove.contains(tile.type)) {
        tilesToRemove.remove(tile.type);
      } else {
        updatedHand.add(tile);
      }
    }

    return updatedHand;
  }
}
