class Author {
  final String id;
  final String name;
  final String? bio;
  final String philosophy;
  final String avatarUrl;
  final int worksCount;
  final int appreciationCount;
  final List<String> collections;
  final bool isPro;
  final String location;
  final String genre;

  Author({
    required this.id,
    required this.name,
    this.bio,
    required this.philosophy,
    required this.avatarUrl,
    this.worksCount = 0,
    this.appreciationCount = 0,
    this.collections = const [],
    this.isPro = false,
    this.location = '',
    this.genre = '',
  });
}
