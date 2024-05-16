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
      _retrieveController.getUserDetails();
      debugPrint(
        "your phone number: ${_retrieveController.userModel.value!.isPhoneVerified}",
      );
      debugPrint(
        "your email number: ${_retrieveController.userModel.value!.isEmailVerified}",
      );
      debugPrint(
          "your account: ${_retrieveController.userModel.value!.isVerified}");
      _tokenStorage.storeToken(responseData["token"]);

      //if user email is not verified
      if (!userModel.isEmailVerified) {
        CustomSnackbar.show("Error", "Email not verified");
        var tempToken = await sendOTP(
          emailOrPhoneNumber: email,
          parameter: "email",
        );
        Get.toNamed(AppRoutes.verification, arguments: {
          "token": tempToken,
          "isEmailType": true,
          "action": () async {
            //After email is verified successfully, check if the phone number is verified
            if (!userModel.isPhoneVerified) {
              var tempToken = await sendOTP(
                emailOrPhoneNumber: userModel.mobileNumber.toString(),
                parameter: "mobile_number",
              );
              Get.toNamed(AppRoutes.verification, arguments: {
                "action": () {
                  Get.offAllNamed(AppRoutes.dashboard);
                },
                "token": tempToken,
                "isEmailType": false,
              });

              return CustomSnackbar.show("Error", "Mobile number not verified");
            }
          },
        });
        return;
      }

      if (!userModel.isPhoneVerified) {
        var tempToken = await sendOTP(
          emailOrPhoneNumber: userModel.mobileNumber.toString(),
          parameter: "mobile_number",
        );
        Get.toNamed(AppRoutes.verification, arguments: {
          "action": () {
            Get.offAllNamed(AppRoutes.dashboard);
          },
          "token": tempToken,
          "isEmailType": false,
        });

        return CustomSnackbar.show("Error", "Mobile number not verified");
      }

      if (userModel.video.isEmpty) {
        Get.toNamed(AppRoutes.introductionVideo);
        CustomSnackbar.show("Error", "Video not uploaded");
        return;
      }

      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", "Unexpected error occurred");
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

      String tempToken =
          await sendOTP(emailOrPhoneNumber: email, parameter: "email");
      Get.toNamed(AppRoutes.verification, arguments: {
        "action": () {
          Get.offAllNamed(AppRoutes.interest);
        },
        "token": tempToken,
        "isEmailType": true,
      });
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

  Future<String> sendOTP({
    required String emailOrPhoneNumber,
    required String parameter,
  }) async {
    String? token = await _tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      Get.toNamed(AppRoutes.signin);
      return "";
    }
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({parameter: emailOrPhoneNumber}),
      );
      var decodedResponce = await json.decode(response.body);
      print(decodedResponce);
      if (response.statusCode == 400) {
        CustomSnackbar.show(
          "Error",
          "Please fill in either mobile number or email for verification",
        );
        return "";
      }
      if (response.statusCode == 401) {
        CustomSnackbar.show("Error", "User Not Found");
        return "";
      }
      CustomSnackbar.show(
        "Success",
        "An OTP has been sent to your email",
      );
      return decodedResponce["token"];
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", "Unexpected Error");
      return "";
    }
  }

  Future<bool> verifyOTP({required String otp, required String token}) async {
    isloading.value = true;
    // String? token = await _tokenStorage.getToken();
    // if (token!.isEmpty) {
    //   CustomSnackbar.show("Error", "Login Again");
    //   Get.toNamed(AppRoutes.signin);
    //   return false;
    // }
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"otp": otp}),
      );
      print(response.body);
      if (response.statusCode == 400) {
        isloading.value = false;
        CustomSnackbar.show(
          "Error",
          "Error occurred whilst verifying your OTP",
        );
        return false;
      }
      if (response.statusCode == 401) {
        isloading.value = false;
        CustomSnackbar.show(
          "Error",
          "Wrong otp detected",
        );
        return false;
      }
      if (response.statusCode == 403) {
        isloading.value = false;
        CustomSnackbar.show(
          "Error",
          "OTP expired. Please request a new one",
        );
        return false;
      }
      CustomSnackbar.show(
        "Success",
        "A password reset OTP has been sent to your email",
      );

      return true;
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
      isloading.value = false;
      return false;
    }
  }
}
