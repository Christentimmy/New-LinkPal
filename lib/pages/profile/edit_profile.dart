import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final _retrieveController = Get.put(RetrieveController());
  final _locationController = Get.put(LocationController());
  final Rx<XFile?> _image = Rx<XFile?>(null);

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: _retrieveController.userModel.value!.name,
    );
    _bioController = TextEditingController(
      text: _retrieveController.userModel.value!.bio,
    );
    _image.value == null;
  }

  final RxBool _isloading = false.obs;
  final _userController = Get.put(UserController());

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _image.value = imagePicked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Obx(
                        () => Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                            image: _image.value != null
                                ? DecorationImage(
                                    image: FileImage(
                                      File(_image.value!.path),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                      _retrieveController
                                              .userModel.value?.image ??
                                          "",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                            shape: BoxShape.circle,
                            color: AppColor.lightgrey,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _pickImageForUser();
                            },
                            icon: const Icon(Icons.camera_alt),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  hintText: "Full Name",
                  controller: _fullNameController,
                  isObscureText: false,
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                CustomBioTextField(
                  hintText: "Bio",
                  controller: _bioController,
                  isObscureText: false,
                  icon: Icons.person_2,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _locationController.getCurrentCityandUpload(
                        onCalledWhatNext: () {
                      Get.offAllNamed(AppRoutes.dashboard);
                    });
                  },
                  child: Obx(
                    () => Container(
                      height: 50,
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      child: _locationController.isloading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.deepOrangeAccent,
                            ))
                          : const Text(
                              "Update location",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.introductionVideo);
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                    child: const Text(
                      "Update Video",
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Obx(
                  () => CustomButton(
                    ontap: () {
                      if (_fullNameController.text.isEmpty &&
                          _image.value == null &&
                          _bioController.text.isEmpty) {
                        return CustomSnackbar.show("Error", "Fields unchanged");
                      } else {
                        globalUpdate(
                          image: _image.value,
                          name: _fullNameController.text,
                          bio: _bioController.text,
                          context: context,
                        );
                        _retrieveController.getUserDetails();
                      }
                    },
                    child: _isloading.value
                        ? const Loader()
                        : const Text(
                            "Update",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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

  void globalUpdate({
    required XFile? image,
    required String name,
    required String bio,
    required BuildContext context,
  }) async {
    _isloading.value = true;
    try {
      if (image != null) {
        updateUserProfile(
          image: image,
        );
      }

      if (name.isNotEmpty && bio.isNotEmpty) {
        _userController.updateUserDetails(
          name: name,
          bio: bio,
        );
        CustomSnackbar.show("Success", "Details update successfully");
      }

      _retrieveController.getUserDetails();
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isloading.value = false;
    }
  }

  void updateUserProfile({
    required XFile image,
  }) async {
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    var fileStream = http.ByteStream(image.openRead());
    var length = await image.length();
    var multipartFile = http.MultipartFile(
      'avatar',
      fileStream,
      length,
      filename: image.path.split('/').last,
    );

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://linkingpal.dasimems.com/v1/user/image"),
    );
    request.headers['Authorization'] = token;
    request.files.add(multipartFile);

    try {
      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      debugPrint(decodedResponse.toString());
      if (response.statusCode == 403) {
        return CustomSnackbar.show(
          "Error",
          "Please verify your email address and mobile number",
        );
      }
      if (response.statusCode != 200) {
        CustomSnackbar.show(
          "Error",
          "An error occured, try again",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
