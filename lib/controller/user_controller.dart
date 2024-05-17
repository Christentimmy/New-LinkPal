import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class UserController extends GetxController {
  RxBool isloading = false.obs;
  String baseUrl = "https://linkingpal.dasimems.com/v1";

  Future<void> uploadVideo({required File video}) async {
    final tokenStorage = Get.put(TokenStorage());
    isloading.value = true;
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

      print('suppose responce: $responseBody');
      print('decoded Responce: $decodedResponse');
      print('normal responce: ${decodedResponse["message"]}');
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
      if (message == "Please upload a mp4 or mkv video") {
        return CustomSnackbar.show("Error", message);
      }
      if (message == "File too large") {
        return CustomSnackbar.show("Error", message);
      }
      if (message == "Please upload video not more than 90 secs") {
        return CustomSnackbar.show("Error", message);
      }

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadPicture({required XFile image}) async {
    isloading.value = true;
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
      Get.toNamed(AppRoutes.interest);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadLocation({
    required double lang,
    required double long,
  }) async {
    isloading.value = true;
    final tokenStorage = Get.put(TokenStorage());

    isloading.value = true;
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
      print(decodedBody);
      if (response.statusCode == 403) {
        return CustomSnackbar.show(
          "Error",
          "Please verify your email address and mobile number",
        );
      }
      if (response.statusCode == 400) {
        return CustomSnackbar.show(
          "Error",
          "Bad request",
        );
      }
      if (response.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          "An error occured, try again",
        );
      }

      CustomSnackbar.show("Success", "Location Uploaded Successfully");
      Get.offAllNamed(AppRoutes.introductionVideo);
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadInterest({required List<String> interests}) async {
    isloading.value = true;
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
        return CustomSnackbar.show('Error', decodedResponse["message"]);
      }

      CustomSnackbar.show("Success", 'You have selected your interest');
      Get.offAllNamed(AppRoutes.locationAccess);
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
