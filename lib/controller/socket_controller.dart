import 'dart:async';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:linkingpal/models/chat_list_model.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket? socket;
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
    String? token = await TokenStorage().getToken();
    if (token == null) {
      return;
    }

    socket = IO.io('https://linkingpal.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      "forceNew": true,
    });

    socket?.connect();

    socket?.onConnect((_) {
      print("Socket connected successfully");
      listenToEvents();
    });

    socket?.onDisconnect((_) {
      print("Socket disconnected");
      Future.delayed(const Duration(seconds: 2), () {
        initializeSocket();
      });
    });

    socket?.on('connect_error', (_) {
      print("Connection error");
      Future.delayed(const Duration(seconds: 2), () {
        initializeSocket();
      });
    });
  }

  void emitAndStream(String channelId) {
    isloading.value = true;
    socket?.emit("GET_MESSAGE", {
      "channel_id": channelId,
    });
    streamExistingChat(channelId); isloading.value = false;
  }

  void listenToEvents() {
    final id = _retrieveController.userModel.value?.id;
    // socket?.on(id!, (data) {
    //   final List mapped = data.map((f) => ChatListModel.fromJson(f)).toList();
    //   for (var i = 0; i < data.length; i++) {
    //     print(data[i]);
    //   }
    //   chatModelList.value = mapped;
    //   chatModelList.refresh();
    // });
    socket?.on(id!, (data) {
      final List mapped = data
          .where((f) => f['last_sent_message'] != null)
          .map((f) => ChatListModel.fromJson(f))
          .toList();
      chatModelList.value = mapped;
      chatModelList.refresh();
    });
  }

  void disconnectSocket() {
    if (socket != null) {
      socket?.off(_retrieveController.userModel.value!.id);
      socket?.disconnect();
      socket = null;
      socket?.close();
      print('Socket disconnected and deleted');
    }
  }

  void streamExistingChat(String channelId) {
    socket?.on("$channelId-CHAT", (e) {
      final List chh = e["messages"];
      print(chh.length);
      final mapp =
          chh.map((element) => ChatCardModel.fromJson(element)).toList();
      chatsList.clear();
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
