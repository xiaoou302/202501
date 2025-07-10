/// 任务优先级枚举
enum TaskPriority {
  /// 紧急重要
  urgentImportant,

  /// 重要不紧急
  importantNotUrgent,

  /// 紧急不重要
  urgentNotImportant,

  /// 不紧急不重要
  notUrgentNotImportant,
}

/// 任务模型
class TaskModel {
  /// 唯一标识
  final String id;

  /// 任务标题
  final String title;

  /// 任务描述（可选）
  final String? description;

  /// 截止日期
  final DateTime dueDate;

  /// 任务优先级（四象限分类）
  final TaskPriority priority;

  /// 是否已完成
  final bool isCompleted;

  /// 构造函数
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  /// 从JSON创建任务
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values[json['priority'] as int],
      isCompleted: json['isCompleted'] as bool,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'isCompleted': isCompleted,
    };
  }

  /// 复制任务并修改部分属性
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
