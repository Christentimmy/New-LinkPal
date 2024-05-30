import 'package:linkingpal/models/post_model.dart';

class LikesModel {
  final String id;
  final DateTime createdAt;
  final CreatedBy createdBy;
  final String postId;

  LikesModel({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.postId,
  });

  factory LikesModel.fromJson(Map<String, dynamic> json) {
    return LikesModel(
      id: json["id"] ?? "",
      createdAt: DateTime.parse(json["created_at"] ?? ""),
      createdBy: CreatedBy.fromJson(json["created_by"] ?? {}),
      postId: json["post_id"] ?? "",
    );
  }
}
