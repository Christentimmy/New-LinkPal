import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/pages/setting/blocked_user_screen.dart';
import 'package:linkingpal/pages/setting/change_password_screen.dart';
import 'package:linkingpal/pages/setting/privacy_policy_screen.dart';
import 'package:linkingpal/pages/setting/terms_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  RxBool value = false.obs;
  final _tokenStorage = Get.put(TokenStorage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
      
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Notification",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => CupertinoSwitch(
                      value: value.value,
                      onChanged: (newValue) {
                        value.value = newValue;
                      },
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  Get.to(() => ChangePasswordScreen());
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                onTap: () {
                  Get.to(() => const BlockedUserScreen());
                },
                leading: const Text(
                  "Block Users",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              const Divider(),
              ListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.premium);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Text(
                  "Subscription",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: Text(
                  "Share This App",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => const TermsAndConditionsScreen());
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Text(
                  "Terms and conditions",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                onTap: () {
                  Get.to(() => const PrivacyPolicyScreen());
                },
                leading: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  _tokenStorage.storeToken("");
                  Get.offAllNamed(AppRoutes.signin);
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
