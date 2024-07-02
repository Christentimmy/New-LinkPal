import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/websocket_services_controller.dart';
import 'package:linkingpal/models/chat_list_model.dart';
import 'package:linkingpal/theme/app_routes.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _webSocketService = Get.put(WebSocketService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  const Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
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
              const SizedBox(height: 15),
              // const LinearActivePeople(),
              const Divider(),
              Obx(
                () => Expanded(
                    child: ListView.builder(
                  itemCount: _webSocketService
                          .chatListModel.value?.lastSentMessage.users.length ??
                      0,
                  itemBuilder: (context, index) {
                    UserChatListModel? ch = _webSocketService
                        .chatListModel.value?.lastSentMessage.users[index];
                    return MessageCard(
                      userChatListModel: ch ?? UserChatListModel.empty(),
                      ontap: () {
                        Get.toNamed(AppRoutes.chat, arguments: {
                          "userId",
                          ch?.userId ?? "",
                        });
                        // Get.to(() => const ChatScreen());
                      },
                    );
                  },
                )),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final VoidCallback ontap;
  final UserChatListModel userChatListModel;
  const MessageCard({
    required this.ontap,
    super.key,
    required this.userChatListModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          onTap: ontap,
          leading: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade100,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error),
                      ),
                      height: 40,
                      width: 40,
                      imageUrl:
                          "https://images.unsplash.com/photo-1520979580982-43f0dfe34dc8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzZ8fGZlbWFsZSUyMHBpY3R1cmUlMjBwb3J0cmFpdHxlbnwwfHwwfHx8MA%3D%3D",
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: 15,
                right: 1,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mary Daniel",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Where are you from?",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: const Text("12:20AM"),
        ),
        const Divider(),
      ],
    );
  }
}

class LinearActivePeople extends StatelessWidget {
  const LinearActivePeople({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey.shade100,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                        height: 60,
                        width: 60,
                        imageUrl:
                            "https://images.unsplash.com/photo-1511590895197-7b1da5737705?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NzJ8fGZlbWFsZSUyMHBpY3R1cmUlMjBwb3J0cmFpdHxlbnwwfHwwfHx8MA%3D%3D",
                      ),
                    ),
                    const Text("Timmy"),
                  ],
                ),
                const Positioned(
                  bottom: 20,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
