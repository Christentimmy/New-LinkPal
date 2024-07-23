import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/chat_controller.dart';
import 'package:linkingpal/models/chat_list_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:lottie/lottie.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _webSocketService = Get.find<SocketController>();

  @override
  void initState() {
    // myMethod();
    super.initState();
  }

  void myMethod() async {
    for (var i = 0; i < _webSocketService.chatHistory.length; i++) {
      print(i);
    }
  }

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
                  Text(
                    "Messages",
                    style: Theme.of(context).textTheme.bodyMedium,
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
                () => _webSocketService.chatModelList.isEmpty
                    ? _buildEmptyState()
                    : _buildChatList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/images/empty.json"),
          const Text("Empty"),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _webSocketService.chatModelList.length,
        itemBuilder: (context, index) {
          ChatListModel ch = _webSocketService.chatModelList[index];
          final List<UserChatListModel> users =
              ch.lastSentMessage.users.toList();
          int ind = users.indexWhere(
              (element) => element.userId != ch.lastSentMessage.senderId);

          if (users.isNotEmpty && ind != -1) {
            print("Receiver Id: ${users[ind].userId}");
          }
          return MessageCard(
            chatListModel: ch,
            ontap: () {
              Get.toNamed(
                AppRoutes.chat,
                arguments: {
                  "userId": users[ind].userId,
                  "channedlId": ch.channel,
                  "name": ch.name,
                },
              );
              _webSocketService.socket?.emit("GET_MESSAGE", {
                "channel_id": ch.channel,
              });
              _webSocketService.streamExistingChat(ch.channel);
            },
          );
        },
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final VoidCallback ontap;
  final ChatListModel chatListModel;
  const MessageCard({
    required this.ontap,
    super.key,
    required this.chatListModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          onTap: ontap,
          // leading: Stack(
          //   children: [
          //     Column(
          //       children: [
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(50),
          //           child: CachedNetworkImage(
          //             fit: BoxFit.cover,
          //             placeholder: (context, url) {
          //               return Center(
          //                 child: CircularProgressIndicator(
          //                   color: Colors.grey.shade100,
          //                 ),
          //               );
          //             },
          //             errorWidget: (context, url, error) => const Center(
          //               child: Icon(Icons.error),
          //             ),
          //             height: 40,
          //             width: 40,
          //             imageUrl:  retrieveController.externalUserModel.value?.image ?? "",
          //           ),
          //         ),
          //       ],
          //     ),
          //     const Positioned(
          //       bottom: 15,
          //       right: 1,
          //       child: CircleAvatar(
          //         radius: 5,
          //         backgroundColor: Colors.green,
          //       ),
          //     ),
          //   ],
          // ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chatListModel.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                chatListModel.lastSentMessage.message.length > 30
                    ? "${chatListModel.lastSentMessage.message.substring(0, 28)}..."
                    : chatListModel.lastSentMessage.message,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          trailing: Text(
            DateFormat("dd MMM yyyy").format(
              chatListModel.lastTimeUpdated,
            ),
          ),
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
