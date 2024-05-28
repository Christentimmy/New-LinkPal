import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class LocationController extends GetxController {
  RxBool isloading = false.obs;
  final _userController = Get.put(UserController());

  Future<void> getCurrentCityandUpload({
    required VoidCallback onCalledWhatNext,
  }) async {
    isloading.value = true;
    final stopWatch = Stopwatch()..start();
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      print("${position.latitude}");
      print("${position.longitude}");

      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      _userController.uploadLocation(
        lang: position.latitude,
        long: position.longitude,
      );
      CustomSnackbar.show(
        "Success",
        "Location Uploaded Successfully",
      );
      onCalledWhatNext();

      // String? city = placemarks[0].subAdministrativeArea;
      // return city ?? "";
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", "An unexpected error occurred");
    } finally {
      isloading.value = false;
      stopWatch.stop();
      debugPrint("Execution Time: ${stopWatch.elapsed}");
    }
  }
}
