class NotificationModel {
  final String message;
  final String imageUrl;
  final DateTime createdAt;

  NotificationModel({
    required this.message,
    required this.imageUrl,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      message: json["message"] ?? "",
      imageUrl: json["image"] ?? "",
      createdAt: json["created_at"] ?? DateTime.now(),
    );
  }
}
