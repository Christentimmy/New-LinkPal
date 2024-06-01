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

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }

  Future<bool> setUserState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('is_new', value);
  }
  Future<bool?> getUserState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_new');
  }
  
}
