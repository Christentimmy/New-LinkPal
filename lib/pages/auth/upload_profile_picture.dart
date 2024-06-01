import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class UploadProfilePicture extends StatelessWidget {
  UploadProfilePicture({super.key});

  final Rx<XFile?> _image = Rx<XFile?>(null);
  final _userController = Get.put(UserController());

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _image.value = imagePicked;
    }
  }

  void uploadPic() async {
    _userController.isloading.value = true;
    await _userController.uploadPicture(image: _image.value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: Get.height / 1.8,
                    decoration: const BoxDecoration(
                      color: AppColor.themeColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(200),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Obx(
                        () => Expanded(
                          child: GestureDetector(
                            onTap: _pickImageForUser,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 55,
                                horizontal: 35,
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
                                    : const DecorationImage(
                                        image:
                                            AssetImage("assets/images/pp1.jpg"),
                                        fit: BoxFit.contain,
                                      ),
                                borderRadius: BorderRadius.circular(15),
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
                ],
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Obx(
              () => GestureDetector(
                onTap: () async {
                  if (_image.value != null) {
                    uploadPic();
                  } else {
                    CustomSnackbar.show("Error", "select an image");
                  }
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: _userController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Upload Picture",
                          style: TextStyle(
                            color: AppColor.lightgrey,
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
