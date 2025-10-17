import '../../data/models/mahjong_tile_model.dart';
import '../../core/utils/game_utils.dart';

/// Use case for checking matches in the hand
class CheckMatchUseCase {
  /// Executes the use case to check for matches
  List<MahjongTile> execute(List<MahjongTile> handState) {
    return GameUtils.removeMatches(handState);
  }

  /// Checks if there are any matches in the hand
  bool hasMatches(List<MahjongTile> handState) {
    return GameUtils.hasMatches(handState);
  }
}
