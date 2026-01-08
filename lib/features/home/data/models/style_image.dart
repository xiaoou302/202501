class StyleImage {
  final String id;
  final String imageUrl;
  final String? thumbnailUrl;
  final List<String> tags;
  final String? description;
  final String? detailedDescription;
  final String? inspiration;
  final DateTime createdAt;
  final bool isSaved;
  final bool isLocalAsset;

  StyleImage({
    required this.id,
    required this.imageUrl,
    this.thumbnailUrl,
    required this.tags,
    this.description,
    this.detailedDescription,
    this.inspiration,
    required this.createdAt,
    this.isSaved = false,
    this.isLocalAsset = false,
  });

  factory StyleImage.fromJson(Map<String, dynamic> json) {
    return StyleImage(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String?,
      detailedDescription: json['detailedDescription'] as String?,
      inspiration: json['inspiration'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
      isLocalAsset: json['isLocalAsset'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'description': description,
      'detailedDescription': detailedDescription,
      'inspiration': inspiration,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
      'isLocalAsset': isLocalAsset,
    };
  }

  StyleImage copyWith({
    String? id,
    String? imageUrl,
    String? thumbnailUrl,
    List<String>? tags,
    String? description,
    String? detailedDescription,
    String? inspiration,
    DateTime? createdAt,
    bool? isSaved,
    bool? isLocalAsset,
  }) {
    return StyleImage(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      inspiration: inspiration ?? this.inspiration,
      createdAt: createdAt ?? this.createdAt,
      isSaved: isSaved ?? this.isSaved,
      isLocalAsset: isLocalAsset ?? this.isLocalAsset,
    );
  }
}
