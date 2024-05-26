import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';

class PersonalDataFromUser extends StatelessWidget {
  PersonalDataFromUser({super.key});

  final RxString _selectedGender = "".obs;
  final RxString _finanClass = "".obs;
  final RxString _carOwn = "".obs;

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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    title: const Text('Man'),
                    leading: Radio<String>(
                      value: 'Man',
                      groupValue: _selectedGender.value,
                      onChanged: (String? value) {
                        _selectedGender.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    title: const Text('Woman'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Woman',
                      groupValue: _selectedGender.value,
                      onChanged: (String? value) {
                        _selectedGender.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    title: const Text('Trans'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Trans',
                      groupValue: _selectedGender.value,
                      onChanged: (String? value) {
                        _selectedGender.value = value!;
                      },
                    ),
                  ),
                ),
                Obx(
                  () => ListTile(
                    title: const Text('Gay'),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    horizontalTitleGap: 0,
                    leading: Radio<String>(
                      value: 'Gay',
                      groupValue: _selectedGender.value,
                      onChanged: (String? value) {
                        _selectedGender.value = value!;
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
                CustomButton(
                  ontap: () {
                    Get.toNamed(AppRoutes.interest, arguments: {
                      "action": () {
                        Get.toNamed(AppRoutes.locationAccess);
                      }
                    });
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
