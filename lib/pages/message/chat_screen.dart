import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/chat_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:socket_io_client/socket_io_client.dart';
// import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String channedlId;
  final String name;
  // final int userIndexInsideChatListArray;
  const ChatScreen({
    super.key,
    required this.userId,
    required this.channedlId,
    required this.name,
    // required this.userIndexInsideChatListArray,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _retrieveController = Get.find<RetrieveController>();
  final _webSocketController = Get.find<SocketController>();

  @override
  void dispose() {
    super.dispose();
    _webSocketController.chatsList.clear();
  }

  @override
  void initState() {
    super.initState();
    if (_webSocketController.socket!.connected) {
      _webSocketController.socket?.emit("GET_MESSAGE", {
        "channel_id": widget.channedlId,
      });
      _webSocketController.streamExistingChat(widget.channedlId);
    } else {
      _webSocketController.socket?.onConnect((_) {
        _webSocketController.socket?.emit("GET_MESSAGE", {
          "channel_id": widget.channedlId,
        });
        _webSocketController.streamExistingChat(widget.channedlId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Header(widget: widget),
              const SizedBox(height: 20),
              // ChatListScreen(
              //   webSocketController: _webSocketController,
              //   retrieveController: _retrieveController,
              //   channelId: widget.channedlId,
              // ),
              ChatList(
                // userIndex: widget.userIndexInsideChatListArray,
                webSocketController: _webSocketController,
                retrieveController: _retrieveController,
              ),
              BottomTextField(
                textController: _textController,
                webSocketController: _webSocketController,
                widget: widget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    super.key,
    required TextEditingController textController,
    required SocketController webSocketController,
    required this.widget,
  })  : _textController = textController,
        _webSocketController = webSocketController;

  final TextEditingController _textController;
  final SocketController _webSocketController;
  final ChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              maxLines: null,
              // cursorColor: Colors.white,
              cursorColor: Theme.of(context).scaffoldBackgroundColor,
              controller: _textController,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    _webSocketController.sendMessage(
                      _textController.text,
                      widget.channedlId,
                    );
                    _webSocketController.streamExistingChat(widget.channedlId);
                    _textController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    // _webSocketService.streamLatestChat(channelId.value);
                  },
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                hintText: "Type Here...",
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
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
        Icon(
          Icons.image,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
      ],
    );
  }
}

class ChatList extends StatelessWidget {
  // final int userIndex;
  ChatList({
    super.key,
    required SocketController webSocketController,
    required RetrieveController retrieveController,
    // required this.userIndex,
  })  : _webSocketController = webSocketController,
        _retrieveController = retrieveController;

  final SocketController _webSocketController;
  final RetrieveController _retrieveController;
  final _scrollController = ScrollController().obs;

  @override
  Widget build(BuildContext context) {
    _webSocketController.chatsList.listen((_) {
      _scrollToBottom();
    });

    return Obx(
      () => _webSocketController.chatsList.isEmpty
          ? const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Empty"),
                ],
              ),
            )
          : Expanded(
              child: ListView.builder(
                controller: _scrollController.value,
                itemCount: _webSocketController.chatsList.length,
                itemBuilder: (context, index) {
                  ChatCardModel chatCardModel =
                      _webSocketController.chatsList[index];
                  // UserChatListModel userChatListModel =
                  //     chatCardModel.users[userIndex];

                  return chatCardModel.senderId ==
                          _retrieveController.userModel.value?.id
                      ? SenderChatCard(
                          chatCardModel: chatCardModel,
                          // userChatListModel: userChatListModel,
                        )
                      : ReceiverChatCard(
                          chatCardModel: chatCardModel,
                          // userChatListModel: userChatListModel,
                        );
                },
              ),
            ),
    );
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.value.hasClients) {
        _scrollController.value
            .jumpTo(_scrollController.value.position.maxScrollExtent);
      }
    });
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.widget,
  });

  final ChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
              color: Theme.of(context).primaryColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        const Spacer(),
        Text(
          widget.name.length > 15
              ? "${widget.name.substring(0, 14)}..."
              : widget.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        // Column(
        //   children: [
        //     Text(
        //       widget.name,
        //       style: Theme.of(context).textTheme.bodyLarge,
        //     ),
        //     const Text(
        //       "online",
        //       style: TextStyle(color: Colors.deepPurpleAccent),
        //     ),
        //     const SizedBox(height: 10),
        //     Container(
        //       width: 120,
        //       height: 20,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(15),
        //         color: Colors.grey,
        //       ),
        //       child: const Text(
        //         "Today 12:00PM",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 13,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
    );
  }
}

class ReceiverChatCard extends StatelessWidget {
  final ChatCardModel chatCardModel;
  // final UserChatListModel userChatListModel;

  const ReceiverChatCard({
    super.key,
    required this.chatCardModel,
    // required this.userChatListModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            minHeight: 45,
            maxWidth: Get.width * 0.7,
          ),
          decoration: const BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatCardModel.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateFormat("h:mm a").format(chatCardModel.createdAt.toLocal()),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SenderChatCard extends StatelessWidget {
  final ChatCardModel chatCardModel;
  // final UserChatListModel userChatListModel;

  const SenderChatCard({
    super.key,
    required this.chatCardModel,
    // required this.userChatListModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            minHeight: 45,
            maxWidth: Get.width * 0.7,
          ),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 90, 66, 131),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chatCardModel.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat("h:mm a")
                        .format(chatCardModel.createdAt.toLocal()),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // userChatListModel.seenAt == null
                  //     ?
                  //     const Icon(
                  //         Icons.check,
                  //         size: 15,
                  //         color: Colors.grey,
                  //       )
                  //     : const Icon(
                  //         Icons.done_all,
                  //         size: 15,
                  //         color: Colors.white,
                  //       )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
