import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({super.key});

  final Rx<Uint8List?> _image = Rx<Uint8List?>(null);

  Future<void> _selectImageFromGallery() async {
    Uint8List? _file = await selectImage();
    if (_file != null) {
      _image.value = _file;
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _authController = Get.put(AuthController());

  final Rx<DateTime?> _timePickedByUser = Rx<DateTime?>(null);
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _timePickedByUser.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 750),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Stack(
                  //     children: [
                  //       Obx(
                  //         () => Container(
                  //           width: 120,
                  //           height: 120,
                  //           decoration: BoxDecoration(
                  //             image: _image.value != null
                  //                 ? DecorationImage(
                  //                     image: MemoryImage(_image.value!),
                  //                     fit: BoxFit.cover,
                  //                   )
                  //                 : null,
                  //             shape: BoxShape.circle,
                  //             color: AppColor.lightgrey,
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: _image.value != null
                  //               ? null
                  //               : const Padding(
                  //                   padding: EdgeInsets.all(30.0),
                  //                   child: Icon(
                  //                     Icons.person,
                  //                     size: 50,
                  //                   ),
                  //                 ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         right: 5,
                  //         bottom: 5,
                  //         child: GestureDetector(
                  //           onTap: _selectImageFromGallery,
                  //           child: Container(
                  //             height: 30,
                  //             width: 30,
                  //             decoration: BoxDecoration(
                  //               border: Border.all(
                  //                 width: 1,
                  //                 color: Colors.black,
                  //               ),
                  //               shape: BoxShape.circle,
                  //               color: Colors.grey.shade300,
                  //             ),
                  //             child: const Icon(Icons.camera_alt, size: 13),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/logo1.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Linking",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Text(
                        "Pal",
                        style: GoogleFonts.archivo(
                          textStyle: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Text fields View
                  Form(
                    key: _formKey.value,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 35,
                          ),
                          CustomTextField(
                            hintText: "Enter Full Name",
                            controller: _fullNameController,
                            isObscureText: false,
                            icon: Icons.person,
                            action: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Enter Email",
                            controller: _emailController,
                            isObscureText: false,
                            icon: Icons.email,
                            action: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Enter Phone Number",
                            controller: _phoneNumberController,
                            isObscureText: false,
                            icon: Icons.email,
                            action: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              _selectDate(context);
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.date_range_rounded),
                                  const SizedBox(width: 12),
                                  Obx(
                                    () => Text(
                                      _timePickedByUser.value != null
                                          ? DateFormat("MMM dd yyyy")
                                              .format(_timePickedByUser.value!)
                                          : "Date of Birth",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomBioTextField(
                            hintText: "Enter Bio",
                            controller: _bioController,
                            isObscureText: false,
                            icon: Icons.person_pin,
                            action: TextInputAction.newline,
                            type: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Enter Password",
                            controller: _passwordController,
                            isObscureText: true,
                            icon: Icons.lock,
                            action: TextInputAction.done,
                            passwordValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Obx(
                            () => CustomButton(
                              ontap: () {
                                if (_formKey.value.currentState!.validate() &&
                                    _timePickedByUser.value != null) {
                                     
                                  _authController.signUpUSer(
                                    name: _fullNameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    mobileNumber: _phoneNumberController.text,
                                    dob: _timePickedByUser.value.toString(),
                                    password: _passwordController.text,
                                    bio: _bioController.text,
                                  );
                                }
                              },
                              child: _authController.isloading.value
                                  ? const Loader()
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.login);
                                },
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
