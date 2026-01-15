class ArtModel {
  final String id;
  final String title;
  final String artistName;
  final String artistId;
  final String imageUrl;
  final List<String> categories;
  final String? description;
  final String? poem;
  final DateTime createdAt;
  final bool isInCollection;

  ArtModel({
    required this.id,
    required this.title,
    required this.artistName,
    required this.artistId,
    required this.imageUrl,
    required this.categories,
    this.description,
    this.poem,
    required this.createdAt,
    this.isInCollection = false,
  });

  ArtModel copyWith({
    String? id,
    String? title,
    String? artistName,
    String? artistId,
    String? imageUrl,
    List<String>? categories,
    String? description,
    String? poem,
    DateTime? createdAt,
    bool? isInCollection,
  }) {
    return ArtModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artistName: artistName ?? this.artistName,
      artistId: artistId ?? this.artistId,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      poem: poem ?? this.poem,
      createdAt: createdAt ?? this.createdAt,
      isInCollection: isInCollection ?? this.isInCollection,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artistName': artistName,
      'artistId': artistId,
      'imageUrl': imageUrl,
      'categories': categories,
      'description': description,
      'poem': poem,
      'createdAt': createdAt.toIso8601String(),
      'isInCollection': isInCollection,
    };
  }

  factory ArtModel.fromJson(Map<String, dynamic> json) {
    return ArtModel(
      id: json['id'],
      title: json['title'],
      artistName: json['artistName'],
      artistId: json['artistId'],
      imageUrl: json['imageUrl'],
      categories: List<String>.from(json['categories']),
      description: json['description'],
      poem: json['poem'],
      createdAt: DateTime.parse(json['createdAt']),
      isInCollection: json['isInCollection'] ?? false,
    );
  }
}
