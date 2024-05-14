
import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt secondsRemaining = 180.obs;
  late Timer timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value < 1) {
        timer.cancel();
      } else {
        secondsRemaining.value -= 1;
      }
    });
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}