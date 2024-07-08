import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:linkingpal/models/chat_list_model.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// //! todo <--> solo

class SocketController extends GetxController {
  late IO.Socket socket;
  final _retrieveController = Get.find<RetrieveController>();
  RxList chatModelList = [].obs;
  RxList chatsList = [].obs;
  final String url = 'https://linkingpal.onrender.com';

  Future<void> connect() async {
    final token = await TokenStorage().getToken();
    if (token == null) {
      debugPrint("token is null");
      return;
    }
    // Initialize the socket
    socket = IO.io(
      url,
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'Authorization': 'Bearer $token'}).build(),
    );

    socket.on('connect', (_) {
      debugPrint("Connected to WebSocket server");
    });

    socket.on("USER", (user) {
      debugPrint("User Details: $user");
    });

    print(_retrieveController.userModel.value?.email);
    socket.on(_retrieveController.userModel.value?.id ?? "0", (e) {
      debugPrint("Listening to ID: $e");
      final List dataFromE = e;
      final mapped = dataFromE.map((f) => ChatListModel.fromJson(f)).toList();
      chatModelList.value = mapped;
      chatModelList.refresh();
    });

    // Listen for disconnection
    socket.on('disconnect', (_) {
      debugPrint('Disconnected from WebSocket server');
    });

    // Listen for errors
    socket.on('error', (error) {
      debugPrint('WebSocket error: $error');
    });
  }

  void disconnect() {
    print(socket.active && socket.connected);
    if (socket.connected) {
      chatModelList.clear();
      socket.disconnect();
      socket.destroy();
    }
    print(socket.connected);
  }

  void sendMessage(String message, String channedId) {
    final payload = {
      "channel_id": channedId,
      "message": message,
      "files": <String>[],
    };
    socket.emit('SEND_MESSAGE', payload);
  }



  void streamExistingChat(String channelId) {
    socket.on("$channelId-CHAT", (e) {
      print(e);
      final List chh = e["messages"];
      List<ChatCardModel> mapp =
          chh.map((element) => ChatCardModel.fromJson(element)).toList();
      chatsList.value = mapp;
      chatsList.refresh();
    });
  }
  

  void streamLatestChat(String channelId) {
    socket.on(channelId, (e) {
      // ChatCardModel cardModel = ChatCardModel.fromJson(e);
      // chatsList.add(cardModel);
      // chatsList.refresh();
    });
  }

  void getOldChats(String channedId) {
    socket.on("GET_MESSAGE", (data) {
      print(data);
    });
  }
}





// class SocketController extends GetxController {
//   RxList chatModelList = [].obs;
//   final _retrieveController = Get.find<RetrieveController>();

//   Future<void> connect() async {
//     final retrieveController = Get.find<RetrieveController>();
//     final token = await TokenStorage().getToken();
//     // IO.Socket socket =
//     //     IO.io("https://linkingpal.onrender.com", <String, dynamic>{
//     //   "Authorization": "Bearer $token",
//     //   "transports": ["websocket"],
//     // });
//     IO.Socket socket = IO.io(
//       'Bearer $token',
//       IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
//           {'Authorization': 'Bearer $token'}).build(),
//     );

//     socket.connect();
//     socket.on('connect', (_) {
//       debugPrint('connected to socket server');
//     });

//     socket.on('disconnect', (_) {
//       debugPrint('disconnected from socket server');
//     });

//     socket.on('error', (data) {
//       debugPrint('Socket error: $data');
//     });

//     // Add your custom events handling here
//     socket.on('USER', (data) {
//       debugPrint('Socket User Details: $data');
//     });

//     socket.on(retrieveController.userModel.value?.id ?? "", (data) {
//       debugPrint('ChatList: $data');
//     });
//   }

//   Future<void> disconnectSocket() async {
//     final token = await TokenStorage().getToken();
//     IO.Socket socket =
//         IO.io("https://linkingpal.onrender.com", <String, dynamic>{
//       "Authorization": "Bearer $token",
//       "transports": ["websocket"],
//     });

//     socket.off('connect');
//     socket.off('disconnect');
//     socket.off('error');
//     socket.off('USER');
//     socket.off(_retrieveController.userModel.value?.id ?? "");
//     socket.disconnect();
//   }

//   @override
//   void onClose() {
//     disconnectSocket();
//     super.onClose();
//   }
// }
