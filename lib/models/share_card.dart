class ShareCard {
  final String id;
  final String text;
  final String qrCodeUrl;
  final DateTime createdAt;
  final String colorHex;
  final String? title;
  final List<String> tags;
  final bool isFavorite;

  ShareCard({
    required this.id,
    required this.text,
    required this.qrCodeUrl,
    required this.createdAt,
    required this.colorHex,
    this.title,
    this.tags = const [],
    this.isFavorite = false,
  });

  // Convert ShareCard to Map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'qrCodeUrl': qrCodeUrl,
      'createdAt': createdAt.toIso8601String(),
      'colorHex': colorHex,
      'title': title,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  // Create ShareCard from Map (from storage)
  factory ShareCard.fromJson(Map<String, dynamic> json) {
    return ShareCard(
      id: json['id'],
      text: json['text'],
      qrCodeUrl: json['qrCodeUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      colorHex: json['colorHex'],
      title: json['title'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Create a copy of this ShareCard with some fields replaced
  ShareCard copyWith({
    String? id,
    String? text,
    String? qrCodeUrl,
    DateTime? createdAt,
    String? colorHex,
    String? title,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return ShareCard(
      id: id ?? this.id,
      text: text ?? this.text,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      createdAt: createdAt ?? this.createdAt,
      colorHex: colorHex ?? this.colorHex,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
