import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/controller/theme_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
// import 'package:linkingpal/widgets/snack_bar.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final _themeController = Get.put(ThemeController());
  final RxBool _isShowPassword = false.obs;
  final RxBool _isloading = false.obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  void loginUser() async {
    _isloading.value = true;
    bool isEmail = _emailController.text.contains("@");
    await _authController.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
      isEmail: isEmail,
      context: context,
    );
    _isloading.value = false;
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
                  SizedBox(
                    height: Get.height / 8.0,
                  ),
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
                  SizedBox(height: Get.height / 16),
                  Form(
                    key: _formKey.value,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: "Email / Phone Number",
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
                            ontap: _isloading.value ? null  : () {
                              if (_formKey.value.currentState!.validate()) {
                                loginUser();
                              } else {
                                CustomSnackbar.showErrorSnackBar(
                                  "Filled up the fields",
                                );
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: _isloading.value
                                ? Loader(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  )
                                : Text(
                                    "Login",
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
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
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
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
