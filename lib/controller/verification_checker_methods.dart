// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

class VerificationMethods extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";
  RxBool isloading = false.obs;

  // Future<void> verifyEmail({
  //   required String email,
  //   required BuildContext context,
  // }) async {
  //   String tempToken = await sendOTPEmail(email: email);
  //   Get.toNamed(AppRoutes.verification, arguments: {
  //     "token": tempToken,
  //     "isEmailType": true,
  //     "action": () async {
  //       await _retrieveController.getUserDetails();
  //       Navigator.pop(context);
  //     },
  //   });
  // }

  // Future<void> verifyPhone({
  //   required String phoneNumber,
  //   required BuildContext context,
  // }) async {
  //   String tempToken = await sendOtpPhone(phoneNumber: phoneNumber);
  //   Get.toNamed(AppRoutes.verification, arguments: {
  //     "action": () async {
  //       await _retrieveController.getUserDetails();
  //       Navigator.pop(context);
  //     },
  //     "token": tempToken,
  //     "isEmailType": false,
  //   });
  // }

  Future<String> sendOTPEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "email": email,
        }),
      );
      var decodedResponce = await json.decode(response.body);

      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"].toString(),
          context,
        );
        return "";
      }
      if (response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar("User Not Found", context);
        return "";
      }

      String token = decodedResponce["token"];

      var extract = extractFourDigitCode(decodedResponce["message"]);
      CustomSnackbar.showSuccessSnackBar(
        "An OTP has been sent $extract",
        context,
      );
      return token;
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<String> sendOtpPhone({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "mobile_number": phoneNumber,
        }),
      );
      var decodedResponce = await json.decode(response.body);
      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"],
          context,
        );
        return "";
      }
      if (response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar("User Not Found", context);
        return "";
      }

      String token = decodedResponce["token"];

      var extract = extractFourDigitCode(decodedResponce["message"]);
      CustomSnackbar.showSuccessSnackBar(
        "An OTP has been sent $extract",
        context,
      );
      return token;
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<bool> verifyOTP({
    required String otp,
    required String token,
    required BuildContext context,
  }) async {
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
        CustomSnackbar.showErrorSnackBar(
          "Error occurred whilst verifying your OTP",
          context,
        );
        return false;
      }
      if (response.statusCode == 401) {
        isloading.value = false;
        CustomSnackbar.showErrorSnackBar(
          "Wrong otp detected",
          context,
        );
        return false;
      }
      if (response.statusCode == 403) {
        isloading.value = false;
        CustomSnackbar.showErrorSnackBar(
          "OTP expired. Please request a new one",
          context,
        );
        return false;
      }
      CustomSnackbar.showSuccessSnackBar(
        "OTP verification successful",
        context,
      );
      isloading.value = false;
      return true;
    } catch (e) {
      debugPrint(e.toString());
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
