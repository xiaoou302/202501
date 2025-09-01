/// 游戏能力道具模型
class PowerUp {
  /// 能力道具唯一标识符
  final String id;

  /// 能力道具名称
  final String name;

  /// 能力道具图标
  final String icon;

  /// 能力道具描述
  final String description;

  /// 能力道具是否可用
  final bool isAvailable;

  PowerUp({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.isAvailable = true,
  });

  /// 创建已使用的能力道具
  PowerUp use() {
    return PowerUp(
      id: id,
      name: name,
      icon: icon,
      description: description,
      isAvailable: false,
    );
  }

  /// 创建重置的能力道具
  PowerUp reset() {
    return PowerUp(
      id: id,
      name: name,
      icon: icon,
      description: description,
      isAvailable: true,
    );
  }

  /// 复制能力道具
  PowerUp copyWith({
    String? id,
    String? name,
    String? icon,
    String? description,
    bool? isAvailable,
  }) {
    return PowerUp(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
