class ArtistModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String location;
  final String biography;
  final List<String> styles;
  final String philosophy;

  ArtistModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.location,
    required this.biography,
    required this.styles,
    required this.philosophy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'location': location,
      'biography': biography,
      'styles': styles,
      'philosophy': philosophy,
    };
  }

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      location: json['location'],
      biography: json['biography'],
      styles: List<String>.from(json['styles']),
      philosophy: json['philosophy'],
    );
  }
}
