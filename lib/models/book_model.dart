class BookModel {
  final String id;
  final String title;
  final String author;
  final String level;
  final String coverImage;
  final bool isPremium;
  final bool hasAudio;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.level,
    required this.coverImage,
    required this.isPremium,
    required this.hasAudio,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      level: json['level'] ?? '',
      coverImage: json['cover_image'] ?? '',
      isPremium: json['is_premium'] ?? false,
      hasAudio: json['has_audio'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'level': level,
      'cover_image': coverImage,
      'is_premium': isPremium,
      'has_audio': hasAudio,
    };
  }
}

