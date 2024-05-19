import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class RetrieveController extends GetxController {
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  Future<void> getUserDetails() async {
    final String? token = await TokenStorage().getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Invalid token, login again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 401) {
        Get.toNamed(AppRoutes.verification, arguments: {
          "action": () {
            Get.offAllNamed(AppRoutes.signin);
          }
        });
        return CustomSnackbar.show(
          "Error",
          "Please verify your mobile number to continue",
        );
      }
      final responseData = await json.decode(response.body);
      final instance = UserModel.fromJson(responseData["data"]);
      userModel.value = instance;
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
      debugPrint(e.toString());
    }
  }
 
}
