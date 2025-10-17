import '../../data/models/mahjong_tile_model.dart';
import '../../core/utils/game_utils.dart';

/// Use case for updating the selectable status of tiles
class UpdateSelectableTilesUseCase {
  /// Executes the use case to update selectable tiles
  List<MahjongTile> execute(List<MahjongTile> boardState) {
    return GameUtils.updateSelectableTiles(boardState);
  }
}
