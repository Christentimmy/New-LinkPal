import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SwipeController extends GetxController {
  var swipeCount = 0.obs;
  RxBool isloading = false.obs;
  var lastSwipeDate = ''.obs;
  RxBool isDisable = false.obs;
  String baseUrl = "https://linkingpal.onrender.com/v1";
  final _userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    _loadSwipeData();
  }

  void _loadSwipeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    swipeCount.value = prefs.getInt('swipeCount') ?? 0;
    lastSwipeDate.value = prefs.getString('lastSwipeDate') ?? '';
    _checkResetDailyLimit();
  }

  void deleteSwipeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("swipeCount");
    await prefs.remove("lastSwipeDate");
  }

  void _checkResetDailyLimit() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
    if (lastSwipeDate.value != today) {
      swipeCount.value = 0;
      lastSwipeDate.value = today;
      _saveSwipeData();
    }
  }

  bool swipe({required String receiverId}) {
    if (swipeCount.value <= 10) {
      swipeCount.value++;
      _saveSwipeData();
      sendMatchRequest(receiverId: receiverId);
      return true;
    } else {
      CustomSnackbar.showErrorSnackBar(
        "You have reached your daily swipe limit",
      );
      Get.toNamed(AppRoutes.premium);
      return false;
    }
  }

  void _saveSwipeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('swipeCount', swipeCount.value);
    prefs.setString('lastSwipeDate', lastSwipeDate.value);
  }

  Future<bool> sendMatchRequest({
    required String receiverId,
  }) async {
    isloading.value = true;
    try {
      final String? token = await TokenStorage().getToken();
      final uri = Uri.parse("$baseUrl/user/match/request/$receiverId")
          .replace(queryParameters: {
        "receiverId": receiverId,
      });
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return true;
      }
      if (response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
        );
        return false;
      }

      UserModel user = _userController.peopleNearBy
          .firstWhere((user) => user.id == receiverId);
      user.isMatchRequestSent = true;
      _userController.peopleNearBy.refresh();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isloading.value = false;
    }
  }
}
