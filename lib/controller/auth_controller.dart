import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthController extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";
  RxBool isLoading = false.obs;
  final _verificationController = Get.put(VerificationMethods());
  final _tokenStorage = Get.find<TokenStorage>();

  Future<void> loginUser({
    required String email,
    required String password,
    required bool isEmail,
  }) async {
    try {
      final body = json.encode({
        isEmail ? "email" : "mobile_number": email,
        "password": password,
      });

      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 404) {
        return CustomSnackbar.show("Error", "Invalid Credentials");
      }
      if (response.statusCode == 401) {
        return CustomSnackbar.show("Error", "Check your credentials again");
      }

      final responseData = json.decode(response.body);
      var token = responseData["token"];
      final userModel = UserModel.fromJson(responseData["data"]);
      await _tokenStorage.storeToken(token);

      if (!userModel.isEmailVerified || !userModel.isPhoneVerified) {
        CustomSnackbar.show("Error", "Account not verified");
        return Get.toNamed(AppRoutes.verificationChecker, arguments: {
          "onClickToProceed": () {
            Get.toNamed(AppRoutes.dashboard, arguments: {
              "startScreen": 0,
            });
          }
        });
      }
      if (userModel.video.isEmpty) {
        Get.toNamed(AppRoutes.updateVideo);
        return CustomSnackbar.show("Error", "Video not uploaded");
      }
      if (userModel.gender.toLowerCase() == "null") {
        Get.toNamed(AppRoutes.selectGender);
        return CustomSnackbar.show("Error", "Fill out your gender");
      }
      final controller = Get.find<RetrieveController>();
      final postController = Get.find<PostController>();
      final webController = Get.find<SocketController>();

      // Connect the WebSocket with the new token
      webController.connect();
      await controller.getUserDetails();
      postController.getAllPost();
      postController.getAllUserPost();
      Get.offAllNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signUpUSer({
    required String name,
    required String email,
    required String mobileNumber,
    required DateTime dob,
    required String password,
    required String bio,
  }) async {
    try {
      Object userObject = {
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "dob": dob.toUtc().toIso8601String(),
        "password": password,
        "bio": bio,
      };

      final responce = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(userObject),
      );

      var decodedResponseBody = json.decode(responce.body);
      if (responce.statusCode == 409) {
        return CustomSnackbar.show(
          "Error",
          "Email already exist. Please login instead",
        );
      }

      if (responce.statusCode == 400) {
        return CustomSnackbar.show(
            "Error", decodedResponseBody["message"].toString());
      }

      if (responce.statusCode != 200) {
        return CustomSnackbar.show('Error', "An Error occured, try again");
      }
      var token = decodedResponseBody["token"];
      await _tokenStorage.storeToken(token);
      final controller = Get.find<RetrieveController>();
      final webController = Get.find<SocketController>();
      await controller.getUserDetails();
      webController.connect();
      Get.toNamed(AppRoutes.verificationChecker, arguments: {
        "onClickToProceed": () {
          Get.toNamed(AppRoutes.uploadPicture);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({required String password}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      final responce = await http.post(
        Uri.parse("$baseUrl/auth/change-password"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"password": password}),
      );
      var decodedResponce = await json.decode(responce.body);

      if (responce.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          decodedResponce["message"].toString(),
        );
      }
      CustomSnackbar.show("Success", "Password changed successfully");
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );
      if (response.statusCode == 400) {
        return CustomSnackbar.show("Error", "Bad request");
      }
      if (response.statusCode == 404) {
        return CustomSnackbar.show("Error", "User Not Found");
      }

      var decodedResponce = await json.decode(response.body);
      String tempToken =
          await _verificationController.sendOTPEmail(email: email);

      //todo: change the logic because the forgotpassword have otp
      String? extractedCode = _verificationController
          .extractFourDigitCode(decodedResponce["message"].toString());

      CustomSnackbar.show(
        "Success",
        "A password reset OTP has been sent to you $extractedCode",
      );

      Get.toNamed(
        AppRoutes.verification,
        arguments: {
          "action": () {
            Get.toNamed(AppRoutes.changePassword);
          },
          "isEmailType": true,
          "token": tempToken,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    final String? token = await TokenStorage().getToken();
    if (token == null) {
      CustomSnackbar.show("Error", "Invalid token, login again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/user"),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 401) {
        return CustomSnackbar.show("Error", "Unauthorized");
      }

      CustomSnackbar.show("Success", " account deleted successfully");
      Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjVhOTBjZDFlZGQ5YzM5OWJiNjk4ODYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYwNDh9.K99R85Y_wY-Jc6IRnZILV3RczarHdCBhHZWxBxUIYIM


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjgxYjlkYTU2NDM0ZDZkOGRiYTY5YmYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYyNTB9.w1qfCAkhboXeL5pGK9cLmL0vzG1WWXoC6Sckad48oRQ