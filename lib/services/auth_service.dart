import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/widgets/snack_bar.dart';

class AuthService {
  final String baseUrl = "https://linkingpal.onrender.com/v1";
  http.Client client = http.Client();

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
    required bool isEmail,
    BuildContext? context,
  }) async {
    try {
      final body = json.encode({
        isEmail ? "email" : "mobile_number": email,
        "password": password,
      });

      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/login"),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 404 || response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar("Invalid Credentials");
        throw Exception("Invalid credentials");
      }
      final responseData = json.decode(response.body);
      return responseData;
    } on SocketException {
      CustomSnackbar.showErrorSnackBar("Check internet connection");
      throw Exception("No internet connection");
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar(
          "Request timeout, probably Bad network, try again");
      throw Exception("Request Time out");
    } catch (e) {
      throw Exception("unexpected error $e");
    }
  }

  Future<Map<String, dynamic>> signUpUser({
    required String name,
    required String email,
    required String mobileNumber,
    required DateTime dob,
    required String password,
    required String bio,
  }) async {
    try {
      final body = json.encode({
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "dob": dob.toUtc().toIso8601String(),
        "password": password,
        "bio": bio,
      });

      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/signup"),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      if (response.body.isEmpty) {
        throw Exception("Empty response");
      }

      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        throw Exception("Error occured");
      }
      return decoded;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      throw Exception("No internet connection");
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar(
        "Request timeout, probably Bad network, try again",
      );
      throw Exception("Request Time out");
    } catch (e) {
      throw Exception("Unexpected errors $e");
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse("$baseUrl/auth/change-password"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"password": password}),
    );

    if (response.body.isEmpty) {
      throw Exception("Empty body");
    }

    final decodedResponse = json.decode(response.body);

    if (response.statusCode != 200) {
      CustomSnackbar.showErrorSnackBar(decodedResponse["message"]);
      throw Exception("An error ocuured");
    }

    return decodedResponse;
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await client.post(
      Uri.parse("$baseUrl/auth/forgot-password"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email}),
    );
    
    final decoded = json.decode(response.body);

    if (response.statusCode == 400) {
      CustomSnackbar.showErrorSnackBar(
        "Bad request",
      );
      throw Exception("Bad Request");
    }
    if (response.statusCode == 404) {
      CustomSnackbar.showErrorSnackBar(
        "User Not Found",
      );
      throw Exception("User Not Found");
    }
    if (response.statusCode != 200) {
      CustomSnackbar.showErrorSnackBar(decoded["message"]);
      throw Exception("Error occured");
    }

    return decoded;
  }
}
