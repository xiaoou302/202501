/// 数字/字母方块模型
class NumberTile {
  /// 方块ID
  final String id;

  /// 方块中的值（数字或字母序号）
  final int value;

  /// 方块的位置 (0-1范围内的相对位置)
  final double x;
  final double y;

  /// 方块大小
  final double size;

  /// 方块是否被选中
  final bool isSelected;

  /// 方块是否显示值
  final bool showValue;

  /// 元素类型 (数字/字母)
  final String elementType;

  /// 起始值（对于自定义数字序列）
  final int startValue;

  NumberTile({
    required this.id,
    required this.value,
    required this.x,
    required this.y,
    this.size = 60,
    this.isSelected = false,
    this.showValue = true,
    this.elementType = 'numbers',
    this.startValue = 1,
  });

  /// 获取显示的文本
  String get displayText {
    if (elementType == 'letters') {
      // 将数字转换为字母 (0=A, 1=B, ...)
      final int letterIndex = value - 1 + startValue;
      if (letterIndex >= 0 && letterIndex < 26) {
        return String.fromCharCode(65 + letterIndex); // 65 是 'A' 的 ASCII 码
      } else {
        return '?';
      }
    } else {
      // 数字模式
      return (value - 1 + startValue).toString();
    }
  }

  /// 创建选中状态的方块
  NumberTile select() {
    return NumberTile(
      id: id,
      value: value,
      x: x,
      y: y,
      size: size,
      isSelected: true,
      showValue: showValue,
      elementType: elementType,
      startValue: startValue,
    );
  }

  /// 创建隐藏值的方块
  NumberTile hideNumber() {
    return NumberTile(
      id: id,
      value: value,
      x: x,
      y: y,
      size: size,
      isSelected: isSelected,
      showValue: false,
      elementType: elementType,
      startValue: startValue,
    );
  }

  /// 复制方块并修改属性
  NumberTile copyWith({
    String? id,
    int? value,
    double? x,
    double? y,
    double? size,
    bool? isSelected,
    bool? showValue,
    String? elementType,
    int? startValue,
  }) {
    return NumberTile(
      id: id ?? this.id,
      value: value ?? this.value,
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
      isSelected: isSelected ?? this.isSelected,
      showValue: showValue ?? this.showValue,
      elementType: elementType ?? this.elementType,
      startValue: startValue ?? this.startValue,
    );
  }
}
