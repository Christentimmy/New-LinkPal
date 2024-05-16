import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/timer_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final VoidCallback onClickButtonNext;
  final String token;
  final bool isEmailType;
  const VerificationScreen({
    super.key,
    required this.onClickButtonNext,
    required this.token,
    required this.isEmailType,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _timerController = Get.put(TimerController());
  final _retrieveController = Get.put(RetrieveController());
  final _verificationController = Get.put(VerificationMethods());

  RxBool _isVerify = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Verification",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/newlogo.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Text(
                      textAlign: TextAlign.center,
                      widget.isEmailType
                          ? "Enter the 4-digits code sent to ${_retrieveController.userModel.value?.email ?? ""}"
                          : "Enter the 4-digits code sent to ${_retrieveController.userModel.value?.isPhoneVerified ?? ""}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.textfieldText,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PinCodeTextField(
                    hintCharacter: "",
                    keyboardType: TextInputType.number,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColor.textfieldText,
                      fontSize: 20,
                    ),
                    length: 4,
                    obscureText: false,
                    controller: _pinController,
                    animationType: AnimationType.fade,
                    cursorColor: AppColor.themeColor,
                    pinTheme: PinTheme(
                      errorBorderColor: Colors.red,
                      borderWidth: 0,
                      activeColor: AppColor.greyHint,
                      activeFillColor: AppColor.white,
                      inactiveFillColor: AppColor.white,
                      shape: PinCodeFieldShape.circle,
                      inactiveColor: AppColor.greyHint,
                      selectedColor: Colors.deepPurpleAccent,
                      selectedFillColor: AppColor.white,
                      borderRadius: BorderRadius.circular(30),
                      fieldHeight: 60,
                      fieldWidth: MediaQuery.of(context).size.width / 5,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (value) async {
                      _isVerify.value = await _verificationController.verifyOTP(
                        otp: _pinController.text,
                        token: widget.token,
                      );
                    },
                    onEditingComplete: () async {
                      _isVerify.value = await _verificationController.verifyOTP(
                        otp: _pinController.text,
                        token: widget.token,
                      );
                    },
                    // onCompleted: (v) async {
                    //   print(v);
                    //   _isVerify.value =
                    //       await _authController.verifyOTP(otp: v);
                    // },
                    boxShadows: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(1, -2),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(-1, 2),
                        blurRadius: 5,
                      )
                    ],
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(height: 40),
                  Obx(
                    () => CustomButton(
                      // ontap: () {
                      //   Get.to(() => InterestScreen());

                      // },
                      ontap: _isVerify.value ? widget.onClickButtonNext : () {},
                      child: _verificationController.isloading.value
                          ? const Loader()
                          : const Text(
                              "Next",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't get the code? "),
                      Obx(
                        () => _timerController.secondsRemaining.value >= 1
                            ? Text("${_timerController.secondsRemaining.value}")
                            : GestureDetector(
                                onTap: () {
                                  _timerController.startTimer();
                                  _verificationController.sendOTP(
                                    emailOrPhoneNumber: widget.isEmailType
                                        ? _retrieveController
                                            .userModel.value!.email
                                        : _retrieveController
                                            .userModel.value!.mobileNumber
                                            .toString(),
                                    parameter: "email",
                                  );
                                },
                                child: const Text(
                                  "Resend",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
