import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/models/likes_model.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';

class ReactedScreen extends StatefulWidget {
  final PostModel postModel;
  const ReactedScreen({super.key, required this.postModel});

  @override
  State<ReactedScreen> createState() => _ReactedScreenState();
}

class _ReactedScreenState extends State<ReactedScreen> {
  final _postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _postController.getSinglePost(widget.postModel.id);
  }

  @override
  void dispose() {
    super.dispose();
    _postController.allLikes.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _postController.isloading.value
          ? const LinearProgressIndicator()
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Likes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      const Divider(),
                      Obx(
                        () => _postController.allLikes.isEmpty
                            ? Center(
                                child: Lottie.network(
                                  "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: _postController.allLikes.length,
                                  itemBuilder: (context, index) {
                                    final likeData =
                                        _postController.allLikes[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.userProfileScreen,
                                            arguments: {
                                              "userId": likeData.createdBy.id,
                                            });
                                      },
                                      child: DisplayLikesCard(
                                        likeData: likeData,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class DisplayLikesCard extends StatelessWidget {
  const DisplayLikesCard({
    super.key,
    required this.likeData,
  });

  final LikesModel likeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: 40,
              width: 40,
              placeholder: (context, url) => const Center(
                child: Loader(
                  color: Colors.deepOrangeAccent,
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
              imageUrl: likeData.createdBy.avatar,
            ),
          ),
          title: Text(
            likeData.createdBy.name,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
