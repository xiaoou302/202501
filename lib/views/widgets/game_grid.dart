import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/game_viewmodel.dart';
import 'mahjong_tile.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, _) {
        final columns = viewModel.currentLevel.gridColumns;
        // 根据列数动态调整间距
        final spacing = _getSpacing(columns);
        final padding = _getPadding(columns);
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 0.7,
            ),
            itemCount: viewModel.gridTiles.length,
            itemBuilder: (context, index) {
              final tile = viewModel.gridTiles[index];
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: tile.isActive ? 1.0 : 0.0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: tile.isActive ? 1.0 : 0.5,
                  child: MahjongTileWidget(
                    tile: tile,
                    gridColumns: columns,
                    onTap: () => viewModel.handleTileTap(tile.id),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 根据列数动态计算间距
  double _getSpacing(int columns) {
    switch (columns) {
      case 4:
        return 12.0;
      case 5:
        return 12.0;
      case 6:
        return 10.0;
      case 7:
        return 8.0;
      case 8:
        return 6.0;
      default:
        return 12.0;
    }
  }

  // 根据列数动态计算外边距
  double _getPadding(int columns) {
    switch (columns) {
      case 4:
      case 5:
        return 16.0;
      case 6:
        return 12.0;
      case 7:
        return 10.0;
      case 8:
        return 8.0;
      default:
        return 16.0;
    }
  }
}
