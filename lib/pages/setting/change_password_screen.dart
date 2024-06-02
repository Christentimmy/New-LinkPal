// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final RxBool _isNewPassword = false.obs;
  final RxBool _isConPassword = false.obs;
  final RxBool _isloading = false.obs;

  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();
  final _authController = Get.put(AuthController());

  void changePassword() async {
    _isloading.value = true;
    _authController.changePassword(password: _confrimPasswordController.text);
    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                Obx(
                  () => CustomTextField(
                    hintText: "Password",
                    controller: _passwordController,
                    isObscureText: !_isNewPassword.value ? true : false,
                    icon: Icons.lock,
                    suffixICon: !_isNewPassword.value
                        ? FontAwesomeIcons.eyeSlash
                        : Icons.remove_red_eye,
                    suffixTap: () {
                      _isNewPassword.value = !_isNewPassword.value;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Obx(
                  () => CustomTextField(
                    hintText: "Confirm Password",
                    controller: _confrimPasswordController,
                    isObscureText: !_isConPassword.value ? true : false,
                    icon: Icons.lock,
                    suffixICon: !_isConPassword.value
                        ? FontAwesomeIcons.eyeSlash
                        : Icons.remove_red_eye,
                    suffixTap: () {
                      _isConPassword.value = !_isConPassword.value;
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Obx(
                  () => CustomButton(
                    ontap: () {
                      if (_passwordController.text ==
                          _confrimPasswordController.text) {
                            changePassword();
                      } else {
                        CustomSnackbar.show("Error",
                            'Fill all fields and ensure password match');
                      }
                    },
                    child: _isloading.value
                        ? const Loader()
                        : const Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
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
