class UserModel {
  final String email;
  final String id;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isVerified;
  final bool hasSubscribed;
  final String createdAt;
  final String updatedAt;
  final String video;
  final String name;
  final String bio;
  final String dob;
  final List mood;
  final String gender;
  final int mobileNumber;
  final String image;
  final double latitude;
  final double longitude;
  bool isMatchRequestSent;

  UserModel({
    this.isMatchRequestSent = false,
    required this.email,
    required this.id,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isVerified,
    required this.hasSubscribed,
    required this.createdAt,
    required this.updatedAt,
    required this.video,
    required this.name,
    required this.bio,
    required this.dob,
    required this.mood,
    required this.mobileNumber,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.gender,
  });

  factory UserModel.fromJson(var json) {
    return UserModel(
      email: json["email"] ?? "",
      id: json["id"] ?? "",
      isEmailVerified: json["is_email_verified"] ?? false,
      isPhoneVerified: json["is_phone_verified"] ?? false,
      isVerified: json["is_verified"] ?? false,
      hasSubscribed: json["has_subscribed"] ?? false,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      video: json["video"] ?? "",
      name: json["name"] ?? "",
      bio: json["bio"] ?? "",
      dob: json["dob"] ?? "",
      mood: json["mood"] ?? [],
      mobileNumber: json["mobile_number"] ?? 0,
      image: json["avatar"] ?? "",
       latitude: _parseDouble(json["latitude"]),
      longitude: _parseDouble(json["longitude"]),
      gender: json["gender"] ?? "",
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  factory UserModel.empty() {
    return UserModel(
      email: "",
      id: "",
      isEmailVerified: false,
      isPhoneVerified: false,
      isVerified: false,
      hasSubscribed: false,
      createdAt: "",
      updatedAt: "",
      video: "",
      name: "",
      bio: "",
      dob: "",
      mood: [],
      mobileNumber: 0,
      image: "",
      latitude: 0.0,
      longitude: 0.0,
      gender: "",
    );
  }
}
