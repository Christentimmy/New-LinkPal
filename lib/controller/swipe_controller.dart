

import 'package:get/get.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SwipeController extends GetxController {
  var swipeCount = 0.obs;
  var lastSwipeDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSwipeData();
  }

  void _loadSwipeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    swipeCount.value = prefs.getInt('swipeCount') ?? 0;
    lastSwipeDate.value = prefs.getString('lastSwipeDate') ?? '';
    _checkResetDailyLimit();
  }

  void _checkResetDailyLimit() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
    if (lastSwipeDate.value != today) {
      swipeCount.value = 0;
      lastSwipeDate.value = today;
      _saveSwipeData();
    }
  }

  bool swipe() {
    if (swipeCount.value <= 10) {
      swipeCount.value++;
      _saveSwipeData();
      return true;
    } else {
      CustomSnackbar.show("Limit Reached", "You have reached your daily swipe limit");
      Get.toNamed(AppRoutes.premium);
      return false;
    }
  }

  void _saveSwipeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('swipeCount', swipeCount.value);
    prefs.setString('lastSwipeDate', lastSwipeDate.value);
  }
}
