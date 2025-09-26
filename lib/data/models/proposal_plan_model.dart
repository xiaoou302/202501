/// 求婚方案数据模型
class ProposalPlanModel {
  final String id;
  final String title;
  final String type; // 方案类型：温馨、热闹、感人等
  final String description; // 方案详细描述
  final List<String> steps; // 方案步骤
  final List<String> materials; // 所需物品
  final String location; // 建议地点
  final String timing; // 建议时间
  final String budget; // 预算范围
  final DateTime createdAt; // 创建时间

  ProposalPlanModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.steps,
    required this.materials,
    required this.location,
    required this.timing,
    required this.budget,
    required this.createdAt,
  });

  // 从JSON构建模型
  factory ProposalPlanModel.fromJson(Map<String, dynamic> json) {
    return ProposalPlanModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      steps: List<String>.from(json['steps'] as List),
      materials: List<String>.from(json['materials'] as List),
      location: json['location'] as String,
      timing: json['timing'] as String,
      budget: json['budget'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'steps': steps,
      'materials': materials,
      'location': location,
      'timing': timing,
      'budget': budget,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 复制并修改
  ProposalPlanModel copyWith({
    String? id,
    String? title,
    String? type,
    String? description,
    List<String>? steps,
    List<String>? materials,
    String? location,
    String? timing,
    String? budget,
    DateTime? createdAt,
  }) {
    return ProposalPlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      materials: materials ?? this.materials,
      location: location ?? this.location,
      timing: timing ?? this.timing,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
