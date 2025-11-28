class User {
  final String id;
  final String username;
  final String displayName;
  final String bio;
  final String avatarUrl;
  final int followersCount;
  final int followingCount;
  final int posesCount;
  final DateTime joinDate;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.bio = '',
    this.avatarUrl = '',
    this.followersCount = 0,
    this.followingCount = 0,
    this.posesCount = 0,
    required this.joinDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'posesCount': posesCount,
      'joinDate': joinDate.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      posesCount: json['posesCount'] ?? 0,
      joinDate: DateTime.parse(json['joinDate']),
    );
  }
}
