class UserProfile {
  final String name;
  final String partnerName;
  bool darkModeEnabled;
  bool notificationsEnabled;

  UserProfile({
    required this.name,
    required this.partnerName,
    this.darkModeEnabled = true,
    this.notificationsEnabled = true,
  });

  // 从JSON创建对象
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      partnerName: json['partnerName'] as String,
      darkModeEnabled: json['darkModeEnabled'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'partnerName': partnerName,
      'darkModeEnabled': darkModeEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  // 创建更新后的副本
  UserProfile copyWith({
    String? name,
    String? partnerName,
    bool? darkModeEnabled,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      partnerName: partnerName ?? this.partnerName,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
