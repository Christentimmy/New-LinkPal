import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthService {
  final String baseUrl = "https://linkingpal.onrender.com/v1";

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
    required bool isEmail,
  }) async {
    final body = json.encode({
      isEmail ? "email" : "mobile_number": email,
      "password": password,
    });

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 404 || response.statusCode == 401) {
      CustomSnackbar.show("Error", "Invalid Credentials");
      throw Exception("Invalid credentials");
    }

    final responseData = json.decode(response.body);
    return responseData;
  }
}
