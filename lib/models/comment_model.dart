import 'package:linkingpal/models/post_model.dart';

class CommentModel {
  final String id;
  final DateTime createdAt;
  final CreatedBy createdBy;
  final String commentId;
  String comment;
  int likes;
  final dynamic replies;
  bool isLikeByUser;

  CommentModel({
    required this.likes,
    required this.isLikeByUser,
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.commentId,
    required this.comment,
    required this.replies,
  });

  // Factory method to create an instance from a JSON map
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // print(json["created_at"]);
    return CommentModel(
      id: json['id'] ?? '',
      commentId: json['post_id'] ?? '',
      createdAt: DateTime.parse(json["created_at"] ?? ""),
      createdBy: CreatedBy.fromJson(json['created_by'] ?? {}),
      likes: json['likes'] ?? 0,
      isLikeByUser: json["is_liked_by_user"] ?? false,
      comment: json['comment'] ?? '',
      // replies: List<String>.from(json['replies'] ?? []),
      replies: json["replies"],
    );
  }
}
