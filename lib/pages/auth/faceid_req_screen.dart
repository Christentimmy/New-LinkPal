// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:linkingpal/pages/auth/scan_face_screen.dart';

class FaceReqIdScreen extends StatelessWidget {
  const FaceReqIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      Center(
                        child: CustomPaint(
                          size: const Size(200, 200),
                          painter: BrokenCirclePainter(brokenParts: 27),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 65,
                        child: Image.asset(
                          "assets/images/Vector.png",
                          width: 70,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
             const Text(
               "Verify Your Identity",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "To ensure a safe and authentic experience, please verify your identity by completing the face verification process.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(()=> const ScanFaceScreen());
                },
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF496C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Scan my face",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrokenCirclePainter extends CustomPainter {
  final int brokenParts;

  BrokenCirclePainter({required this.brokenParts});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Change this to set the color of the stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5; // Change this to adjust the width of the stroke

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    // Number of segments
    int segments = brokenParts * 2;
    double angle = (2 * math.pi) / segments;

    // Draw segments with gaps
    for (int i = 0; i < segments; i += 2) {
      double startAngle = i * angle;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        angle * 1.2, // Adjust this to control the gap size
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
