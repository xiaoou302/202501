class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final DateTime birthday;
  final DateTime gotchaDay;
  final String? avatarUrl;
  final String hobbies;
  final bool isActive;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthday,
    required this.gotchaDay,
    this.avatarUrl,
    required this.hobbies,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'birthday': birthday.toIso8601String(),
      'gotchaDay': gotchaDay.toIso8601String(),
      'avatarUrl': avatarUrl,
      'hobbies': hobbies,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      gender: json['gender'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      gotchaDay: DateTime.parse(json['gotchaDay'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      hobbies: json['hobbies'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Pet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    String? gender,
    DateTime? birthday,
    DateTime? gotchaDay,
    String? avatarUrl,
    String? hobbies,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      gotchaDay: gotchaDay ?? this.gotchaDay,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hobbies: hobbies ?? this.hobbies,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
