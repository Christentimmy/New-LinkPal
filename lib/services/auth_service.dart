import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthService {
  final String baseUrl = "https://linkingpal.onrender.com/v1";

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
    required bool isEmail,
    required BuildContext context,
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
      CustomSnackbar.showErrorSnackBar("Invalid Credentials", context);
      throw Exception("Invalid credentials");
    }

    final responseData = json.decode(response.body);
    return responseData;
  }
}
