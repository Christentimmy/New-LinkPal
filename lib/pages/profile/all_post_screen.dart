import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/pages/home/home_screen.dart';
import 'package:lottie/lottie.dart';

class AllPostScreen extends StatelessWidget {
  AllPostScreen({super.key});

  final _postController = Get.put(PostController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AllPosts",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_postController.allPost.isEmpty) {
                  return Center(
                    child: Lottie.network(
                      "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: _postController.allUserPost.length,
                    itemBuilder: (context, index) {
                      final post = _postController.allUserPost[index].obs;
                      return PostCardDisplay(
                        postModel: post,
                      );
                    },
                  );
                }
              }),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
