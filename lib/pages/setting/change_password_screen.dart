// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  RxBool isOldPassword = true.obs;
  RxBool isNewPassword = true.obs;
  RxBool isConPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  "Old Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => CustomTextFormField(
                    hintText: "Enter Old Password",
                    isObscureText: isOldPassword.value,
                    ontap: () {
                      isOldPassword.value = !isOldPassword.value;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "New Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Obx(
                  () => CustomTextFormField(
                    hintText: "Enter New Password",
                    isObscureText: isNewPassword.value,
                    ontap: () {
                      isNewPassword.value = !isNewPassword.value;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Obx(
                  () => CustomTextFormField(
                    hintText: "Re-enter Password",
                    isObscureText: isConPassword.value,
                    ontap: () {
                      isConPassword.value = !isConPassword.value;
                    },
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF496C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final VoidCallback ontap;
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.isObscureText,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: TextFormField(
        obscureText: isObscureText,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: ontap,
            icon: isObscureText
                ? const Icon(
                    FontAwesomeIcons.eyeSlash,
                    size: 20,
                  )
                : const Icon(
                    Icons.remove_red_eye_rounded,
                    size: 20,
                  ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
