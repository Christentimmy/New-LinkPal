import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_theme.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Edit Profile"),
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
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://img.freepik.com/free-photo/pretty-smiling-joyfully-female-with-fair-hair-dressed-casually-looking-with-satisfaction_176420-15187.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                          color: AppColor.lightgrey,
                        ),
                        alignment: Alignment.center,
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
                            onPressed: () {},
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
                CustomTextField(
                  hintText: "Email",
                  controller: _emailController,
                  isObscureText: false,
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Location",
                  controller: _locationController,
                  isObscureText: false,
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Phone Number",
                  controller: _phoneController,
                  isObscureText: false,
                  icon: Icons.phone,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Age",
                  controller: _ageController,
                  isObscureText: false,
                  icon: Icons.date_range,
                ),
                const SizedBox(height: 20),
                CustomBioTextField(
                  hintText: "Bio",
                  controller: _bioController,
                  isObscureText: false,
                  icon: Icons.person_2,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  ontap: () {
                    Get.back();
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 18,
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
}
