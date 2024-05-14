import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class NetworkController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Listen for changes in network connectivity
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        CustomSnackbar.show("Network", "No Internet Connection");
      }
    });
  }
}
