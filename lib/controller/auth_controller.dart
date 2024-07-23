// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/services/auth_service.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthController extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";
  RxBool isLoading = false.obs;
  final _verificationController = Get.put(VerificationMethods());
  AuthService authService = AuthService();

  Future<void> loginUser({
    required String email,
    required String password,
    required bool isEmail,
    required BuildContext context,
  }) async {
    try {
      final response = await authService.loginUser(
        email: email,
        password: password,
        isEmail: isEmail,
        context: context,
      );

      var token = response["token"];
      await TokenStorage().storeToken(token);

      final userModel = UserModel.fromJson(response["data"]);

      if (!userModel.isEmailVerified || !userModel.isPhoneVerified) {
        CustomSnackbar.showErrorSnackBar("Account not verified", context);
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
        return CustomSnackbar.showErrorSnackBar("Video not uploaded", context);
      }
      if (userModel.gender.toLowerCase() == "null") {
        Get.toNamed(AppRoutes.selectGender);
        return CustomSnackbar.showErrorSnackBar(
          "Fill out your gender",
          context,
        );
      }

      final retrieveController = Get.find<RetrieveController>();
      final postController = Get.find<PostController>();

      await retrieveController.getUserDetails(context);
      postController.getAllPost(context: context);
      postController.getAllUserPost(context: context);

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
    required BuildContext context,
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
        return CustomSnackbar.showErrorSnackBar(
          "Email already exist. Please login instead",
          context,
        );
      }

      if (responce.statusCode == 400) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponseBody["message"].toString(),
          context,
        );
      }

      if (responce.statusCode != 200) {
        return CustomSnackbar.showErrorSnackBar(
          "An Error occured, try again",
          context,
        );
      }

      var token = decodedResponseBody["token"];
      await TokenStorage().storeToken(token);
      final controller = Get.find<RetrieveController>();
      await controller.getUserDetails(context);

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

  Future<void> changePassword({
    required String password,
    required BuildContext context,
  }) async {
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
        return CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"].toString(),
          context,
        );
      }

      CustomSnackbar.showSuccessSnackBar(
        "Password changed successfully",
        context,
      );
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> forgotPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );
      if (response.statusCode == 400) {
        return CustomSnackbar.showErrorSnackBar("Bad request", context);
      }
      if (response.statusCode == 404) {
        return CustomSnackbar.showErrorSnackBar("User Not Found", context);
      }

      var decodedResponce = await json.decode(response.body);
      String tempToken =
          await _verificationController.sendOTPEmail(email: email, context: context);

      //todo: change the logic because the forgotpassword have otp
      String? extractedCode = _verificationController
          .extractFourDigitCode(decodedResponce["message"].toString());

      CustomSnackbar.showSuccessSnackBar(
        "A password reset OTP has been sent to you $extractedCode",
        context,
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

  Future<void> deleteAccount(BuildContext context) async {
    final String? token = await TokenStorage().getToken();
    if (token == null) {
      CustomSnackbar.showErrorSnackBar("Invalid token, login again", context);
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
        return CustomSnackbar.showErrorSnackBar("Unauthorized", context);
      }

      CustomSnackbar.showSuccessSnackBar(
          "Account deleted successfully", context);
      Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjVhOTBjZDFlZGQ5YzM5OWJiNjk4ODYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYwNDh9.K99R85Y_wY-Jc6IRnZILV3RczarHdCBhHZWxBxUIYIM


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjgxYjlkYTU2NDM0ZDZkOGRiYTY5YmYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYyNTB9.w1qfCAkhboXeL5pGK9cLmL0vzG1WWXoC6Sckad48oRQ