/// 用户数据模型
class UserModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final int memoryCount;
  final int albumCount;
  final int proposalCount;

  UserModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.memoryCount = 0,
    this.albumCount = 0,
    this.proposalCount = 0,
  });

  // 从JSON构建模型
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      memoryCount: json['memoryCount'] as int? ?? 0,
      albumCount: json['albumCount'] as int? ?? 0,
      proposalCount: json['proposalCount'] as int? ?? 0,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'memoryCount': memoryCount,
      'albumCount': albumCount,
      'proposalCount': proposalCount,
    };
  }

  // 复制并修改
  UserModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? memoryCount,
    int? albumCount,
    int? proposalCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memoryCount: memoryCount ?? this.memoryCount,
      albumCount: albumCount ?? this.albumCount,
      proposalCount: proposalCount ?? this.proposalCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.avatarUrl == avatarUrl &&
        other.memoryCount == memoryCount &&
        other.albumCount == albumCount &&
        other.proposalCount == proposalCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatarUrl.hashCode ^
        memoryCount.hashCode ^
        albumCount.hashCode ^
        proposalCount.hashCode;
  }
}
