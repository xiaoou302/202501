class UserModel {
  final String id;
  final String username;
  final String? avatarUrl;
  final String bio;
  final int creationCount;
  final int imitationCount;
  final int chatDuration;
  final List<String> aestheticTags;
  final List<String> collectionArtIds;

  UserModel({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.bio,
    this.creationCount = 0,
    this.imitationCount = 0,
    this.chatDuration = 0,
    this.aestheticTags = const [],
    this.collectionArtIds = const [],
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    String? bio,
    int? creationCount,
    int? imitationCount,
    int? chatDuration,
    List<String>? aestheticTags,
    List<String>? collectionArtIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      creationCount: creationCount ?? this.creationCount,
      imitationCount: imitationCount ?? this.imitationCount,
      chatDuration: chatDuration ?? this.chatDuration,
      aestheticTags: aestheticTags ?? this.aestheticTags,
      collectionArtIds: collectionArtIds ?? this.collectionArtIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'creationCount': creationCount,
      'imitationCount': imitationCount,
      'chatDuration': chatDuration,
      'aestheticTags': aestheticTags,
      'collectionArtIds': collectionArtIds,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      creationCount: json['creationCount'] ?? 0,
      imitationCount: json['imitationCount'] ?? 0,
      chatDuration: json['chatDuration'] ?? 0,
      aestheticTags: List<String>.from(json['aestheticTags'] ?? []),
      collectionArtIds: List<String>.from(json['collectionArtIds'] ?? []),
    );
  }
}
