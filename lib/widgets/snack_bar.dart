import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:linkingpal/controller/theme_controller.dart';

class CustomSnackbar {

  static void showErrorSnackBar(String messages, BuildContext context) {
    CherryToast.success(
      backgroundColor: const Color.fromARGB(216, 244, 67, 54),
      description: Text(
        messages,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      animationType: AnimationType.fromLeft,
    ).show(context);
  }

  static void showSuccessSnackBar(String messages, BuildContext context) {
    final themeController = Get.put(ThemeController());
    CherryToast.success(
      backgroundColor: themeController.isDarkMode.value ? Colors.white :Colors.black ,
      description: Text(
        messages,
        style: TextStyle(
          color: themeController.isDarkMode.value ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      animationType: AnimationType.fromLeft,
    ).show(context);
  }
}
