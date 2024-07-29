import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class LocationController extends GetxController {
  final _userController = Get.put(UserController());

  Future<String> displayLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      String? city = placemarks[0].subAdministrativeArea;
      return city ?? "";
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

  Future<void> getCurrentCityandUpload() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      _userController.uploadLocation(
        lang: position.latitude,
        long: position.longitude,
      );
      CustomSnackbar.showSuccessSnackBar(
        "Location Uploaded Successfully",

      );
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.showErrorSnackBar("An unexpected error occurred");
    }
  }
}
