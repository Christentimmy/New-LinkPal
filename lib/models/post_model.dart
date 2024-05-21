

class PostModel {
  final String id;
  final String text;
  final List<String> tags;
  final List<String> files;
  final DateTime createdAt;
  final CreatedBy createdBy;
  final List<dynamic> comments;
  final List<dynamic> likes;

  PostModel({
    required this.id,
    required this.text,
    required this.tags,
    required this.files,
    required this.createdAt,
    required this.createdBy,
    required this.comments,
    required this.likes,
  });

  // Factory method to create an instance from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      text: json['text'],
      tags: List<String>.from(json['tags']),
      files: List<String>.from(json['files']),
      createdAt: DateTime.parse(json['created_at']),
      createdBy: CreatedBy.fromJson(json['created_by']),
      comments: List<dynamic>.from(json['comments']),
      likes: List<dynamic>.from(json['likes']),
    );
  }
}

class CreatedBy {
  final String avatar;
  final String id;
  final String name;
  final List<String> mood;

  CreatedBy({
    required this.avatar,
    required this.id,
    required this.name,
    required this.mood,
  });

  // Factory method to create an instance from a JSON map
  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      avatar: json['avatar'],
      id: json['id'],
      name: json['name'],
      mood: List<String>.from(json['mood']),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'id': id,
      'name': name,
      'mood': mood,
    };
  }
}
