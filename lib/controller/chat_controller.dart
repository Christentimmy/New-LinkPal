import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:linkingpal/models/chat_list_model.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketController extends GetxController {
  IO.Socket? socket;
  var isConnected = false.obs;
  final _retrieveController = Get.find<RetrieveController>();
  RxList chatModelList = [].obs;
  RxList chatsList = [].obs;
  RxBool isloading = false.obs;
  RxMap<String, List<ChatCardModel>> chatHistory =
      <String, List<ChatCardModel>>{}.obs;

  @override
  void onInit() {
    initializeSocket();
    super.onInit();
  }

  void initializeSocket() async {
    isloading.value = true;
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
      final List mapped = data.map((f) => ChatListModel.fromJson(f)).toList();
      chatModelList.value = mapped;
      chatModelList.refresh();
    });

  }

  void disconnectSocket() {
    if (socket != null) {
      socket?.off(_retrieveController.userModel.value!.id);
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
      final mapp =
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
