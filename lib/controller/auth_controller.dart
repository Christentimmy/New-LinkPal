import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthController extends GetxController {
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxBool isloading = false.obs;
  final _retrieveController = Get.put(RetrieveController());
  final _tokenStorage = Get.put(TokenStorage());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    isloading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode == 401) {
        CustomSnackbar.show("Error", "Check your credentials again");
        return;
      }

      final responseData = await json.decode(response.body);
      final userModel = UserModel.fromJson(responseData["data"]);
      String message = responseData["message"];
      _tokenStorage.storeToken(responseData["token"]);
      _retrieveController.getUserDetails();

      //if user email is not verified
      if (!userModel.isEmailVerified || !userModel.isPhoneVerified) {
        CustomSnackbar.show("Error", "Account not verified");
        return Get.toNamed(AppRoutes.verificationChecker);
      }

      if (userModel.video.isEmpty) {
        Get.toNamed(AppRoutes.introductionVideo);
        CustomSnackbar.show("Error", "Video not uploaded");
        return;
      }

      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", message);
        return;
      }

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      CustomSnackbar.show("Error", "An unexpected error occurred");
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signUpUSer({
    required String name,
    required String email,
    required String mobileNumber,
    required String dob,
    required String password,
    required String bio,
  }) async {
    isloading.value = true;
    try {
      Object userObject = {
        "name": name,
        "email": email,
        "mobileNumber": mobileNumber,
        "dob": dob,
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

      if (responce.statusCode == 400) {
        return CustomSnackbar.show("Error", "Email already exist");
      }

      if (responce.statusCode != 200) {
        return CustomSnackbar.show('Error', "An Error occured, try again");
      }

      Get.toNamed(AppRoutes.verificationChecker);
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> changePassword({required String password}) async {
    try {
      final responce = await http.post(
        Uri.parse("uri"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"password": password}),
      );
      if (responce.statusCode == 400) {
        return CustomSnackbar.show("Error", "Bad request");
      }
      if (responce.statusCode != 200) {
        return CustomSnackbar.show("Error", "An error occured, Try again!!");
      }
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    isloading.value = true;
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

      CustomSnackbar.show(
        "Success",
        "A password reset OTP has been sent to your email",
      );

      //todo: a token is missing here

      Get.toNamed(
        AppRoutes.verification,
        arguments: {
          "action": () {
            // Get.offAllNamed(AppRoutes.dashboard);
          },
          "isEmailType": true,
          "token": "",
        },
      );
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
