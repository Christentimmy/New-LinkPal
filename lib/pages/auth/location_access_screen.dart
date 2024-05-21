import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

class LocationAccessScreen extends StatelessWidget {
  LocationAccessScreen({super.key});

  final _locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/locationBg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Center(
                child: FaIcon(
                  FontAwesomeIcons.locationDot,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Hello! Welcome",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColor.lightGreenColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Please provide your location to get started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColor.textfieldText,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Obx(
                () => CustomButton(
                  ontap: () {
                    // Get.to(() => IntroductionVideoScreen());
                    _locationController.getCurrentCityandUpload(
                        onCalledWhatNext: () {
                      Get.toNamed(AppRoutes.introductionVideo);
                    });
                  },
                  child: _locationController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Use current Location",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
