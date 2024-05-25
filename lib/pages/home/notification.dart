import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatelessWidget {
   NotificationScreen({super.key});

  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          child: Column(
            children: [
              const Divider(),
             Obx(() => _userController.userNotifications.isEmpty ? 
             Center(
                        child: Lottie.network(
                          "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                        ),
                      )
             :  Expanded(
                child: ListView.builder(
                  itemCount: _userController.userNotifications.length,
                  itemBuilder: (context, index) {
                    return const NotificationCard();
                  },
                ),
              ),),
            
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0),
          // leading: const CircleAvatar(
          //   radius: 23,
          //   backgroundImage: AssetImage("assets/alima.jpg"),
          // ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Mary Daniel ",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: "Liked you",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "23 minutes ago",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
