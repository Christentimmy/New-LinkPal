import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final RxBool _isShowPassword = false.obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  void loginUser() async {
    _authController.isloading.value = true;
    await _authController.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void initState() {
    super.initState();
    Get.put(RetrieveController());
    Get.put(PostController());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.white,
        body: Column(
            children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 750),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 110,
                  ),
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/newlogo.jpeg"),
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
                  const Center(
                    child: Text("Login into your account"),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey.value,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: "Email",
                          controller: _emailController,
                          isObscureText: false,
                          icon: Icons.email,
                          action: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                            isObscureText: _isShowPassword.value ? false : true,
                            icon: Icons.lock,
                            suffixICon: _isShowPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            suffixTap: () {
                              _isShowPassword.value = !_isShowPassword.value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: const Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColor.textfieldText,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * .025,
                        ),
                        Obx(
                          () => CustomButton(
                            ontap: () {
                              if (_formKey.value.currentState!.validate()) {
                                loginUser();
                              } else {
                                CustomSnackbar.show(
                                  "Error",
                                  "Filled up the fields",
                                );
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: _authController.isloading.value
                                ? const Loader()
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .045,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/google.png",
                            width: Platform.isIOS ? 100 : 110,
                            height: 110,
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/fb.png",
                            width: Platform.isIOS ? 100 : 110,
                            height: 110,
                          ),
                        ),
                        Platform.isIOS
                            ? Center(
                                child: Image.asset(
                                  "assets/apple.png",
                                  width: Platform.isIOS ? 100 : 110,
                                  height: 110,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .04,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dont' have an account? ",
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.signup);
                    _emailController.text = "";
                    _passwordController.text = "";
                  },
                  child: const Text(
                    "Sign Up",
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
        )),
      ),
    );
  }
}
