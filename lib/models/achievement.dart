/// 成就数据模型
class Achievement {
  /// 成就唯一标识符
  final String id;

  /// 成就标题
  final String title;

  /// 成就描述
  final String description;

  /// 成就图标
  final String icon;

  /// 当前进度
  final int progress;

  /// 完成所需的最大进度
  final int maxProgress;

  /// 成就是否已完成
  final bool isCompleted;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.maxProgress,
    this.isCompleted = false,
  });

  /// 从 JSON 创建成就实例
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      progress: json['progress'] as int,
      maxProgress: json['maxProgress'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// 将成就转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'progress': progress,
      'maxProgress': maxProgress,
      'isCompleted': isCompleted,
    };
  }

  /// 更新成就进度
  Achievement updateProgress(int newProgress) {
    final updatedProgress = newProgress;
    final updatedIsCompleted = updatedProgress >= maxProgress;

    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      progress: updatedProgress,
      maxProgress: maxProgress,
      isCompleted: updatedIsCompleted,
    );
  }
}
