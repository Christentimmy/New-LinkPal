import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/auth/success_face_screen.dart';

class ErrorFaceScreen extends StatelessWidget {
  const ErrorFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(
                Icons.error,
                size: 120,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Face Not Recognized",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Face not recognized. Please try again",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const SuccessFaceScreen());
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
                  "Try Again",
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
