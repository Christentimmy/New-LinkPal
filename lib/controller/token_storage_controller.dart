import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    prefs.remove("auth_token");
  }

}


class TokenSecure extends GetxController {
   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Store token
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'userToken', value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'userToken');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'userToken');
  }
}