import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage extends GetxController {
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
}
