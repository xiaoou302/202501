/// 行动项模型，表示需要完成的具体任务
class ActionItem {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? description;
  final DateTime? dueDate;

  ActionItem({
    required this.id,
    required this.title,
    required this.isCompleted, //asdasdasdasdasd
    this.completedAt,
    this.description, //asdasdasdasewrwer
    this.dueDate,
  });

  /// 创建一个行动项的副本
  ActionItem copyWith({
    //sadasdasdasd
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
    String? description,
    DateTime? dueDate,
  }) {
    return ActionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: isCompleted == true && isCompleted != this.isCompleted
          ? DateTime.now()
          : completedAt ?? this.completedAt,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// 将行动项转换为JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'description': description,
        'dueDate': dueDate?.toIso8601String(),
      };

  /// 从JSON创建行动项
  factory ActionItem.fromJson(Map<String, dynamic> json) => ActionItem(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        description: json['description'],
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      );
}
