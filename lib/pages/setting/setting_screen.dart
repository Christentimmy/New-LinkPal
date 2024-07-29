import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/auth_controller.dart';
import 'package:linkingpal/controller/filter_controller.dart';
import 'package:linkingpal/controller/notification_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/swipe_controller.dart';
import 'package:linkingpal/controller/theme_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/controller/socket_controller.dart';
import 'package:linkingpal/pages/setting/blocked_user_screen.dart';
import 'package:linkingpal/pages/setting/change_password_screen.dart';
import 'package:linkingpal/pages/setting/privacy_policy_screen.dart';
import 'package:linkingpal/pages/setting/terms_screen.dart';
import 'package:linkingpal/res/display_dialog_box.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _retrieveController = Get.find<RetrieveController>();
  final themeController = Get.put(ThemeController());
  final _authController = Get.put(AuthController());
  final _userController = Get.put(UserController());
  final _postController = Get.put(PostController());
  final _notController = Get.find<NotificationController>();
  final _socketController = Get.put(SocketController());
  final RxBool _isloadingDelete = false.obs;
  final RxBool _isloadingLogOut = false.obs;

  Future<void> deleteUser() async {
    _isloadingDelete.value = true;
    _retrieveController.reset();
    _userController.reset();
    _postController.reset();
    SwipeController().deleteSwipeData();
    await _authController.deleteAccount(context);
    await TokenStorage().deleteToken();
    _socketController.disconnectSocket();
    _isloadingDelete.value = false;
  }

  Future<void> logOut() async {
    _isloadingLogOut.value = true;
    _retrieveController.reset();
    _userController.reset();
    _postController.reset();
    SwipeController().deleteSwipeData();
    await TokenStorage().deleteToken();
    _socketController.disconnectSocket();
    _isloadingLogOut.value = false;
    FilterController().resetFilters();
    print("Socket status: ${_socketController.socket?.connected}");
    Get.offAllNamed(AppRoutes.signin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Dark Mode",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Obx(
                      () => CupertinoSwitch(
                        value: themeController.isDarkMode.value,
                        activeColor: Theme.of(context).primaryColorDark,
                        onChanged: (newValue) {
                          themeController.toggleTheme();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Notification",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Obx(
                      () => CupertinoSwitch(
                        value: _notController.isNotificationGranted.value,
                        activeColor: Theme.of(context).primaryColorDark,
                        onChanged: (newValue) {
                          _notController.toggleNotification();
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
                  leading: Text(
                    "Change Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  onTap: () {
                    Get.to(() => const BlockedUserScreen());
                  },
                  leading: Text(
                    "Block Users",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                const Divider(),
                ListTile(
                  onTap: () {
                    Get.toNamed(AppRoutes.premium);
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Text(
                    "Subscription",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const Divider(),
                SizedBox(height: MediaQuery.of(context).size.height / 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Text(
                    "Share This App",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => const TermsAndConditionsScreen());
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: Text(
                    "Terms and conditions",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  onTap: () {
                    Get.to(() => const PrivacyPolicyScreen());
                  },
                  leading: Text(
                    "Privacy Policy",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    displayDialogBoX(
                        context: context,
                        headTitle: "Do you want to log out?",
                        child1: Obx(
                          () => _isloadingLogOut.value
                              ? const Loader(color: Colors.redAccent)
                              : Text(
                                  "Yes",
                                  style: GoogleFonts.montserrat(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        ontap1: () async {
                          await logOut();
                        },
                        child2: Text(
                          "No",
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ontap2: () {
                          Navigator.pop(context);
                        });
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
                    child: Text(
                      "Log Out",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    displayDialogBoX(
                        context: context,
                        headTitle: "Do you want to Delete Account?",
                        child1: Obx(
                          () => _isloadingDelete.value
                              ? const Loader(color: Colors.redAccent)
                              : Text(
                                  "Yes",
                                  style: GoogleFonts.montserrat(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        ontap1: () async {
                          await deleteUser();
                        },
                        child2: Text(
                          "No",
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ontap2: () {
                          Navigator.pop(context);
                        });
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
                    child: Text(
                      "Delete Account",
                      style: Theme.of(context).textTheme.headlineMedium,
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
