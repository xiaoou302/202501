/// This file contains the app description in both English and Chinese
/// for use throughout the application.

class AppDescription {
  /// English app description - short version
  static const String shortDescriptionEn =
      'A strategic puzzle-matching game that challenges your pattern recognition skills.';

  /// Chinese app description - short version
  static const String shortDescriptionZh = '一款策略性的拼图匹配游戏，挑战您的模式识别能力。';

  /// English app description - full version
  static const String fullDescriptionEn = '''
Blokko is a strategic puzzle-matching game that challenges your pattern recognition skills. In this addictive game, players must clear blocks from the board by matching them according to specific templates.

Game Features:
- Strategic Gameplay: Select adjacent blocks and match them with templates to clear the board
- Multiple Game Modes: Choose between 6x6 Classic mode for beginners or 8x8 Challenge mode for experienced players
- Progressive Difficulty: Start with simple levels and advance to more challenging puzzles
- Achievement System: Unlock achievements as you improve your skills and strategy
- Leaderboards: Compete for the fastest completion times and track your progress
- Beautiful Design: Enjoy a modern, clean interface with smooth animations and vibrant colors

Blokko is perfect for puzzle enthusiasts of all ages who enjoy strategic thinking and pattern matching. Each game is unique, offering endless replayability and challenging your spatial awareness and planning abilities.
''';

  /// Chinese app description - full version
  static const String fullDescriptionZh = '''
Blokko 是一款策略性的拼图匹配游戏，挑战您的模式识别能力。在这款引人入胜的游戏中，玩家需要通过匹配特定模板来清除棋盘上的方块。

游戏特点:
- 策略性玩法：选择相邻方块并与模板匹配以清除棋盘
- 多种游戏模式：选择适合初学者的 6x6 经典模式或适合有经验玩家的 8x8 挑战模式
- 渐进式难度：从简单关卡开始，逐步挑战更具挑战性的谜题
- 成就系统：随着技能和策略的提升解锁成就
- 排行榜：争夺最快完成时间并跟踪您的进度
- 精美设计：享受现代、简洁的界面，流畅的动画和鲜艳的颜色

Blokko 适合所有年龄段喜欢策略思考和模式匹配的拼图爱好者。每局游戏都是独特的，提供无尽的可重玩性，挑战您的空间感知和规划能力。
''';

  /// Get short description based on language code
  static String getShortDescription(String languageCode) {
    return languageCode == 'zh_CN' ? shortDescriptionZh : shortDescriptionEn;
  }

  /// Get full description based on language code
  static String getFullDescription(String languageCode) {
    return languageCode == 'zh_CN' ? fullDescriptionZh : fullDescriptionEn;
  }

  /// Game rules in English
  static const String gameRulesEn = '''
1. Select two adjacent blocks (horizontally or vertically) on the board.
2. Match these blocks with one of the templates shown at the bottom.
3. Blocks are permanently removed when matched (no refilling).
4. Win by clearing all blocks from the board.
5. Isolated blocks (with no adjacent unremoved blocks) can match with any other block.
''';

  /// Game rules in Chinese
  static const String gameRulesZh = '''
1. 在棋盘上选择两个相邻的方块（水平或垂直）。
2. 将这些方块与底部显示的模板之一匹配。
3. 匹配的方块将被永久移除（不会补充）。
4. 清除棋盘上的所有方块即可获胜。
5. 孤立的方块（周围没有未移除的方块）可以与任何其他方块匹配。
''';
}
