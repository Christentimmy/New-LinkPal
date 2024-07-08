import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _webSocketController = Get.put(SocketController());
  final _retrieveController = Get.put(RetrieveController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      navigatior();
    });
    super.initState();
  }

  void navigatior() async {
    final toknen = await TokenStorage().getToken();
    if (toknen != null && toknen.isNotEmpty) {
      Get.offNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
      await _retrieveController.getUserDetails();
      await _webSocketController.connect();
    } else {
      Get.offNamed(AppRoutes.walkthrough);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "assets/images/logo23.jpg",
          width: 150,
        ),
      ),
    );
  }
}
