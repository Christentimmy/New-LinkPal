import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/verification_checker_methods.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:lottie/lottie.dart';

class VerificationChecker extends StatelessWidget {
  VerificationChecker({super.key});

  final _retrieveController = Get.put(RetrieveController());
  final _verificationCheckerMethod = Get.put(VerificationMethods());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verification Process",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Lottie.asset(
                "assets/images/verify.json",
                height: 230,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Kindly Go through the verification process below",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Obx(
                  () => ListTile(
                    title: const Text("Email Verification"),
                    trailing:
                        _retrieveController.userModel.value?.isEmailVerified ??
                                false
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                    onTap: () {
                      _verificationCheckerMethod.verifyEmail(
                        email: _retrieveController.userModel.value!.email,
                      );
                    },
                  ),
                )),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 3,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: ListTile(
                title: const Text("Phone Verification"),
                trailing:
                    _retrieveController.userModel.value?.isPhoneVerified ??
                            false
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                onTap: () {
                  _verificationCheckerMethod.verifyPhone(
                    phoneNumber: _retrieveController
                        .userModel.value!.mobileNumber
                        .toString(),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              ontap: () {
                if (!_retrieveController.userModel.value!.isEmailVerified &&
                    !_retrieveController.userModel.value!.isPhoneVerified) {
                  return CustomSnackbar.show(
                    "Error",
                    "Kindly verify your necessary details",
                  );
                }
              },
              child: const Text(
                "Proceed",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
