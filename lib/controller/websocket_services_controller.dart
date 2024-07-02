import 'dart:convert';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_list_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//! todo <--> solo

class WebSocketService extends GetxController {
  late IO.Socket _socket;
  final _retrieveController = Get.put(RetrieveController());
  final Rx<ChatListModel?> chatListModel = Rx<ChatListModel?>(null);
  final String url =
      'https://linkingpal.onrender.com'; // Use HTTPS for secure connections

  @override
  void onInit() {
    super.onInit();
    connect();
  }

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

    print(_retrieveController.userModel.value!.name);

    _socket.on("USER", (user) {
      print("User Details: $user");
    });

    _socket.on("664a73056f50b6375dc82238", (e) {
      print("listening to id: $e");
      // final ch = ChatListModel.fromJson(e);
      // chatListModel.value = ch;
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

  void sendMessage(String message, String channedId) {
    final payload = {
      "channel_id": channedId,
      "message": message,
    };
    _socket.emit('SEND_MESSAGE', payload);
    print("yes");
  }

  void streamExistingChat(String channelId) {
    _socket.on("$channelId-CHAT", (e) {
      print(e);
    });
  }

  void streamLatestChat(String channelId) {
    _socket.on(channelId, (e) {
      print(e);
    });
  }
}
