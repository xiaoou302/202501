import '../../data/models/mahjong_tile_model.dart';
import '../repositories/game_repository_interface.dart';

/// Use case for generating a level
class GenerateLevelUseCase {
  final IGameRepository _gameRepository;

  /// Constructor
  GenerateLevelUseCase(this._gameRepository);

  /// Executes the use case to generate a level
  Future<List<MahjongTile>> execute(int level) async {
    return _gameRepository.generateSolvableBoard(level);
  }
}
