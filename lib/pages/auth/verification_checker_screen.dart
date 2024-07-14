import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:lottie/lottie.dart';

class VerificationCheckerScreen extends StatefulWidget {
  final VoidCallback onClickedToProceed;
  const VerificationCheckerScreen({
    super.key,
    required this.onClickedToProceed,
  });

  @override
  State<VerificationCheckerScreen> createState() =>
      _VerificationCheckerScreenState();
}

class _VerificationCheckerScreenState extends State<VerificationCheckerScreen> {
  final _retrieveController = Get.find<RetrieveController>();
  final RxBool _isloading = false.obs;
  final _locController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    _retrieveController.getUserDetails();
  }

  void verifier() async {
    _isloading.value = true;
    final controller = Get.put(RetrieveController());
    await controller.getUserDetails();
    if (!controller.userModel.value!.isEmailVerified &&
        !controller.userModel.value!.isPhoneVerified) {
      return CustomSnackbar.show(
        "Error",
        "Kindly verify your necessary details",
      );
    } else {
      widget.onClickedToProceed();
      await _locController.getCurrentCityandUpload();
    }

    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verification Process",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Lottie.asset(
                "assets/images/verification.json",
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
                  title: Text(
                    "Email Verification",
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
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
                    Get.toNamed(AppRoutes.verificationScreenEMail);
                  },
                ),
              ),
            ),
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
              child: Obx(
                () => ListTile(
                  title: Text(
                    "Phone Verification",
                    style: GoogleFonts.montserrat(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
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
                    Get.toNamed(AppRoutes.verificationScreenPhone);
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => CustomButton(
                ontap: () {
                  verifier();
                },
                child: _isloading.value
                    ? Loader(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )
                    : Text(
                        "Proceed",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
