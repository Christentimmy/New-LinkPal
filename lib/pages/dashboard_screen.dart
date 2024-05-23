import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/create_post/create_post_screen.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:linkingpal/pages/profile/profile_screen.dart';
import 'package:linkingpal/pages/setting/setting_screen.dart';
import 'package:linkingpal/pages/swipe/swipe_screen.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({super.key});

  final RxList _pages = [
     HomeScreen(),
    const SwipeScreen(),
    CreatePostScreen(),
    const ProfileScreen(),
    const SettingScreen()
  ].obs;

  final RxInt _currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
