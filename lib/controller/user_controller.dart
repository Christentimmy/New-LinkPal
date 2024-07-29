// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/notification_model.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'dart:math' show cos, sqrt, atan2, sin, pi;

class UserController extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";
  final _retrieveController = Get.put(RetrieveController());
  RxList<NotificationModel> userNotifications = <NotificationModel>[].obs;
  RxList peopleNearBy = [].obs;
  RxList matchesRequest = [].obs;
  RxList matches = [].obs;
  RxBool isloading = false.obs;
  RxBool isPeopleNearbyFetched = false.obs;
  RxBool isNotificationLoader = false.obs;

  @override
  void onInit() {
    getAllNotification();
    super.onInit();
  }

  Future<void> uploadVideo({
    required File video,
    required bool isUpdateVideo,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again");
      return Get.toNamed(AppRoutes.signin);
    }
    var uri = Uri.parse("$baseUrl/user/video");
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
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
      print(decodedResponse);
      String message = decodedResponse["message"];
      if (response.statusCode == 403) {
        CustomSnackbar.showErrorSnackBar(
          "Please verify your email address and mobile number",
        );
        Get.toNamed(AppRoutes.verificationChecker, arguments: {
          "onClickToProceed": () {
            Get.toNamed(AppRoutes.introductionVideo);
          }
        });
        return;
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }

      if (isUpdateVideo) {
        Get.offAllNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 0,
        });
      }

      stopwatch.stop();
      print("Time Execution: ${stopwatch.elapsed}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      final retrieveController = Get.find<RetrieveController>();
      await retrieveController.getUserDetails();
    }
  }

  Future<void> uploadPicture({
    required XFile image,
    required bool isSignUp,
  }) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again");
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
        return CustomSnackbar.showErrorSnackBar(
          "Please verify your email address and mobile number",
        );
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          "An error occured, try again",
        );
      }

      if (isSignUp) {
        Get.toNamed(AppRoutes.introductionVideo);
      } else {
        Get.offNamed(AppRoutes.dashboard, arguments: {
          "startScreen": 0,
        });
      }
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
      CustomSnackbar.showErrorSnackBar("Login Again");
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
        return CustomSnackbar.showErrorSnackBar(
          decodedBody["message"].toString(),
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
      CustomSnackbar.showErrorSnackBar("Login Again");
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
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return;
      }

      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return;
      }
      final retrieveController = Get.put(RetrieveController());
      await retrieveController.getUserDetails();
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
      CustomSnackbar.showErrorSnackBar("Invalid token, login again");
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
      print(response.body);
      if (response.statusCode == 401) {
        return CustomSnackbar.showErrorSnackBar("Unauthorized");
      }
      if (response.statusCode == 400) {
        return CustomSnackbar.showErrorSnackBar("Bad Request");
      }

      final RetrieveController retrieveController =
          Get.find<RetrieveController>();
      await retrieveController.getUserDetails();
      if (isSignUp) {
        Get.toNamed(AppRoutes.interest);
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
    isNotificationLoader.value = true;
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
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
        debugPrint("response code not 200");
      }
      List notDatas = decoded["data"];
      List<NotificationModel> mapNotData =
          notDatas.map((e) => NotificationModel.fromJson(e)).toList();
      userNotifications.addAll(mapNotData);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isNotificationLoader.value = false;
    }
  }

  Future<void> getSingleNotification(String notId) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again");
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
        CustomSnackbar.showErrorSnackBar(
          decoded["message"].toString(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> markNotication(String notId) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again");
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
        CustomSnackbar.showErrorSnackBar(
          decoded["message"].toString(),
        );
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
    isloading.value = true;
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      // CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.offAllNamed(AppRoutes.signin);
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
        Get.snackbar("Error", responseData["message"].toString());
      }
      List<dynamic> dataFromResponse = responseData["data"];
      List<UserModel> mapList =
          dataFromResponse.map((e) => UserModel.fromJson(e)).toList();

      List<UserModel> filteredList = mapList
          .where((x) => x.id != _retrieveController.userModel.value!.id)
          .toList();
      peopleNearBy.clear();
      peopleNearBy.value = filteredList;
      isPeopleNearbyFetched.value = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> matchesRequestFromOthers() async {
    isloading.value = true;
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
        return CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"],
        );
      }
      final List data = decodedResponse["data"];
      List filterMap = data
          .where((e) =>
              e.containsKey("avatar") &&
              e.containsKey("longitude") &&
              e.containsKey("latitude") &&
              e.containsKey("name"))
          .toList();
      List mapped = filterMap.map((e) => UserModel.fromJson(e)).toList();
      for (var i = 0; i < data.length; i++) {
        print(data[i]);
      }
      matchesRequest.clear();
      matchesRequest.value = mapped;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> myMatches() async {
    isloading.value = true;
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
      print(decodedResponse);
      if (response.statusCode != 200) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
      }
      final List data = decodedResponse["data"];
      final filterMap = data
          .where((e) =>
              e.containsKey("avatar") &&
              e.containsKey("name") &&
              e.containsKey("latitude") &&
              e.containsKey("longitude"))
          .toList();
      List<UserModel> mappedData =
          filterMap.map((e) => UserModel.fromJson(e)).toList();
      List excludeCurrentUSer = mappedData
          .where((x) => x.id != _retrieveController.userModel.value!.id)
          .toList();
      matches.clear();
      print("Excluded user length: ${excludeCurrentUSer.length}");
      matches.value = excludeCurrentUSer;
      print("Matches length: ${matches.length}");
      matches.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<bool> acceptMatchRequest({
    required String senderId,
  }) async {
    try {
      final tokenStorage = Get.put(TokenStorage());
      String? token = await tokenStorage.getToken();
      final uri = Uri.parse("$baseUrl/user/match/request/$senderId");
      final response = await http.patch(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.body.isEmpty) {
        return true;
      }
      final decodedResponse = json.decode(response.body);
      if (decodedResponse["message"] == "Already accepted") {
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return true;
      }

      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return false;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
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

  void reset() {
    userNotifications.clear();
    peopleNearBy.clear();
    matchesRequest.clear();
    matches.clear();
  }
}
