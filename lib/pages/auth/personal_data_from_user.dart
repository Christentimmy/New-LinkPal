import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class PersonalDataFromUser extends StatelessWidget {
  PersonalDataFromUser({super.key});

  final RxString _finanClass = "".obs;
  final RxString _carOwn = "".obs;
  final RxString _genderSelected = ''.obs;

  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Personal Data",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Financial Class: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _finanClass.value = "Ultra High Net Worth |UHNW|";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Ultra High Net Worth |UHNW|'),
                    leading: Radio<String>(
                      value: 'Ultra High Net Worth |UHNW|',
                      groupValue: _finanClass.value,
                      onChanged: (String? value) {
                        _finanClass.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _finanClass.value = "High Net Worth |HNW|";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('High Net Worth |HNW|'),
                    leading: Radio<String>(
                      value: 'High Net Worth |HNW|',
                      groupValue: _finanClass.value,
                      onChanged: (String? value) {
                        _finanClass.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _finanClass.value = "Medium Net Worth |MNW|";
                    },
                    title: const Text('Medium Net Worth |MNW|'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Medium Net Worth |MNW|',
                      groupValue: _finanClass.value,
                      onChanged: (String? value) {
                        _finanClass.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _finanClass.value = "Small net worth |SNW|";
                    },
                    title: const Text('Small net worth |SNW|'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Small net worth |SNW|',
                      groupValue: _finanClass.value,
                      onChanged: (String? value) {
                        _finanClass.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _finanClass.value = "Prefer not to say";
                    },
                    title: const Text('Prefer not to say'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Prefer not to say',
                      groupValue: _finanClass.value,
                      onChanged: (String? value) {
                        _finanClass.value = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Gender: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _genderSelected.value = "Male";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Male'),
                    leading: Radio<String>(
                      value: 'Male',
                      groupValue: _genderSelected.value,
                      onChanged: (String? value) {
                        _genderSelected.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _genderSelected.value = "Female";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Female'),
                    leading: Radio<String>(
                      value: 'Female',
                      groupValue: _genderSelected.value,
                      onChanged: (String? value) {
                        _genderSelected.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _genderSelected.value = "Others";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Others'),
                    leading: Radio<String>(
                      value: 'Others',
                      groupValue: _genderSelected.value,
                      onChanged: (String? value) {
                        _genderSelected.value = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Own a car: ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _carOwn.value = "Yes";
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Yes'),
                    leading: Radio<String>(
                      value: 'Yes',
                      groupValue: _carOwn.value,
                      onChanged: (String? value) {
                        _carOwn.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    onTap: () {
                      _carOwn.value = "No";
                    },
                    title: const Text('No'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'No',
                      groupValue: _carOwn.value,
                      onChanged: (String? value) {
                        _carOwn.value = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomButton(
                    ontap: () {
                      if (_finanClass.value.isNotEmpty &&
                          _carOwn.value.isNotEmpty &&
                          _genderSelected.value.isNotEmpty) {
                        _userController.updateUserDetails(
                            gender: _genderSelected.value,
                            onClickToProceed: () {
                              Get.toNamed(
                                AppRoutes.introductionVideo,
                                arguments: {
                                  "action": () {
                                    Get.offAllNamed(
                                      AppRoutes.interest,
                                      arguments: {
                                        "action": () {
                                          Get.offAllNamed(AppRoutes.dashboard,
                                              arguments: {
                                                "startScreen": 1,
                                              });
                                        }
                                      },
                                    );
                                  },
                                },
                              );
                            });
                      } else {
                        CustomSnackbar.show("Error", "Select required fields");
                      }
                    },
                    child: _userController.isloading.value
                        ? const Loader()
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
