import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/controller/date_controller.dart';
import 'package:linkingpal/controller/theme_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _authController = Get.put(AuthController());
  final _dateController = Get.put(DateController());
  final _themeController = Get.put(ThemeController());
  final RxBool _isShowPassword = false.obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final RxInt _selectedDay = (-2).obs;
  final RxInt _selectedMonth = (-2).obs;
  final RxInt _selectedYear = (-2).obs;
  final RxString _countryCode = "".obs;

  void signUpUser(BuildContext context) async {
    _authController.isLoading.value = true;
    String number = _countryCode + _phoneNumberController.text.trim();
    DateTime convertToDate = _dateController.getDate(
      _selectedDay.value,
      _selectedMonth.value,
      _selectedYear.value,
    );
    await _authController.signUpUSer(
      context: context,
      name: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: number,
      dob: convertToDate,
      password: _passwordController.text,
      bio: _bioController.text.trim(),
    );
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
                            hintText: "Full Name",
                            controller: _fullNameController,
                            isObscureText: false,
                            icon: Icons.person,
                            action: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                            isObscureText: false,
                            icon: Icons.email,
                            action: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: false,
                                    onSelect: (Country country) {
                                      _countryCode.value =
                                          "+${country.phoneCode}";
                                    },
                                  );
                                },
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 50,
                                    minWidth: 45,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Obx(
                                    () => _countryCode.value.isEmpty
                                        ? const Text("+88")
                                        : Text(
                                            _countryCode.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  hintText: "Phone Number",
                                  controller: _phoneNumberController,
                                  isObscureText: false,
                                  icon: Icons.email,
                                  type: TextInputType.number,
                                  action: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _dateController.showCustomDays(
                                      context, _selectedDay);
                                },
                                child: Obx(
                                  () => Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    alignment: Alignment.center,
                                    child: _selectedDay.value == -2
                                        ? const Text("DD")
                                        : Text(
                                            _selectedDay.value.toString(),
                                          ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _dateController.showCustomMonths(
                                    context,
                                    _selectedMonth,
                                  );
                                },
                                child: Obx(
                                  () => Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    alignment: Alignment.center,
                                    child: _selectedMonth.value == -2
                                        ? const Text("MM")
                                        : Text(_selectedMonth.value.toString()),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _dateController.showYearRange(
                                    context,
                                    _selectedYear,
                                  );
                                },
                                child: Obx(
                                  () => Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    alignment: Alignment.center,
                                    child: _selectedYear.value == -2
                                        ? const Text("YYYY")
                                        : Text(
                                            _selectedYear.value.toString(),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomBioTextField(
                            hintText: "Bio",
                            controller: _bioController,
                            isObscureText: false,
                            icon: Icons.person_pin,
                            action: TextInputAction.newline,
                            type: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => CustomTextField(
                              hintText: "Enter Password",
                              controller: _passwordController,
                              isObscureText:
                                  _isShowPassword.value ? false : true,
                              icon: Icons.lock,
                              action: TextInputAction.done,
                              suffixICon: _isShowPassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              suffixTap: () {
                                _isShowPassword.value = !_isShowPassword.value;
                              },
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
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Obx(
                            () => CustomButton(
                              ontap: _authController.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.value.currentState!
                                              .validate() &&
                                          _selectedDay.value != -2 &&
                                          _selectedMonth.value != -2 &&
                                          _selectedYear.value != -2) {
                                        signUpUser(context);
                                      } else {
                                        CustomSnackbar.showErrorSnackBar(
                                            "Fill out all fields");
                                      }
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                              child: _authController.isLoading.value
                                  ? Loader(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    )
                                  : Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
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
                                  Get.toNamed(AppRoutes.signin);
                                },
                                child: const Text(
                                  "Log In",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
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
