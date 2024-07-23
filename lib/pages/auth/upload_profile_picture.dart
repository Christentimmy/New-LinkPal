import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class UploadProfilePicture extends StatelessWidget {
  UploadProfilePicture({super.key});

  final Rx<XFile?> _image = Rx<XFile?>(null);
  final _userController = Get.put(UserController());
  final RxBool _isloading = false.obs;

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _image.value = imagePicked;
    }
  }

  void uploadPic(BuildContext context) async {
    _isloading.value = true;
    await _userController.uploadPicture(image: _image.value!, context: context);
    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.57,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: 55,
                      horizontal: 25,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.grey,
                      ),
                      color: Colors.white,
                      image: _image.value != null
                          ? DecorationImage(
                              image: FileImage(
                                File(_image.value!.path),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImageForUser,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 50,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomButton(
                  ontap: () {
                    if (_image.value != null) {
                      uploadPic(context);
                    } else {
                      CustomSnackbar.showErrorSnackBar("select an image", context);
                    }
                  },
                  child: _isloading.value
                      ? Loader(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        )
                      : Text(
                          "Upload Picture",
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
