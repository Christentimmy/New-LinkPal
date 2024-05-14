import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/theme/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds:1050), () {
      print("wtf1");
      Get.offAllNamed(AppRoutes.walkthrough);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "assets/images/newlogo.jpeg",
          width: 150,
        ),
      ),
    );
  }
}
