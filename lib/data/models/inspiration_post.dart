class InspirationPost {
  final String id;
  final String imagePath;
  final String title;
  final String subtitle;
  final double heightRatio;
  final String avatarPath;
  final String userName;
  final String description;
  final String location;
  final String styleTag;
  final String category; // New field for room type
  final String pros;
  final String cons;

  InspirationPost({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.heightRatio = 1.0,
    required this.avatarPath,
    required this.userName,
    required this.description,
    required this.location,
    required this.styleTag,
    required this.category,
    required this.pros,
    required this.cons,
  });
}
