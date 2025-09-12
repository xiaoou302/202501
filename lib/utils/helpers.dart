import 'dart:math';
import 'package:flutter/material.dart';
import '../models/block.dart';
import '../utils/constants.dart';

/// 辅助函数集合

/// 格式化时间为 MM:SS 格式
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

/// 格式化日期为 YYYY-MM-DD 格式
String formatDate(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
}

/// 格式化时间为 HH:MM:SS 格式
String formatTime(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
}

/// 计算胜率百分比
String calculateWinRate(int gamesWon, int gamesPlayed) {
  if (gamesPlayed == 0) return '0%';
  final rate = (gamesWon / gamesPlayed) * 100;
  return '${rate.toStringAsFixed(0)}%';
}

/// 根据颜色名称获取对应的颜色
Color getColorByName(String colorName) {
  switch (colorName) {
    case 'coral_pink':
      return AppColors.blockCoralPink;
    case 'sunny_yellow':
      return AppColors.blockSunnyYellow;
    case 'sky_blue':
      return AppColors.blockSkyBlue;
    case 'grape_purple':
      return AppColors.blockGrapePurple;
    case 'jade_green':
      return AppColors.blockJadeGreen;
    case 'terracotta_orange':
      return AppColors.blockTerracottaOrange;
    default:
      return AppColors.blockCoralPink;
  }
}

/// 获取所有可用的方块颜色
List<Color> getAllBlockColors() {
  return [
    AppColors.blockCoralPink,
    AppColors.blockSunnyYellow,
    AppColors.blockSkyBlue,
    AppColors.blockGrapePurple,
    AppColors.blockJadeGreen,
    AppColors.blockTerracottaOrange,
  ];
}

/// 随机生成棋盘数据
List<List<Block>> generateRandomBoard(int gridSize) {
  final List<Color> colors = getAllBlockColors();
  final List<List<Block>> board = [];
  final random = Random();

  for (int i = 0; i < gridSize; i++) {
    final List<Block> row = [];
    for (int j = 0; j < gridSize; j++) {
      // 使用真正的随机数生成器来选择颜色
      final randomIndex = random.nextInt(colors.length);
      row.add(Block(
        color: colors[randomIndex],
        row: i,
        col: j,
      ));
    }
    board.add(row);
  }

  return board;
}
