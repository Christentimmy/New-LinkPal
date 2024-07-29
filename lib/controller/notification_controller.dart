import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  RxBool isNotificationGranted = false.obs;

  @override
  void onInit() {
    requestPermission();
    super.onInit();
  }

  Future<void> setNotificationState(bool boolean) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", boolean);
  }

  Future<void> toggleNotification()async{
    if(!isNotificationGranted.value){
      requestPermission();
    }
    isNotificationGranted.value = !isNotificationGranted.value;
    setNotificationState(isNotificationGranted.value);
  }

  void requestPermission() async {
    final boob = await OneSignal.Notifications.requestPermission(true);
    isNotificationGranted.value = boob;
    await setNotificationState(boob);
  }
}
