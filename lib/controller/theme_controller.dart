import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeController() {
    // Set initial theme based on system theme
    var brightness = WidgetsBinding.instance.window.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
