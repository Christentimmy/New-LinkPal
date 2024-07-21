import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class WebSocketController extends GetxController {
  String baseUrl = "https://linkingpal.onrender.com/v1";

  
  Future<String> getChannelId(String recieverId) async {
    try {
      final token = await TokenStorage().getToken();
      final uri = Uri.parse("$baseUrl/chat/channel/$recieverId");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.show("Error", decoded["message"]);
        return "";
      }
      return decoded["data"]["channel"];
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }

}
