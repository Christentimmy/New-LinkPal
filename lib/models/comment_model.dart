import 'package:linkingpal/models/post_model.dart';

class CommentModel {
  final String id;  
  final DateTime createdAt;
  final CreatedBy createdBy;
  final String postId;
  final String comment;
  int likes;
  final List<String> replies;
  String text;
  final List<String> tags;
  final List<String> files;

  bool isLikeByUser;

  CommentModel({
    required this.text,
    required this.likes,
    required this.isLikeByUser,
    required this.id,
    required this.tags,
    required this.files,
    required this.createdAt,
    required this.createdBy,
    required this.postId,
    required this.comment,
    required this.replies,
  });


   // Factory method to create an instance from a JSON map
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['post_id'] ?? '',
      text: json['text'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      files: List<String>.from(json['files'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      createdBy: CreatedBy.fromJson(json['created_by'] ?? {}),
      likes: json['likes'] ?? 0,
      isLikeByUser: json["is_like_by_user"] ?? false,
      comment:  json['comment'] ?? '',
      replies: List<String>.from(json['replies'] ?? []),
    );

  }
}
