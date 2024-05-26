import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetandConectivityChecker extends GetxController {
  var connectivityResult = ConnectivityResult.none.obs;
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    checkInternetConnection();

    // Start listening to changes in connectivity
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityResult.value = result;
    });

    // Start listening to changes in internet connection
    InternetConnectionChecker().onStatusChange.listen((status) {
      isConnected.value = status == InternetConnectionStatus.connected;
    });
  }

  Future<void> initConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    connectivityResult.value = result;
  }

  Future<void> checkInternetConnection() async {
    final result = await InternetConnectionChecker().hasConnection;
    isConnected.value = result;
  }
}
