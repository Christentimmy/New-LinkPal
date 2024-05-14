import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
// import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthController extends GetxController {
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxBool isloading = false.obs;
  final _retrieveController = Get.put(RetrieveController());
  final _tokenStorage = Get.put(TokenStorage());

  // Future<void> checkTokenAndNavigate() async {
  //   String? token = await _tokenStorage.getToken();
  //   if (token != null) {
  //     var decodedToken = JwtDecoder.decode(token);
  //     int expiryTime = decodedToken["iat"];
  //     var currentTime = DateTime.now().microsecondsSinceEpoch ~/ 1000;
  //     if (expiryTime < currentTime) {
  //       Get.offAllNamed(AppRoutes.dashboard);
  //       _tokenStorage.storeToken(token);
  //     } else {
  //       Get.offAllNamed(AppRoutes.login);
  //     }
  //   } else {
  //     Get.offAllNamed(AppRoutes.login);
  //   }
  // }

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

      // if (response.statusCode != 200) {
      //   CustomSnackbar.show("Error", "Unexpected error occurred");
      //   return;
      // }

      final responseData = await json.decode(response.body);
      // final userModel = UserModel.fromJson(responseData["data"]);
      _retrieveController.refresh();
      _tokenStorage.storeToken(responseData["token"]);

      // if (!userModel.isEmailVerified) {
      //   sendOTP(email: email);
      //   Get.toNamed(AppRoutes.verification, arguments: {
      //     "action": () {
      //       Get.offAllNamed(AppRoutes.dashboard);
      //     }
      //   });
      //   return CustomSnackbar.show("Error", "Email not verified");
      // }

      // if (!userModel.isPhoneVerified) {
      //   sendOTP(email: email);
      //   Get.toNamed(AppRoutes.verification, arguments: {
      //     "action": () {
      //       Get.offAllNamed(AppRoutes.dashboard);
      //     }
      //   });
      //   CustomSnackbar.show("Error", "Mobile number not verified");
      //   return;
      // }

      // if (userModel.video.isEmpty) {

      //   Get.toNamed(AppRoutes.introduction);
      //   CustomSnackbar.show("Error", "Video not uploaded");
      //   return;
      // }
     
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

      sendOTP(email: email);
      Get.toNamed(AppRoutes.verification, arguments: {
        "action": () {
          Get.offAllNamed(AppRoutes.interest);
        }
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

      Get.toNamed(
        AppRoutes.verification,
        arguments: {
          "action": () {
            // Get.offAllNamed(AppRoutes.dashboard);
          }
        },
      );
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> sendOTP({required String email}) async {
    String? token = await _tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"email": email}),
      );
      if (response.statusCode == 400) {
        return CustomSnackbar.show(
          "Error",
          "Please fill in either mobile number or email for verification",
        );
      }
      if (response.statusCode == 401) {
        return CustomSnackbar.show("Error", "User Not Found");
      }
      CustomSnackbar.show(
        "Success",
        "An OTP has been sent to your email",
      );
      print(response.body);
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", "Unexpected Error");
    }
  }

  Future<bool> verifyOTP({required String otp}) async {
    isloading.value = true;
    String? token = await _tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      Get.toNamed(AppRoutes.signin);
      return false;
    }
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
