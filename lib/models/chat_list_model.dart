import 'package:linkingpal/models/user_model.dart';

class ChatListModel {
  final String channel;
  final String name;
  final LastSentMessage lastSentMessage;
  final int unRead;
  final DateTime lastTimeUpdated;
  final bool canSendMessage;

  ChatListModel({
    required this.channel,
    required this.name,
    required this.lastSentMessage,
    required this.unRead,
    required this.lastTimeUpdated,
    required this.canSendMessage,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      channel: json["channel"] ?? "",
      name: json["name"] ?? "",
      lastSentMessage: json["last_sent_message"] != null
          ? LastSentMessage.fromJson(json["last_sent_message"])
          : LastSentMessage.empty(),
      unRead: json["un_read"] ?? 0,
      lastTimeUpdated: json["last_time_updated"] ?? DateTime.now(),
      canSendMessage: json["can_send_message"] ?? false,
    );
  }
}

class LastSentMessage {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String channel;
  final List<UserChatListModel> users;
  final String message;
  final List<String> files;
  final String senderId;
  final int v;

  LastSentMessage({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.channel,
    required this.users,
    required this.message,
    required this.files,
    required this.senderId,
    required this.v,
  });

  factory LastSentMessage.fromJson(Map<String, dynamic> json) {
    return LastSentMessage(
      id: json["id"] ?? "",
      createdAt: json["created at"] ?? DateTime.now(),
      updatedAt: json["updated_at"] ?? DateTime.now(),
      channel: json["channel"] ?? "",
      users: json["users"] !=  null ? json["users"].map((e)=> UserModel.fromJson(e)).toList() : [],
      message: json["message"] ?? "",
      files: List<String>.from(json["files"] ?? []),
      senderId: json["senderId"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  factory LastSentMessage.empty() {
    return LastSentMessage(
      id: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      channel: "",
      users: [],
      message: "",
      files: [],
      senderId: "",
      v: 0,
    );
  }
}

class UserChatListModel {
  final String userId;
  final DateTime seenAt;
  final DateTime deletedAt;
  final String id;

  UserChatListModel({
    required this.userId,
    required this.seenAt,
    required this.deletedAt,
    required this.id,
  });

  factory UserChatListModel.empty() {
    return UserChatListModel(
      userId: "",
      seenAt: DateTime.now(),
      deletedAt: DateTime.now(),
      id: "",
    );
  }

  factory UserChatListModel.fromJson(Map<String, dynamic> json) {
    return UserChatListModel(
      userId: json["user_id"] ?? "",
      seenAt: json["seen_at"] ?? DateTime.now(),
      deletedAt: json["deleted_at"] ?? DateTime.now(),
      id: json["_id"] ?? "",
    );
  }
}
