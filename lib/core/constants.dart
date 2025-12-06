import 'package:flutter/material.dart';

class AppColors {
  static const inkGreen = Color(0xFF0A2F23);
  static const inkGreenLight = Color(0xFF143A2D);
  static const sandalwood = Color(0xFF3E2315);
  static const sandalwoodLight = Color(0xFF5A3A26);
  static const ivory = Color(0xFFF2EBD9);
  static const ivoryDark = Color(0xFFE6DCC3);
  static const vermillion = Color(0xFFB7312C);
  static const jadeBlue = Color(0xFF1B4F72);
  static const jadeGreen = Color(0xFF0E6655);
  static const antiqueGold = Color(0xFFC9A35C);
  static const fluoroGreen = Color(0xFF7FFF00);
}

class AppStrings {
  static const gameTitle = 'PAIKO';
  static const subtitle = 'Mahjong Solitaire';
  static const startGame = 'Start Game';
  static const settings = 'Settings';
  static const home = 'Home';
  static const score = 'Score';
  static const currentHand = 'Current Hand';
  static const shuffle = 'Shuffle';
  static const askSage = 'Ask Sage';
  static const undo = 'Undo';
  static const victory = 'Victory!';
  static const zenFortune = 'Zen Fortune';
  static const returnHome = 'Return Home';
  static const memorize = 'Memorize the board...';
  static const gameStart = 'Game Start!';
  static const noMoves = 'No moves! Auto-Shuffling...';
  static const reshuffled = 'Reshuffled!';
  static const manualShuffle = 'Manual Shuffle (-500)';
  static const streak = 'Streak';
}

class GameConstants {
  static const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  static const chineseNums = ['一', '二', '三', '四', '五', '六', '七', '八', '九'];
  static const gridSize = 20;
  static const gridColumns = 5;
  static const memorizeDuration = Duration(seconds: 3);
  static const idleHintDuration = Duration(seconds: 5);
  static const baseScore = 100;
  static const streakBonus = 50;
  static const shufflePenalty = 500;
  
  // Gemini API
  static const geminiApiKey = ''; // Add your API key here
  static const geminiEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';
}

// Level Configuration
class LevelConfig {
  final int levelNumber;
  final String name;
  final int gridSize;
  final int gridColumns;
  final Duration memorizeDuration;
  final Duration timeLimit; // 倒计时时间
  final int difficulty; // 1-5 stars
  final Color color;

  const LevelConfig({
    required this.levelNumber,
    required this.name,
    required this.gridSize,
    required this.gridColumns,
    required this.memorizeDuration,
    required this.timeLimit,
    required this.difficulty,
    required this.color,
  });
}

class GameLevels {
  static const levels = [
    LevelConfig(
      levelNumber: 1,
      name: 'Beginner',
      gridSize: 12,
      gridColumns: 4,
      memorizeDuration: Duration(seconds: 4),
      timeLimit: Duration(minutes: 3),
      difficulty: 1,
      color: AppColors.jadeGreen,
    ),
    LevelConfig(
      levelNumber: 2,
      name: 'Novice',
      gridSize: 16,
      gridColumns: 4,
      memorizeDuration: Duration(seconds: 3),
      timeLimit: Duration(minutes: 4),
      difficulty: 2,
      color: AppColors.jadeBlue,
    ),
    LevelConfig(
      levelNumber: 3,
      name: 'Apprentice',
      gridSize: 20,
      gridColumns: 5,
      memorizeDuration: Duration(seconds: 3),
      timeLimit: Duration(minutes: 5),
      difficulty: 2,
      color: Color(0xFF2E7D32),
    ),
    LevelConfig(
      levelNumber: 4,
      name: 'Adept',
      gridSize: 24,
      gridColumns: 6,
      memorizeDuration: Duration(seconds: 2),
      timeLimit: Duration(minutes: 6),
      difficulty: 3,
      color: Color(0xFF1565C0),
    ),
    LevelConfig(
      levelNumber: 5,
      name: 'Expert',
      gridSize: 30,
      gridColumns: 6,
      memorizeDuration: Duration(seconds: 2),
      timeLimit: Duration(minutes: 7),
      difficulty: 4,
      color: AppColors.vermillion,
    ),
    LevelConfig(
      levelNumber: 6,
      name: 'Master',
      gridSize: 36,
      gridColumns: 6,
      memorizeDuration: Duration(seconds: 1),
      timeLimit: Duration(minutes: 8),
      difficulty: 4,
      color: Color(0xFF6A1B9A),
    ),
    LevelConfig(
      levelNumber: 7,
      name: 'Grandmaster',
      gridSize: 42,
      gridColumns: 7,
      memorizeDuration: Duration(seconds: 1),
      timeLimit: Duration(minutes: 9),
      difficulty: 5,
      color: Color(0xFFD84315),
    ),
    LevelConfig(
      levelNumber: 8,
      name: 'Legend',
      gridSize: 48,
      gridColumns: 8,
      memorizeDuration: Duration(milliseconds: 800),
      timeLimit: Duration(minutes: 10),
      difficulty: 5,
      color: Color(0xFF880E4F),
    ),
  ];
}
