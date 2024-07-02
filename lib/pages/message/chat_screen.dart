import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/websocket_controller.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _webSocketController = Get.put(WebSocketController());
  final _webSocketService = Get.put(WebSocketService());
  final _textController = TextEditingController();
  RxString channelId = "".obs;

  @override
  void initState() {
    getChannelAndStreamExChat();
    super.initState();
  }

  void getChannelAndStreamExChat() async {
    channelId.value = await _webSocketController.getChannelId(widget.userId);
    _webSocketService.streamLatestChat(channelId.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(1, 1),
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Text(
                        "Mary Daniel",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "online",
                        style: TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 120,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey,
                        ),
                        child: const Text(
                          "Today 12:00PM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.redAccent,
                        ),
                        child: const Text(
                          "Hey There!",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text("12:00AM"),
                          Icon(Icons.check),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurpleAccent,
                        ),
                        child: const Text(
                          "Hello How are you",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text("12:00AM"),
                          Icon(Icons.check),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _webSocketService.sendMessage(
                                _textController.text,
                                channelId.value,
                              );
                              _webSocketService.streamLatestChat(channelId.value);
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.redAccent,
                            ),
                          ),
                          hintText: "Type Here...",
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.image,
                    color: Colors.deepPurpleAccent,
                    size: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
