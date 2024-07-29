import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class RetrieveController extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";

  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  Rx<UserModel?> externalUserModel = Rx<UserModel?>(null);
  RxList<String> allPostFiles = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final String? token = await TokenStorage().getToken();
    if (token!.isEmpty) {
      return Get.offAllNamed(AppRoutes.signin);
    }
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/user"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final responseData = await json.decode(response.body);
      if (response.statusCode == 401) {
        return Get.toNamed(AppRoutes.verificationChecker, arguments: {
          "onClickToProceed": () {
            Get.offAllNamed(AppRoutes.dashboard);
          }
        });
      }
      final instance = UserModel.fromJson(responseData["data"]);
      userModel.value = instance;
      OneSignal.initialize(userModel.value?.id ?? "");
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar("Request timeout, Try again");
      throw Exception("Request timeout");
    } on SocketException {
      CustomSnackbar.showErrorSnackBar("No internet connection");
      throw Exception("No internet connection");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getSpecificUserId(String userId) async {
    final String? token = await TokenStorage().getToken();
    if (token!.isEmpty) {
      // CustomSnackbar.showErrorSnackBar(
      //   "Invalid token, login again",
      // );
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.get(Uri.parse("$baseUrl/user/$userId"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          });
      final decoded = await json.decode(response.body);
      print(decoded);
      if (response.statusCode != 200) {
        // CustomSnackbar.showErrorSnackBar(
        //   decoded["message"].toString(),
        // );
        return;
      }
      final instance = UserModel.fromJson(decoded["data"]);
      externalUserModel.value = instance;
      externalUserModel.refresh();
      List<dynamic> fromRes = decoded["data"]["post"];

      //mylogic
      for (var i = 0; i < fromRes.length; i++) {
        List files = fromRes[i]["files"];
        for (var y = 0; y < files.length; y++) {
          allPostFiles.add(files[y]);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void reset() {
    userModel.value = UserModel.empty();
    externalUserModel.value = UserModel.empty();
    allPostFiles.clear();
    UserModel.empty();
  }
}
