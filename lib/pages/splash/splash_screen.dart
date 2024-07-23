import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _retrieveController = Get.put(RetrieveController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      await navigatior();
    });
    super.initState();
  }

  Future<void> navigatior() async {
    final token = await TokenStorage().getToken();
    if (token != null && token.isNotEmpty) {
      Get.offNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
      _retrieveController.getUserDetails(context);
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
