class User {
  final String id;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final String? quote;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.quote,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'quote': quote,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      quote: json['quote'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
