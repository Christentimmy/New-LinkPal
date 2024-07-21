import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:linkingpal/models/chat_list_model.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatController extends GetxController {
//   late IO.Socket socket;
//   final _retrieveController = Get.find<RetrieveController>();
//   RxList chatModelList = [].obs;
//   RxList chatsList = [].obs;
//   final String url = 'https://linkingpal.onrender.com';
//   RxBool isloading = false.obs;

//   @override
//   void onInit() async {
//     try {
//       final token = await TokenSecure().getToken();
//       print(token);
//       if (token != null) {
//         socket = IO.io(
//             url,
//             IO.OptionBuilder()
//                 .setTransports(['websocket'])
//                 .setExtraHeaders({'Authorization': 'Bearer $token'})
//                 .disableAutoConnect()
//                 .build());
//         connectToServer();
//         getChatList();
//       } else {
//         debugPrint("Token is null. Cannot connect to the server.");
//       }
//     } catch (e) {
//       debugPrint("Error retrieving token or connecting to server: $e");
//     }
//     super.onInit();
//   }

//   void connectToServer() async {
//     final token = await TokenSecure().getToken();
//     print(token);
//     isloading.value = true;
//     socket = IO.io(
//         url,
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .setExtraHeaders({'Authorization': 'Bearer $token'})
//             .disableAutoConnect()
//             .build());

//     socket.on('connect', (_) {
//       debugPrint("Connected Sucessfully");
//     });

//     socket.on("USER", (user) {
//       debugPrint("User Details: $user");
//     });

//     getChatList();

//     socket.on('disconnect', (_) {
//       debugPrint('Disconnected from WebSocket server');
//     });

//     socket.on('error', (error) {
//       debugPrint('WebSocket error: $error');
//     });

//     socket.connect();
//     isloading.value = false;
//   }

//   void getChatList() {
//     final userId = _retrieveController.userModel.value?.id ?? "";
//     socket.on(userId, (e) {
//       debugPrint("Listening to ID: $e");
//       final mapped = e.map((f) => ChatListModel.fromJson(f)).toList();
//       chatModelList.value = mapped;
//       chatModelList.refresh();
//     });
//   }

//   Future<void> disconnect() async {
//     if (socket.connected) {
//       print('Disconnecting socket...');
//       socket.off("USER");
//       final userId = _retrieveController.userModel.value?.id ?? "";
//       socket.off(userId);
//       socket.off('connect');
//       socket.off('disconnect');
//       socket.off('error');

//       // Disconnect and destroy socket
//       socket.disconnect();
//       socket.close();
//       socket.destroy();
//       socket.dispose();
//       print('Socket Status: ${socket.connected}');
//     }
//   }

//   void sendMessage(String message, String channedId) {
//     final payload = {
//       "channel_id": channedId,
//       "message": message,
//       "files": <String>[],
//     };
//     socket.emit('SEND_MESSAGE', payload);
//   }

//   void streamExistingChat(String channelId) {
//     socket.on("$channelId-CHAT", (e) {
//       print(e);
//       final List chh = e["messages"];
//       List<ChatCardModel> mapp =
//           chh.map((element) => ChatCardModel.fromJson(element)).toList();
//       chatsList.value = mapp;
//       chatsList.refresh();
//     });
//   }

//   void markRead({
//     required String channedId,
//     required String messageId,
//   }) async {
//     socket.emit("MARK_MESSAGE_READ", {
//       "channel_id": channedId,
//       "message_ids": [messageId],
//     });
//   }
// }

class SocketController extends GetxController {
  IO.Socket? socket;
  var isConnected = false.obs;
  final _retrieveController = Get.find<RetrieveController>();
  RxList chatModelList = [].obs;
  RxList chatsList = [].obs;
  RxBool isloading = false.obs;

  @override
  void onInit() {
    initializeSocket();
    super.onInit();
  }

  void initializeSocket() async {
    isloading.value = true;
    String? token = await TokenSecure().getToken();
    if (token == null) {
      return CustomSnackbar.show("Error", "Token is empty");
    }

    socket = IO.io('https://linkingpal.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      "forceNew": true,
    });

    socket?.connect();

    socket?.onConnect((_) {
      isConnected.value = true;
      print("Socket connected successfully");
      listenToEvents();
    });

    socket?.onDisconnect((_) {
      isConnected.value = false;
      print("Socket disconnected");
      Future.delayed(const Duration(seconds: 2), () {
        initializeSocket(); 
      });
    });

    socket?.on('connect_error', (_) {
      print("Connection error");
    });

    isloading.value = false;
  }

  void listenToEvents() {
    final id = _retrieveController.userModel.value?.id;

    socket?.on(id!, (data) {
      print('Event ID: $data');
      debugPrint("Listening to ID: $data");
      final mapped = data.map((f) => ChatListModel.fromJson(f)).toList();
      chatModelList.value = mapped;
      chatModelList.refresh();
    });

    socket?.on('USER', (data) {
      print('USER event: $data');
    });
  }

  void disconnectSocket() {
    if (socket != null) {
      socket?.off(_retrieveController.userModel.value!.id);
      socket?.off('USER');
      socket?.disconnect();
      socket = null;
      isConnected.value = false;
      socket?.close();
      print('Socket disconnected and deleted');
    }
  }

  void streamExistingChat(String channelId) {
    socket?.on("$channelId-CHAT", (e) {
      print(e);
      final List chh = e["messages"];
      List<ChatCardModel> mapp =
          chh.map((element) => ChatCardModel.fromJson(element)).toList();
      chatsList.value = mapp;
      chatsList.refresh();
    });
  }

  void sendMessage(String message, String channedId) {
    final payload = {
      "channel_id": channedId,
      "message": message,
      "files": <String>[],
    };
    socket?.emit('SEND_MESSAGE', payload);
  }

  void markRead({
    required String channedId,
    required String messageId,
  }) async {
    socket?.emit("MARK_MESSAGE_READ", {
      "channel_id": channedId,
      "message_ids": [messageId],
    });
  }

  @override
  void onClose() {
    socket?.dispose();
    super.onClose();
    socket = null;
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
