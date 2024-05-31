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
  final dynamic latitude;
  final dynamic longitude;

  const UserModel({
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
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      gender: json["gender"] ?? "",
     );
  }
}



