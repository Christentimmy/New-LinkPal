import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

class VerificationMethods extends GetxController {
  final _tokenStorage = Get.put(TokenStorage());
  final _retrieveController = Get.put(RetrieveController());
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxBool isloading = false.obs;
  Future<void> verifyEmail({required String email}) async {
    var tempToken = await sendOTP(
      emailOrPhoneNumber: email,
      parameter: "email",
    );
    Get.toNamed(AppRoutes.verification, arguments: {
      "token": tempToken,
      "isEmailType": true,
      "action": () async {
        Get.offAllNamed(AppRoutes.verificationChecker);
      },
    });
  }

  Future<void> verifyPhone({required String phoneNumber}) async {
    var tempToken = await sendOTP(
      emailOrPhoneNumber:
          _retrieveController.userModel.value?.mobileNumber.toString() ?? "",
      parameter: "mobile_number",
    );
    Get.toNamed(AppRoutes.verification, arguments: {
      "action": () {
        Get.offAllNamed(AppRoutes.verificationChecker);
      },
      "token": tempToken,
      "isEmailType": false,
    });
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
      debugPrint(decodedResponce);
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
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"otp": otp}),
      );
      debugPrint(response.body);
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

  String? extractFourDigitCode(String input) {
    // Use a regular expression to find exactly four consecutive digits
    RegExp regExp = RegExp(r'\b\d{4}\b');
    Match? match = regExp.firstMatch(input);

    // If a match is found, return the matched string, otherwise return null
    if (match != null) {
      return match.group(0);
    } else {
      return null;
    }
  }
}
