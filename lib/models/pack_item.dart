/// 物品类别枚举
enum PackCategory {
  documents, // 证件
  clothing, // 衣物
  electronics, // 电子产品
  toiletries, // 洗漱用品
  accessories, // 配件饰品
  equipment, // 专业装备
  medications, // 药品
  footwear, // 鞋类
  seasonal, // 季节性物品
  food, // 食品
  childcare, // 儿童用品
  other, // 其他
}

/// 打包物品模型，表示任务中需要的物品或装备
class PackItem {
  final String id;
  final String name;
  final PackCategory category;
  final bool isPacked;
  final int quantity;
  final String? description;
  final String? icon;

  PackItem({
    required this.id,
    required this.name,
    required this.category,
    required this.isPacked,
    required this.quantity,
    this.description,
    this.icon,
  });

  /// 创建一个打包物品的副本
  PackItem copyWith({
    String? id,
    String? name,
    PackCategory? category,
    bool? isPacked,
    int? quantity,
    String? description,
    String? icon,
  }) {
    return PackItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isPacked: isPacked ?? this.isPacked,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  /// 将打包物品转换为JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category.toString().split('.').last,
    'isPacked': isPacked,
    'quantity': quantity,
    'description': description,
    'icon': icon,
  };

  /// 从JSON创建打包物品
  factory PackItem.fromJson(Map<String, dynamic> json) => PackItem(
    id: json['id'],
    name: json['name'],
    category: PackCategory.values.firstWhere(
      (e) => e.toString().split('.').last == json['category'],
      orElse: () => PackCategory.other,
    ),
    isPacked: json['isPacked'],
    quantity: json['quantity'],
    description: json['description'],
    icon: json['icon'],
  );

  /// 获取类别的中文名称
  String get categoryName {
    switch (category) {
      case PackCategory.documents:
        return 'Important Documents';
      case PackCategory.clothing:
        return 'Clothing';
      case PackCategory.electronics:
        return 'Electronics';
      case PackCategory.toiletries:
        return 'Toiletries';
      case PackCategory.accessories:
        return 'Accessories';
      case PackCategory.equipment:
        return 'Equipment';
      case PackCategory.medications:
        return 'Medications';
      case PackCategory.footwear:
        return 'Footwear';
      case PackCategory.seasonal:
        return 'Seasonal Items';
      case PackCategory.food:
        return 'Food & Drinks';
      case PackCategory.childcare:
        return 'Childcare Items';
      case PackCategory.other:
        return 'Other Items';
    }
  }

  /// 获取类别的图标
  String get categoryIcon {
    switch (category) {
      case PackCategory.documents:
        return 'id-card-clip';
      case PackCategory.clothing:
        return 'shirt';
      case PackCategory.electronics:
        return 'plug-circle-bolt';
      case PackCategory.toiletries:
        return 'shower';
      case PackCategory.accessories:
        return 'glasses';
      case PackCategory.equipment:
        return 'toolbox';
      case PackCategory.medications:
        return 'pills';
      case PackCategory.footwear:
        return 'shoe-prints';
      case PackCategory.seasonal:
        return 'umbrella';
      case PackCategory.food:
        return 'utensils';
      case PackCategory.childcare:
        return 'baby';
      case PackCategory.other:
        return 'box';
    }
  }
}
