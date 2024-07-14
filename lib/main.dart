import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/internet_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/swipe_controller.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LinkingPal',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(SwipeController());
        Get.put(InternetandConectivityChecker());
        Get.put(RetrieveController());
        Get.put(PostController());
        Get.put(SocketController());
      }),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      getPages: RouteHandler.routes,
      initialRoute: AppRoutes.initial,
    );
  }
}
