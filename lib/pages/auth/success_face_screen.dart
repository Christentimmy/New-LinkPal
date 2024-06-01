import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/theme/app_routes.dart';

class SuccessFaceScreen extends StatelessWidget {
  const SuccessFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.check_circle,
                size: 150,
                color: Colors.lightGreen,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Face Verified",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Face verified. You can now continue using the app.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Get.to(() => DashBoardScreen());
                Get.toNamed(AppRoutes.dashboard, arguments: {
                  "startScreen": 0,
                });
              },
              child: Container(
                height: 45,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffFF496C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
