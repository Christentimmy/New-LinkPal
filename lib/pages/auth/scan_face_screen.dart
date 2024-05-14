import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/auth/error_face_screen.dart';
import 'package:linkingpal/theme/app_theme.dart';

class ScanFaceScreen extends StatefulWidget {
  const ScanFaceScreen({super.key});

  @override
  State<ScanFaceScreen> createState() => _ScanFaceScreenState();
}

class _ScanFaceScreenState extends State<ScanFaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          "https://globetrender.com/wp-content/uploads/2019/07/AdobeStock_249548849-e1563895802200.jpeg"),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Instructions: ",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              const BulletTin(text: "Position your face within the frame."),
              const BulletTin(
                text: "Ensure good lighting and a clear view of your face.",
              ),
              const BulletTin(
                text:
                    "Hold still and keep your face within the frame for a few seconds",
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ErrorFaceScreen());
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
                    "Verify",
                    style: TextStyle(
                      fontSize: 22,
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

class BulletTin extends StatelessWidget {
  final String text;
  const BulletTin({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
