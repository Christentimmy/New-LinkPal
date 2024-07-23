import 'package:linkingpal/models/chat_list_model.dart';

class ChatCardModel {
  final DateTime createdAt;
  final List<UserChatListModel> users;
  final String message;
  final List files;
  final String senderId;
  final String channelId;
  final DateTime updatedAt;
  final String messageId;

  ChatCardModel({
    required this.createdAt,
    required this.users,
    required this.message,
    required this.files,
    required this.senderId,
    required this.channelId,
    required this.updatedAt,
    required this.messageId,
  });

  factory ChatCardModel.fromJson(Map<String, dynamic> json) {
    return ChatCardModel(
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
      users: json["users"] != null
          ? (json["users"] as List)
              .map((element) => UserChatListModel.fromJson(element))
              .toList()
          : [],
      message: json["message"] ?? "",
      files: json["files"] != null ? List.from(json["files"]) : [],
      senderId: json["sender_id"] ?? "",
      channelId: json["channel_id"] ?? "",
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updated_at"])
          : DateTime.now(),
      messageId: json["id"] ?? "",
    );
  }

  factory ChatCardModel.empty() {
    return ChatCardModel(
      createdAt: DateTime.now(),
      users: [],
      message: "",
      files: [],
      senderId: "",
      channelId: '',
      updatedAt: DateTime.now(),
      messageId: "",
    );
  }
}
