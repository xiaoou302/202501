import 'dart:convert';

class Moment {
  final String id;
  final String mediaType; // "image" or "video"
  final String
  mediaPath; // since we can't use local assets easily without network, maybe we can use random network images
  final String caption;
  final DateTime timestamp;
  final List<String> tags;

  Moment({
    required this.id,
    required this.mediaType,
    required this.mediaPath,
    required this.caption,
    required this.timestamp,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mediaType': mediaType,
      'mediaPath': mediaPath,
      'caption': caption,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
    };
  }

  factory Moment.fromMap(Map<String, dynamic> map) {
    return Moment(
      id: map['id'],
      mediaType: map['mediaType'],
      mediaPath: map['mediaPath'],
      caption: map['caption'],
      timestamp: DateTime.parse(map['timestamp']),
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Moment.fromJson(String source) => Moment.fromMap(json.decode(source));
}
