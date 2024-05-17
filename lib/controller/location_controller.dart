import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  Location location = Location();
  RxBool isloading = false.obs;
  final RxBool _serviceEnabled = false.obs;
  final Rx<PermissionStatus> _permissionGranted = PermissionStatus.denied.obs;
  Rx<LocationData?> locationData = Rx<LocationData?>(null);
  final _userController = Get.put(UserController());

  Future<void> checkLocationPermission() async {
    isloading.value = true;

    try {
      _serviceEnabled.value = await location.serviceEnabled();
      if (!_serviceEnabled.value) {
        _serviceEnabled.value = await location.requestService();
        if (!_serviceEnabled.value) {
          return;
        }
      }

      _permissionGranted.value = await location.hasPermission();
      if (_permissionGranted.value == PermissionStatus.denied) {
        _permissionGranted.value = await location.requestPermission();
        if (_permissionGranted.value != PermissionStatus.granted) {
          return;
        }
      }

      locationData.value = await location.getLocation();
      _userController.uploadLocation(
        lang: locationData.value!.latitude!,
        long: locationData.value!.longitude!,
      );
      CustomSnackbar.show(
        "Success",
        "Latitude: ${locationData.value!.latitude}, Longitude: ${locationData.value!.longitude}",
      );
      Get.toNamed(AppRoutes.introductionVideo);
    } catch (e) {
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
