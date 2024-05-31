import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthController extends GetxController {
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxBool isloading = false.obs;
  final _verificationController = Get.put(VerificationMethods());
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
      _tokenStorage.storeToken(responseData["token"]);

      if (response.statusCode == 404) {
        CustomSnackbar.show("Error", "Invalid Credentials");
        return;
      }

      if (!userModel.isEmailVerified || !userModel.isPhoneVerified) {
        CustomSnackbar.show("Error", "Account not verified");
        return Get.toNamed(AppRoutes.verificationChecker, arguments: {
          "onClickToProceed": () {
            Get.toNamed(AppRoutes.dashboard);
          }
        });
      }
      if (userModel.video.isEmpty) {
        Get.toNamed(AppRoutes.introductionVideo);
        CustomSnackbar.show("Error", "Video not uploaded");
        return;
      }
      if (userModel.gender.isEmpty) {
        Get.toNamed(AppRoutes.selectGender);
        return CustomSnackbar.show("Error", "Fill out your gender");
      }

      final controller = Get.put(RetrieveController());
      await controller.getUserDetails();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signUpUSer({
    required String name,
    required String email,
    required String mobileNumber,
    required DateTime dob,
    required String password,
    required String bio,
    required String gender,
  }) async {
    isloading.value = true;
    try {
      Object userObject = {
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "dob": dob.toUtc().toIso8601String(),
        "password": password,
        "bio": bio,
        "gender": gender,
      };

      final responce = await http.post(
        Uri.parse("$baseUrl/auth/signup"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(userObject),
      );
      var decodedResponseBody = json.decode(responce.body);
      if (responce.statusCode == 400) {
        return CustomSnackbar.show(
            "Error", decodedResponseBody["message"].toString());
      }

      if (responce.statusCode != 200) {
        return CustomSnackbar.show('Error', "An Error occured, try again");
      }

      await _tokenStorage.deleteToken();
      await _tokenStorage.storeToken(decodedResponseBody["token"]);
      final controller = Get.put(RetrieveController());
      await controller.getUserDetails();

      Get.toNamed(AppRoutes.verificationChecker, arguments: {
        "onClickToProceed": () {
          Get.toNamed(AppRoutes.uploadPicture);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> changePassword({required String password}) async {
    isloading.value = true;
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
    } finally {
      isloading.value = false;
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

      var decodedResponce = await json.decode(response.body);

      String tempToken = await _verificationController.sendOTP(
        emailOrPhoneNumber: email,
        parameter: "email",
      );

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
    } finally {
      isloading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    isloading.value = true;
    final String? token = await TokenStorage().getToken();
    if (token == null) {
      CustomSnackbar.show("Error", "Invalid token, login again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/user"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 401) {
        return CustomSnackbar.show("Error", "Unauthorized");
      }

      CustomSnackbar.show("Success", " account deleted successfully");
      Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
