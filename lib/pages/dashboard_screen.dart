import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/internet_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/pages/create_post/create_post_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/profile/profile_screen.dart';
import 'package:linkingpal/pages/setting/setting_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_screen.dart';

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
    HomeScreen(),
    const SwipeScreen(),
    const CreatePostScreen(),
    const ProfileScreen(),
    const SettingScreen()
  ].obs;

  final RxInt _currentIndex = 0.obs;

  @override
  void initState() {
    _currentIndex.value = widget.startscreen ?? 0;
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
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.deepOrangeAccent,
          currentIndex: _currentIndex.value,
          onTap: (value) {
            _currentIndex.value = value;
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.swipe), label: "Swipe"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
      body: Obx(() => _pages[_currentIndex.value]),
    );
  }
}
