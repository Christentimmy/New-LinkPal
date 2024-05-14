import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/dashboard_screen.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => DashBoardScreen());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Create Post",
          style: TextStyle(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Add Image/Video"),
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.add,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.photo_sharp,
                      size: 40,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                ),
                child: TextField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Write here...",
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                ontap: () {
                  Get.back();
                },
                child: const Text(
                  "Post Now",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
