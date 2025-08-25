/// 成就模型
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon; // FontAwesome图标名称
  bool isUnlocked;
  double progress; // 0.0 - 1.0
  final int targetValue; // 达成目标所需的值

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.progress = 0.0,
    required this.targetValue,
  });

  // 更新进度
  void updateProgress(int currentValue) {
    progress = targetValue > 0
        ? (currentValue / targetValue).clamp(0.0, 1.0)
        : 0.0;
    if (progress >= 1.0) {
      isUnlocked = true;
    }
  }

  // 序列化为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'progress': progress,
      'targetValue': targetValue,
    };
  }

  // 从JSON反序列化
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      isUnlocked: json['isUnlocked'] ?? false,
      progress: json['progress'] ?? 0.0,
      targetValue: json['targetValue'],
    );
  }

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, isUnlocked: $isUnlocked, progress: $progress)';
  }
}

/// 预定义的成就列表
class Achievements {
  static List<Achievement> getAll() {
    return [
      Achievement(
        id: 'first_contact',
        title: 'First Contact',
        description: 'Complete your first perfect match',
        icon: 'fa-atom',
        targetValue: 1,
      ),
      Achievement(
        id: 'color_master',
        title: 'Color Master',
        description: 'Eliminate 10,000 units by color matching',
        icon: 'fa-palette',
        targetValue: 10000,
      ),
      Achievement(
        id: 'shape_scholar',
        title: 'Shape Scholar',
        description: 'Eliminate 10,000 units by shape matching',
        icon: 'fa-shapes',
        targetValue: 10000,
      ),
      Achievement(
        id: 'transmuter',
        title: 'Transmuter',
        description: 'Use the transmute ability 100 times',
        icon: 'fa-exchange-alt',
        targetValue: 100,
      ),
      Achievement(
        id: 'chain_reaction',
        title: 'Chain Reaction',
        description: 'Trigger a combo chain of 5 or more in one move',
        icon: 'fa-infinity',
        targetValue: 1,
      ),
      Achievement(
        id: 'perfectionist',
        title: 'Perfectionist',
        description: 'Complete any level with 5 or more moves remaining',
        icon: 'fa-crown',
        targetValue: 1,
      ),
      Achievement(
        id: 'final_enlightenment',
        title: 'Final Enlightenment',
        description: 'Complete all campaign levels',
        icon: 'fa-brain',
        targetValue: 6,
      ),
    ];
  }
}
