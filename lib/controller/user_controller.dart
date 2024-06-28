import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'dart:math' show cos, sqrt, atan2, sin, pi;

class UserController extends GetxController {
  // RxBool isloading = false.obs;
  RxBool isFriendAccept = false.obs;
  String baseUrl = "https://linkingpal.onrender.com/v1";
  final _retrieveController = Get.put(RetrieveController());
  RxList userNotifications = [].obs;
  RxList peopleNearBy = [].obs;
  RxList matchesRequest = [].obs;
  RxList matches = [].obs;

  Future<void> uploadVideo({
    required File video,
    required bool isSignUp,
  }) async {
    final tokenStorage = Get.put(TokenStorage());

    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }
    var uri = Uri.parse("$baseUrl/user/video");
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = token;
    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        video.path,
      ),
    );

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      String message = decodedResponse["message"];
      if (response.statusCode == 403) {
        CustomSnackbar.show(
          "Error",
          "Please verify your email address and mobile number",
        );
        return Get.toNamed(AppRoutes.verificationChecker, arguments: {
          "onClickToProceed": () {
            Get.toNamed(AppRoutes.introductionVideo);
          }
        });
      }
      if (response.statusCode != 200) {
        return CustomSnackbar.show("Error", message);
      }

      if (isSignUp) {
        Get.toNamed(AppRoutes.interest);
      } else {
        Get.offAllNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 0,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      final retrieveController = Get.find<RetrieveController>();
      await retrieveController.getUserDetails();
    }
  }

  Future<void> uploadPicture({required XFile image}) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    var fileStream = http.ByteStream(image.openRead());
    var length = await image.length();
    var multipartFile = http.MultipartFile(
      'avatar',
      fileStream,
      length,
      filename: image.path.split('/').last,
    );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/user/image"),
    );
    request.headers['Authorization'] = token;
    request.files.add(multipartFile);

    try {
      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      debugPrint(decodedResponse.toString());
      if (response.statusCode == 403) {
        return CustomSnackbar.show(
          "Error",
          "Please verify your email address and mobile number",
        );
      }
      if (response.statusCode != 200) {
        CustomSnackbar.show(
          "Error",
          "An error occured, try again",
        );
      }
      CustomSnackbar.show(
        "Success",
        "Profile Image Uploaded Successfully",
      );
      Get.toNamed(AppRoutes.personalDataFromUser);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadLocation({
    required double lang,
    required double long,
  }) async {
    final tokenStorage = Get.put(TokenStorage());

    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/location"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "latitude": lang,
          "longitude": long,
        }),
      );
      final decodedBody = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          decodedBody["message"],
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadInterest({
    required List<String> interests,
    required bool isSignUp,
  }) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/mood"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "mood": interests,
        }),
      );
      var decodedResponse = json.decode(response.body);
      if (response.statusCode == 400) {
        CustomSnackbar.show('Error', decodedResponse["message"]);
        return;
      }

      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", decodedResponse["message"]);
        return;
      }
      final retrieveController = Get.put(RetrieveController());
      await retrieveController.getUserDetails();

      CustomSnackbar.show("Success", 'You have selected your interest');
      if (isSignUp) {
        Get.offAllNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 1,
        });
      } else {
        Get.offAllNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 0,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateUserDetails({
    String? name,
    String? bio,
    String? gender,
    required bool isSignUp,
  }) async {
    final String? token = await TokenStorage().getToken();
    if (token == null) {
      CustomSnackbar.show("Error", "Invalid token, login again");
      return Get.toNamed(AppRoutes.dashboard);
    }
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/user"),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: json.encode({
          "name": name,
          "bio": bio,
          "gender": gender,
        }),
      );
      if (response.statusCode == 401) {
        return CustomSnackbar.show("Error", "Unauthorized");
      }
      if (response.statusCode == 400) {
        return CustomSnackbar.show("Error", "Bad Request");
      }

      final RetrieveController retrieveController =
          Get.find<RetrieveController>();
      await retrieveController.getUserDetails();
      if (isSignUp) {
        Get.toNamed(AppRoutes.introductionVideo);
      } else {
        Get.toNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 0,
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int calculateAge(String dateString) {
    DateTime birthDate = DateTime.parse(dateString);
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;

    // Adjust age if the birth date has not occurred yet this year
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<void> getAllNotification() async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/notification"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final decoded = await json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", decoded["message"].toString());
      }

      userNotifications.value = decoded["data"];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getSingleNotification(String notId) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri =
          Uri.parse("$baseUrl/notification/$notId").replace(queryParameters: {
        "postId": notId,
      });
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final decoded = await json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", decoded["message"].toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> markNotication(String notId) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri = Uri.parse("$baseUrl/notification/$notId/read")
          .replace(queryParameters: {
        "postId": notId,
      });
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final decoded = await json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", decoded["message"].toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getNearByUSer({
    required String age,
    required String mood,
    required String distance,
    required String interest,
  }) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final uri = Uri.parse(
        "$baseUrl/user/nearby?age=$age&mood=$mood&distance=$distance&interest=$interest",
      ).replace(queryParameters: {
        "age": age.toLowerCase(),
        "mood": mood.toLowerCase(),
        "interest": interest.toLowerCase(),
        "distance": distance.toLowerCase(),
      });
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", responseData["message"].toString());
      }

      List<dynamic> dataFromResponse = responseData["data"];
      List<UserModel> mapList =
          dataFromResponse.map((e) => UserModel.fromJson(e)).toList();

      List<UserModel> filteredList = mapList
          .where((x) => x.id != _retrieveController.userModel.value!.id)
          .toList();
      peopleNearBy.clear();
      peopleNearBy.value = filteredList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> matchesRequestFromOthers() async {
    try {
      final tokenStorage = Get.put(TokenStorage());
      String? token = await tokenStorage.getToken();
      final response =
          await http.get(Uri.parse("$baseUrl/user/match/request"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      final decodedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.show("Error", decodedResponse["message"]);
      }
      final List data = decodedResponse["data"];
      List mapped = data.map((e) => UserModel.fromJson(e)).toList();
      matchesRequest.clear();
      matchesRequest.value = mapped;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> myMatches() async {
    try {
      final tokenStorage = Get.put(TokenStorage());
      String? token = await tokenStorage.getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/user/match"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final decodedResponse = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.show("Error", decodedResponse["message"]);
      }
      final List data = decodedResponse["data"];
      List<UserModel> mappedData =
          data.map((e) => UserModel.fromJson(e)).toList();
      List excludeCurrentUSer = mappedData
          .where((x) => x.id != _retrieveController.userModel.value!.id)
          .toList();
      matches.value = excludeCurrentUSer;
      matches.refresh();
      print(matches.length);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> acceptMatchRequest({required String senderId}) async {
    try {
      final tokenStorage = Get.put(TokenStorage());
      String? token = await tokenStorage.getToken();
      final uri = Uri.parse("$baseUrl/user/match/request/$senderId")
          .replace(queryParameters: {
        "senderId": senderId,
      });

      final response = await http.patch(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 400) {
        CustomSnackbar.show("Error", decodedResponse["message"]);
        isFriendAccept.value = true;
      }
      isFriendAccept.value = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;
    return distance;
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }
}
