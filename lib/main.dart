import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/internet_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/swipe_controller.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';

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
      initialBinding: BindingsBuilder(() {
        Get.put(SwipeController());
        Get.put(InternetandConectivityChecker());
        Get.put(RetrieveController());
        Get.put(PostController());
        Get.put(WebSocketService());

      }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      getPages: RouteHandler.routes,
      initialRoute: AppRoutes.initial,
    );
  }
}
