class Draft {
  final String id;
  String title;
  String content;
  DateTime lastModified;
  final int version;
  String? associatedImageUrl;
  bool isPublished;

  Draft({
    required this.id,
    this.title = '',
    this.content = '',
    required this.lastModified,
    this.version = 1,
    this.associatedImageUrl,
    this.isPublished = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'lastModified': lastModified.toIso8601String(),
    'version': version,
    'associatedImageUrl': associatedImageUrl,
    'isPublished': isPublished,
  };

  factory Draft.fromJson(Map<String, dynamic> json) => Draft(
    id: json['id'],
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    lastModified: DateTime.parse(json['lastModified']),
    version: json['version'] ?? 1,
    associatedImageUrl: json['associatedImageUrl'],
    isPublished: json['isPublished'] ?? false,
  );
}
