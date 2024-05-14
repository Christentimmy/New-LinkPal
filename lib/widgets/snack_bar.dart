




import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.deepPurple,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM, 
      duration: const Duration(seconds: 3), 
      isDismissible: true, 
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      margin: const EdgeInsets.all(15.0), 
      borderRadius: 8.0,
      borderWidth: 2.0, 
      borderColor: Colors.blue, 
      boxShadows: [
       const BoxShadow(color: Colors.black45, offset: Offset(0, 2), blurRadius: 3.0),
      ],
      shouldIconPulse: true,
    );
  }
}