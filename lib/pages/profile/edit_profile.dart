import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
  final _retrieveController = Get.find<RetrieveController>();
  final _locationController = Get.put(LocationController());
  final Rx<XFile?> _image = Rx<XFile?>(null);

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: _retrieveController.userModel.value?.name ?? "",
    );
    _bioController = TextEditingController(
      text: _retrieveController.userModel.value?.bio ?? "",
    );
    _image.value == null;
  }

  final RxBool _isloading = false.obs;
  final RxBool _islocationloading = false.obs;
  final _userController = Get.put(UserController());

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _image.value = imagePicked;
    }
  }

  void getLocAndUpload() async {
    _islocationloading.value = true;
    await _locationController.getCurrentCityandUpload();
    Get.offAllNamed(AppRoutes.dashboard);
    _islocationloading.value = false;
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
                      Obx(() {
                        if (_image.value == null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  _retrieveController.userModel.value?.image ??
                                      "",
                              placeholder: (context, url) =>
                                  const Loader(color: Colors.deepOrangeAccent),
                              width: 150,
                              height: 150,
                            ),
                          );
                        } else {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                  File(_image.value!.path),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                          );
                        }
                      }),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _pickImageForUser();
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
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
                    getLocAndUpload();
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
                      child: _islocationloading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.deepOrangeAccent,
                              ),
                            )
                          : Text(
                              "Update location",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.updateVideo);
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
                    child: Text(
                      "Update Video",
                      style: Theme.of(context).textTheme.headlineMedium,
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
                        return CustomSnackbar.showErrorSnackBar(
                            "Fields unchanged");
                      } else {
                        globalUpdate(
                          image: _image.value,
                          name: _fullNameController.text,
                          bio: _bioController.text,
                          context: context,
                        );
                      }
                    },
                    child: _isloading.value
                        ? const Loader(
                            color: Colors.deepOrangeAccent,
                          )
                        : Text(
                            "Update",
                            style: TextStyle(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
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
        await _userController.updateUserDetails(
          name: name,
          bio: bio,
          isSignUp: false,
        );
      }

      final retrieveController = Get.put(RetrieveController());
      await retrieveController.getUserDetails();
      CustomSnackbar.showSuccessSnackBar("Details update successfully");
      Get.offAllNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
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
      CustomSnackbar.showErrorSnackBar("Login Again");
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
      Uri.parse("${_retrieveController.baseUrl}/user/image"),
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
        return CustomSnackbar.showErrorSnackBar(
          "Please verify your email address and mobile number",
        );
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          "An error occured, try again",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
