import 'dart:convert';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_list_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService extends GetxController {
  late IO.Socket _socket;
  final _retrieveController = Get.put(RetrieveController());
  final Rx<ChatListModel?> chatListModel = Rx<ChatListModel?>(null); 
  final String url =
      'https://linkingpal.onrender.com'; // Use HTTPS for secure connections

  void connect() async {
    final token = await TokenStorage().getToken(); 
    // Initialize the socket
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Specify the transport to be used
          .setExtraHeaders({'Authorization': 'Bearer $token'}) // Set headers
          .build(),
    );

    // Listen for connection
    _socket.on('connect', (_) {
      print('Connected to WebSocket server');
    });

    _socket.on("USER", (user) {
      print("User Details: $user");
    });

    _socket.on(_retrieveController.userModel.value?.id ?? "", (e){
      print("listening to id: $e");
      final ch = ChatListModel.fromJson(e);
      chatListModel.value = ch;
    });

    // Listen for messages
    _socket.on('GET_MESSAGE', (data) {
      if (data != null) {
        final decodedResponse = json.decode(data);
        print(decodedResponse);
      }
    });

    // Listen for disconnection
    _socket.on('disconnect', (_) {
      print('Disconnected from WebSocket server');
    });

    // Listen for errors
    _socket.on('error', (error) {
      print('WebSocket error: $error');
    });
  }

  void disconnect() {
    _socket.disconnect();
  }

  void sendMessage(String message) {
    _socket.emit('message', message);
  }
}
