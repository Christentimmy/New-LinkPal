import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:linkingpal/controller/internet_controller.dart';
import 'package:linkingpal/controller/notification_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/pages/create_post/create_post_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/profile/profile_screen.dart';
import 'package:linkingpal/pages/setting/setting_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashBoardScreen extends StatefulWidget {
  final int? startscreen;
  const DashBoardScreen({super.key, required this.startscreen});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final InternetandConectivityChecker _internetController =
      Get.find<InternetandConectivityChecker>();
  final tokenStorage = Get.put(TokenStorage());


  final RxList _pages = [
    const HomeScreen(),
    const SwipeScreen(),
    const CreatePostScreen(),
    const ProfileScreen(),
    const SettingScreen()
  ].obs;

  final RxInt _currentIndex = 0.obs;

  @override
  void initState() {
    _currentIndex.value = widget.startscreen ?? 0;
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    NotificationController().requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Obx(() {
        return _internetController.connectivityResult.value ==
                ConnectivityResult.none
            ? Container(
                padding: const EdgeInsets.all(10),
                color: _internetController.connectivityResult.value ==
                            ConnectivityResult.none ||
                        !_internetController.isConnected.value
                    ? Colors.red
                    : Colors.green,
                child: Row(
                  children: [
                    Icon(
                      _internetController.connectivityResult.value ==
                                  ConnectivityResult.none ||
                              !_internetController.isConnected.value
                          ? Icons.signal_wifi_off
                          : Icons.check_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _internetController.connectivityResult.value ==
                                  ConnectivityResult.none ||
                              !_internetController.isConnected.value
                          ? 'No Internet Connection'
                          : 'Ready....',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      }),
      body: Obx(() => _pages[_currentIndex.value]),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Obx(
            () => GNav(
                rippleColor: Colors.grey.shade800,
                hoverColor: Colors.grey.shade700,
                selectedIndex: _currentIndex.value,
                tabBorderRadius: 30,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                gap: 8,
                onTabChange: (value) {
                  _currentIndex.value = value;
                },
                // color: Theme.of(context).scaffoldBackgroundColor,
                // activeColor: Theme.of(context).primaryColor,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade600,
                padding: const EdgeInsets.all(14),
                textStyle: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.swipe,
                    text: 'Swipe',
                  ),
                  GButton(
                    icon: Icons.add,
                    text: 'Post',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Setting',
                  ),
                ]),
          ),
        ),
      ),
      // bottomNavigationBar: Obx(
      //   () => ClipRRect(
      //     borderRadius: BorderRadius.circular(25),
      //     child: BottomNavigationBar(
      //       // backgroundColor: Theme.of(context).bottomAppBarColor,
      //       currentIndex: _currentIndex.value,
      //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //       unselectedItemColor: Theme.of(context).iconTheme.color,
      //       selectedItemColor: Theme.of(context).primaryColorDark,
      //       showSelectedLabels: false,
      //       showUnselectedLabels: false,
      //       type: BottomNavigationBarType.fixed,
      //       onTap: (value) {
      //         _currentIndex.value = value;
      //       },
      //       items: const [
      //         BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
      //         BottomNavigationBarItem(icon: Icon(Icons.swipe), label: ""),
      //         BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
      //         BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      //         BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// bottomNavigationBar: Obx(
//   () => BottomNavigationBar(
//     unselectedItemColor: Colors.grey,
//     selectedItemColor: Colors.deepOrangeAccent,
//     currentIndex: _currentIndex.value,
//     onTap: (value) {
//       _currentIndex.value = value;
//     },
//     items: const [
//       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       BottomNavigationBarItem(icon: Icon(Icons.swipe), label: "Swipe"),
//       BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post"),
//       BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.settings),
//         label: "Settings",
//       ),
//     ],
//   ),
// ),
