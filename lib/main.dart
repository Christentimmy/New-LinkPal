import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/internet_controller.dart';
import 'package:linkingpal/controller/notification_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/swipe_controller.dart';
import 'package:linkingpal/controller/theme_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        title: 'LinkingPal',
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        darkTheme: darkTheme,
        theme: lightTheme,
        initialBinding: BindingsBuilder(() {
          Get.put(SwipeController());
          Get.put(InternetandConectivityChecker());
          Get.put(UserController());
          Get.put(NotificationController());
          Get.put(RetrieveController());
          Get.put(PostController());
        }),
        debugShowCheckedModeBanner: false,
        getPages: RouteHandler.routes,
        initialRoute: AppRoutes.initial,
      ),
    );
  }
}
