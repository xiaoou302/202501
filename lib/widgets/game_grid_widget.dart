import 'package:flutter/material.dart';
import '../models/arrow_tile.dart';
import '../models/direction_changer.dart';
import '../models/game_state.dart';
import '../models/obstacle_tile.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';
import 'arrow_tile_widget.dart';
import 'obstacle_tile_widget.dart';

/// Widget for displaying the game grid
class GameGridWidget extends StatelessWidget {
  /// Current game state
  final GameState gameState;

  /// Callback when a tile is clicked
  final Function(int) onTileClicked;

  /// 箭头方向修改回调
  final Function(int, ArrowDirection)? onDirectionChange;

  const GameGridWidget({
    Key? key,
    required this.gameState,
    required this.onTileClicked,
    this.onDirectionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridSize = gameState.currentLevel.gridSize;

    return Container(
      padding: const EdgeInsets.all(UIConstants.gridPadding),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
      ),
      child: AspectRatio(
        aspectRatio: 1.0, // Square grid
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: UIConstants.gridGap,
            mainAxisSpacing: UIConstants.gridGap,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final tile = gameState.currentLayout[index];

            if (tile == null) {
              // Empty cell
              return const SizedBox();
            }

            // Check if this is an obstacle tile
            if (tile.isObstacle) {
              return ObstacleTileWidget(tile: tile as ObstacleTile);
            }

            // Check if this tile can be clicked
            final canBeClicked = GameLogic.canTileBeClicked(gameState, tile.id);

            final isInDirectionChangeMode =
                gameState.directionChanger.isChangingDirection;
            final isSelectedForDirectionChange =
                isInDirectionChangeMode &&
                gameState.directionChanger.selectedArrowIndex == index;

            return ArrowTileWidget(
              tile: tile,
              canBeClicked: isInDirectionChangeMode || canBeClicked,
              onTileClicked: (clickedTile) {
                if (isInDirectionChangeMode) {
                  // 在方向修改模式下，选择箭头
                  onTileClicked(clickedTile.id);
                } else {
                  // 正常游戏模式下，发射箭头
                  onTileClicked(clickedTile.id);
                }
              },
              isInDirectionChangeMode: isInDirectionChangeMode,
              isSelectedForDirectionChange: isSelectedForDirectionChange,
            );
          },
        ),
      ),
    );
  }
}
