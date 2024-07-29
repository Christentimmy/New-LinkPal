import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/socket_controller.dart';
import 'package:linkingpal/models/chat_card_model.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

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
  void initState() {
    super.initState();
    if (_webSocketController.socket != null &&
        _webSocketController.socket!.connected) {
      _webSocketController.emitAndStream(widget.channedlId);
    } else {
      _webSocketController.initializeSocket();
    }
  }

  @override
  void dispose() {
    _webSocketController.chatsList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Header(name: widget.name),
              const SizedBox(height: 20),
              ChatList(
                webSocketController: _webSocketController,
                retrieveController: _retrieveController,
                channelId: widget.channedlId,
              ),
              BottomTextField(
                textController: _textController,
                webSocketController: _webSocketController,
                channelId: widget.channedlId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomTextField extends StatelessWidget {
  final TextEditingController textController;
  final SocketController webSocketController;
  final String channelId;

  const BottomTextField({
    super.key,
    required this.channelId,
    required this.textController,
    required this.webSocketController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: TextStyle(
        color: Theme.of(context).scaffoldBackgroundColor,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      maxLines: 5,
      minLines: 1,
      obscureText: false,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.disabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).primaryColor.withOpacity(0.9),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (webSocketController.socket!.connected) {
                  webSocketController.sendMessage(
                    textController.text,
                    channelId,
                  );
                  textController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                } else {
                  CustomSnackbar.showErrorSnackBar("Socket not connected");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColor.themeColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(50),
        ),
        hintStyle: TextStyle(
          color: AppColor.textfieldText.withOpacity(0.5),
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        hintText: "Write here...",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
    // return Row(
    //   children: [
    //     Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).primaryColor,
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: TextFormField(
    //           maxLines: null,
    //           cursorColor: Theme.of(context).scaffoldBackgroundColor,
    //           controller: textController,
    //           style: TextStyle(
    //             fontWeight: FontWeight.w700,
    //             color: Theme.of(context).scaffoldBackgroundColor,
    //             fontSize: 13,
    //           ),
    //           decoration: InputDecoration(
    //             suffixIcon: GestureDetector(
    //               onTap: () {
    //                 webSocketController.sendMessage(
    //                   textController.text,
    //                   channelId,
    //                 );
    //                 textController.clear();
    //                 FocusManager.instance.primaryFocus?.unfocus();
    //               },
    //               child: Icon(
    //                 Icons.send,
    //                 color: Theme.of(context).scaffoldBackgroundColor,
    //               ),
    //             ),
    //             hintText: "Type Here...",
    //             hintStyle: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 11,
    //             ),
    //             enabledBorder: const OutlineInputBorder(
    //               borderSide: BorderSide.none,
    //             ),
    //             focusedBorder: const OutlineInputBorder(
    //               borderSide: BorderSide.none,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Icon(
    //       Icons.image,
    //       color: Theme.of(context).primaryColor,
    //       size: 30,
    //     ),
    //   ],
    // );
  }
}

class ChatList extends StatelessWidget {
  final String channelId;
  // final int userIndex;
  ChatList({
    super.key,
    required SocketController webSocketController,
    required RetrieveController retrieveController,
    required this.channelId,
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

    return Obx(() {
      if (_webSocketController.isloading.value) {
        return const Expanded(
          child: Center(
            child: Loader(color: Colors.deepOrangeAccent),
          ),
        );
      }
      if (_webSocketController.chatsList.isEmpty) {
        return const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Empty"),
            ],
          ),
        );
      }

      return Expanded(
        child: ListView.builder(
          controller: _scrollController.value,
          itemCount: _webSocketController.chatsList.length,
          itemBuilder: (context, index) {
            ChatCardModel chatCardModel = _webSocketController.chatsList[index];
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
      );
    });
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
  final String name;
  const Header({
    super.key,
    required this.name,
  });

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
          name.length > 15 ? "${name.substring(0, 14)}..." : name,
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
