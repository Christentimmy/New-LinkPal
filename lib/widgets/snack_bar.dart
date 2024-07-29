import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/theme_controller.dart';

class CustomSnackbar {
  static void showErrorSnackBar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: const Color.fromARGB(216, 244, 67, 54),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(35),
      borderRadius: 25,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.cancel, color: Colors.white),
      shouldIconPulse: true,
      borderColor: Colors.white,
      borderWidth: 1.0,
      overlayColor: Colors.black38,
      overlayBlur: 1.0,
    );
  }

  static void showSuccessSnackBar(String message) {
    final themeController = Get.put(ThemeController());
    final isDarkMode = themeController.isDarkMode.value;
    Get.snackbar(
      'Success',
      message,
      backgroundColor: isDarkMode ? Colors.white : Colors.black,
      colorText: isDarkMode ? Colors.black : Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(35),
      borderRadius: 25,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      snackStyle: SnackStyle.FLOATING,
      icon: Icon(Icons.check_circle, color: isDarkMode ? Colors.black : Colors.white),
      shouldIconPulse: true,
      borderColor: Colors.white,
      borderWidth: 1.0,
      overlayColor: Colors.black38,
      overlayBlur: 1.0,
    );
  }
}
