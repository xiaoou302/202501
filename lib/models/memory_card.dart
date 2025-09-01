/// 卡片颜色枚举
enum CardColor { blue, green, orange, purple, red, teal, pink, amber }

/// 记忆游戏卡片模型
class MemoryCard {
  /// 卡片唯一标识符
  final String id;

  /// 卡片图标
  final String icon;

  /// 卡片是否已翻开
  final bool isFlipped;

  /// 卡片是否已匹配
  final bool isMatched;

  /// 卡片颜色
  final CardColor cardColor;

  /// 卡片类别
  final String category;

  /// 卡片得分倍数
  final double scoreMultiplier;

  MemoryCard({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
    this.cardColor = CardColor.blue,
    this.category = 'standard',
    this.scoreMultiplier = 1.0,
  });

  /// 创建翻转后的卡片
  MemoryCard flip() {
    return MemoryCard(
      id: id,
      icon: icon,
      isFlipped: !isFlipped,
      isMatched: isMatched,
      cardColor: cardColor,
      category: category,
      scoreMultiplier: scoreMultiplier,
    );
  }

  /// 创建匹配后的卡片
  MemoryCard match() {
    return MemoryCard(
      id: id,
      icon: icon,
      isFlipped: true,
      isMatched: true,
      cardColor: cardColor,
      category: category,
      scoreMultiplier: scoreMultiplier,
    );
  }

  /// 创建重置后的卡片
  MemoryCard reset() {
    return MemoryCard(
      id: id,
      icon: icon,
      isFlipped: false,
      isMatched: false,
      cardColor: cardColor,
      category: category,
      scoreMultiplier: scoreMultiplier,
    );
  }

  /// 复制卡片
  MemoryCard copyWith({
    String? id,
    String? icon,
    bool? isFlipped,
    bool? isMatched,
    CardColor? cardColor,
    String? category,
    double? scoreMultiplier,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      cardColor: cardColor ?? this.cardColor,
      category: category ?? this.category,
      scoreMultiplier: scoreMultiplier ?? this.scoreMultiplier,
    );
  }
}
