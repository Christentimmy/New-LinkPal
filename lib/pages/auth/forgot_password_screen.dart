import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final _authController = Get.put(AuthController());
  final RxBool _isloading = false.obs;

  void forgotPassword() async {
    _isloading.value = true;
    _authController.forgotPassword(
      email: _emailController.text.trim(),
    );
    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(
                  "assets/images/forgot_password.json",
                  height: 200,
                  backgroundLoading: true,
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: "Email",
                  controller: _emailController,
                  isObscureText: false,
                  icon: Icons.email,
                ),
                const SizedBox(height: 40),
                Obx(
                  () => CustomButton(
                    ontap: () {
                      forgotPassword();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: _isloading.value
                        ? const Loader()
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
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
