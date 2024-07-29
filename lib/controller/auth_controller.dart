// ignore_for_file: use_build_context_synchronously

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

      // if (!userModel.isEmailVerified || !userModel.isPhoneVerified) {
      //   CustomSnackbar.showErrorSnackBar("Account not verified");
      //   return Get.toNamed(AppRoutes.verificationChecker, arguments: {
      //     "onClickToProceed": () {
      //       Get.toNamed(AppRoutes.dashboard, arguments: {
      //         "startScreen": 0,
      //       });
      //     }
      //   });
      // }
      // if (userModel.video.isEmpty) {
      //   Get.toNamed(AppRoutes.updateVideo);
      //   return CustomSnackbar.showErrorSnackBar("Video not uploaded");
      // }
      // if (userModel.gender.toLowerCase() == "null") {
      //   Get.toNamed(AppRoutes.selectGender);
      //   return CustomSnackbar.showErrorSnackBar(
      //     "Fill out your gender",
      //   );
      // }

      final retrieveController = Get.find<RetrieveController>();
      final postController = Get.find<PostController>();

      await retrieveController.getUserDetails();
      postController.getAllPost();
      postController.getAllUserPost();

      authChecker(userModel);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> authChecker(UserModel user) async {
    if (!user.isEmailVerified || !user.isPhoneVerified) {
      return Get.toNamed(
        AppRoutes.verificationChecker,
        arguments: {
          "onClickToProceed": () {
            Get.toNamed(AppRoutes.dashboard, arguments: {
              "startScreen": 0,
            });
          }
        },
      );
    }

    if (user.image.isEmpty) {
       CustomSnackbar.showErrorSnackBar("Video not uploaded");
        return Get.toNamed(AppRoutes.updateProfilePicture);
    }

    if (user.video.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Video not uploaded");
      return Get.toNamed(AppRoutes.updateVideo);
    }

    if (user.gender.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Fill out your gender");
      return Get.toNamed(AppRoutes.selectGender);
    }

    if (user.mood.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Fill out interest");
      return Get.toNamed(AppRoutes.updateInterest);
    }

    if (Get.currentRoute != AppRoutes.dashboard) {
      Get.offNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
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
      Stopwatch stopwatch = Stopwatch()..start();
      final responce = await authService.signUpUser(
        name: name,
        email: email,
        mobileNumber: mobileNumber,
        dob: dob,
        password: password,
        bio: bio,
      );

      var token = responce["token"];
      await TokenStorage().storeToken(token);
      final controller = Get.find<RetrieveController>();
      await controller.getUserDetails();

      Get.toNamed(AppRoutes.verificationChecker, arguments: {
        "onClickToProceed": () {
          Get.toNamed(AppRoutes.uploadPicture);
        }
      });

      stopwatch.stop();
      print("Time execution: ${stopwatch.elapsed}");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String password,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await authService.changePassword(password: password);
      CustomSnackbar.showSuccessSnackBar("Password changed successfully");
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> forgotPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await authService.forgotPassword(email: email);
      String tempToken = await _verificationController.sendOTPEmail(
        email: email,
      );

      String? extractedCode = _verificationController
          .extractFourDigitCode(response["message"].toString());

      CustomSnackbar.showSuccessSnackBar(
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

  Future<void> deleteAccount(BuildContext context) async {
    final String? token = await TokenStorage().getToken();
    if (token == null) {
      CustomSnackbar.showErrorSnackBar("Invalid token, login again");
      Get.toNamed(AppRoutes.signin);
      return;
    }
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/user"),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json",
        },
      );
      print(response.body);
      if (response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar("Unauthorized");
        return;
      }

      CustomSnackbar.showSuccessSnackBar("Account deleted successfully");
      Get.offAllNamed(AppRoutes.signin);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjVhOTBjZDFlZGQ5YzM5OWJiNjk4ODYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYwNDh9.K99R85Y_wY-Jc6IRnZILV3RczarHdCBhHZWxBxUIYIM


//eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjgxYjlkYTU2NDM0ZDZkOGRiYTY5YmYiLCJ1c2VyQWdlbnQiOiJEYXJ0LzMuNCAoZGFydDppbykiLCJpYXQiOjE3MjAwNDYyNTB9.w1qfCAkhboXeL5pGK9cLmL0vzG1WWXoC6Sckad48oRQ