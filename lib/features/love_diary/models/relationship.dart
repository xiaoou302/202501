class Relationship {
  final String userGender; // "male" or "female"
  final DateTime userBirthday;
  final DateTime partnerBirthday;
  final DateTime anniversaryDate;
  final String userName;
  final String partnerName;

  Relationship({
    required this.userGender,
    required this.userBirthday,
    required this.partnerBirthday,
    required this.anniversaryDate,
    required this.userName,
    required this.partnerName,
  });

  // 从JSON创建对象
  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      userGender: json['userGender'] as String,
      userBirthday: DateTime.parse(json['userBirthday'] as String),
      partnerBirthday: DateTime.parse(json['partnerBirthday'] as String),
      anniversaryDate: DateTime.parse(json['anniversaryDate'] as String),
      userName: json['userName'] as String,
      partnerName: json['partnerName'] as String,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'userGender': userGender,
      'userBirthday': userBirthday.toIso8601String(),
      'partnerBirthday': partnerBirthday.toIso8601String(),
      'anniversaryDate': anniversaryDate.toIso8601String(),
      'userName': userName,
      'partnerName': partnerName,
    };
  }
}
