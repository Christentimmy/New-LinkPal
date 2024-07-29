import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/models/notification_model.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
              Obx(
                () => _userController.isNotificationLoader.value
                    ? const LinearProgressIndicator(
                        color: Colors.deepOrangeAccent,
                      )
                    : _userController.userNotifications.isEmpty
                        ? Center(
                            child: Lottie.network(
                              "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  _userController.userNotifications.length,
                              itemBuilder: (context, index) {
                                final NotificationModel notificationModel =
                                    _userController.userNotifications[index];
                                return NotificationCard(
                                  model: notificationModel,
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel model;
  const NotificationCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: CachedNetworkImage(
              imageUrl: model.imageUrl,
              width: 100,
              height: 100,
              placeholder: (context, url) => const Loader(
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.message,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat("mmm dd yyyy").format(model.createdAt),
                style: const TextStyle(
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
