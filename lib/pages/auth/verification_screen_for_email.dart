import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/theme_controller.dart';
import 'package:linkingpal/controller/timer_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreenEmail extends StatefulWidget {
  const VerificationScreenEmail({
    super.key,
  });

  @override
  State<VerificationScreenEmail> createState() =>
      _VerificationScreenEmailState();
}

class _VerificationScreenEmailState extends State<VerificationScreenEmail> {
  final TextEditingController _pinController = TextEditingController();
  final _timerController = Get.put(TimerController());
  final _retrieveController = Get.find<RetrieveController>();
  final _verificationController = Get.put(VerificationMethods());
  final _themeController = Get.put(ThemeController());
  RxString token = "".obs;
  final RxBool _isVerify = false.obs;

  @override
  void initState() {
    sendEMail();
    super.initState();
  }

  void sendEMail() async {
    token.value = await _verificationController.sendOTPEmail(
      email: _retrieveController.userModel.value?.email ?? "",
    );
  }

  void verify(String value) async {
    _isVerify.value = await _verificationController.verifyOTP(
      otp: value,
      token: token.value,
    );
    if (_isVerify.value) {
      final controller = Get.put(RetrieveController());
      await controller.getUserDetails();
      Navigator.pop(context);
      // Get.toNamed(AppRoutes.verificationChecker, arguments: {
      //   "onClickToProceed": (){
      //     Get.offAllNamed(AppRoutes.uploadPicture);
      //   }
      // });
    }
  }

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
          title: Text(
            "Verification",
            style: Theme.of(context).textTheme.bodyMedium,
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
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: _themeController.isDarkMode.value
                              ? const AssetImage("assets/images/logo22.jpg")
                              : const AssetImage("assets/images/logo23.jpg"),
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
                      "Enter the 4-digits code sent to ${_retrieveController.userModel.value?.email ?? ""}",
                      // style: const TextStyle(
                      //   fontSize: 12,
                      //   color: AppColor.textfieldText,
                      //   fontWeight: FontWeight.w500,
                      //   letterSpacing: 0.2,
                      // ),
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    length: 4,
                    obscureText: false,
                    controller: _pinController,
                    animationType: AnimationType.fade,
                    cursorColor: Theme.of(context).scaffoldBackgroundColor,
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
                    onCompleted: (value) {
                      verify(value);
                      if (_isVerify.value) {
                        Navigator.pop(context);
                      }
                    },
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
                      ontap: () async {
                        if (_isVerify.value) {
                          final controller = Get.put(RetrieveController());
                          await controller.getUserDetails();
                          Navigator.pop(context);
                        }
                      },
                      child: _verificationController.isloading.value
                          ? Loader(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            )
                          : Text(
                              "Next",
                              style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                  _verificationController.sendOTPEmail(
                                    email: _retrieveController
                                            .userModel.value?.email ??
                                        "",
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
