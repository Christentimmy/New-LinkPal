// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:linkingpal/controller/retrieve_controller.dart';
// import 'package:linkingpal/controller/websocket_services_controller.dart';
// import 'package:linkingpal/models/chat_card_model.dart';
// import 'package:linkingpal/pages/message/chat_screen.dart';

// class ChatListScreen extends StatefulWidget {
//   final SocketController webSocketController;
//   final RetrieveController retrieveController;
//   final String channelId;

//   const ChatListScreen({
//     super.key,
//     required this.webSocketController,
//     required this.retrieveController,
//     required this.channelId,
//   });

//   @override
//   _ChatListScreenState createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   final ScrollController _scrollController = ScrollController();


//   // @override
//   // void initState() {
//   //   super.initState();

//   //   widget.webSocketController.socket.onConnect((_) {
//   //     //channel-CHAT
//   //     widget.webSocketController.streamExistingChat(widget.channelId);

//   //     widget.webSocketController.socket.emit('GET_MESSAGE', {
//   //       "channel_id": widget.channelId,
//   //     });
//   //   });

//   //   widget.webSocketController.chatsList.listen((_) {
//   //     _scrollToBottom();
//   //   });
//   // }



//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => widget.webSocketController.chatsList.isEmpty
//           ? const Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Empty"),
//                 ],
//               ),
//             )
//           : Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: widget.webSocketController.chatsList.length,
//                 itemBuilder: (context, index) {
//                   ChatCardModel chatCardModel =
//                       widget.webSocketController.chatsList[index];
//                   return chatCardModel.senderId ==
//                           widget.retrieveController.userModel.value?.id
//                       ? SenderChatCard(
//                           chatCardModel: chatCardModel,
//                         )
//                       : ReceiverChatCard(
//                           chatCardModel: chatCardModel,
//                         );
//                 },
//               ),
//             ),
//     );
//   }

//   void _scrollToBottom() {
//     // Ensure the scroll happens after the frame is built
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }
// }
