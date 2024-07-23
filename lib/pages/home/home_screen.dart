import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/chat_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/models/comment_model.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/pages/home/full_details_of_post.dart';
import 'package:linkingpal/pages/home/notification.dart';
import 'package:linkingpal/pages/home/people_who_reacted.dart';
import 'package:like_button/like_button.dart';
import 'package:linkingpal/res/display_dialog_box.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/video_play_widget.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _retrieveController = Get.find<RetrieveController>();
  final _postController = Get.put(PostController());
  final _socketController = Get.put(SocketController());

  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() async {
    await _postController.getAllPost(context: context);
  }

  @override
  void initState() {
    establish();
    super.initState();
  }

  void establish() {
    _socketController.initializeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          height: 60,
          animSpeedFactor: 3.0,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: UserNameWidget(controller: _retrieveController),
              ),
              const SizedBox(height: 10),
              Obx(
                () {
                  return _postController.isloading.value
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: const Loader(
                            color: Colors.deepOrangeAccent,
                          ),
                        )
                      : _postController.allPost.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/images/empty.json"),
                                  const Text("Empty"),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _postController.allPost.length,
                                itemBuilder: (context, index) {
                                  final post =
                                      _postController.allPost[index].obs;
                                  return PostCardDisplay(
                                    postModel: post,
                                    retrieveController: _retrieveController,
                                  );
                                },
                              ),
                            );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostCardDisplay extends StatelessWidget {
  final Rx<PostModel> postModel;
  final RetrieveController retrieveController;
  PostCardDisplay({
    super.key,
    required this.postModel,
    required this.retrieveController,
  });

  final RxInt _currentViewPic = 1.obs;
  final RxBool _isExpand = false.obs;
  final _postController = Get.find<PostController>();
  final _retrieveController = Get.find<RetrieveController>();

  bool _isImage(String file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = file.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 450,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postModel.value.files.length,
                    onPageChanged: (value) {
                      _currentViewPic.value = value + 1;
                    },
                    itemBuilder: (context, index) {
                      final files = postModel.value.files[index];
                      final isImage = _isImage(files);
                      return GestureDetector(
                        onTap: isImage
                            ? () {
                                Get.to(
                                  () => FullDetailsOfPost(
                                    postModel: postModel.value,
                                    initalPage: index,
                                  ),
                                );
                              }
                            : null,
                        child: isImage
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                key: ValueKey(postModel.value.id),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.error),
                                ),
                                width: double.infinity,
                                height: 450,
                                placeholder: (context, url) => const Center(
                                  child: Loader(
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                imageUrl: files,
                              )
                            : VideoNetworkPlayWidget(videoUrl: files),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: postModel.value.files.length != 1
                      ? Obx(
                          () => Container(
                            height: 20,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade500,
                            ),
                            child: Text(
                              "${_currentViewPic.value.toString()}/${postModel.value.files.length}",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _retrieveController.userModel.value?.name ==
                            postModel.value.createdBy.name
                        ? GestureDetector(
                            onTap: () async {
                              displayDialogBoX(
                                  context: context,
                                  headTitle:
                                      "Do you want to edit or delete this post?",
                                  child1: Text(
                                    "Edit",
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ontap1: () {
                                    Get.toNamed(AppRoutes.editPost, arguments: {
                                      "model": postModel,
                                    });
                                  },
                                  child2: Obx(
                                    () => _postController.isDeleteLoading.value
                                        ? const Loader(
                                            color: Colors.deepOrangeAccent,
                                          )
                                        : Text(
                                            "Delete",
                                            style: GoogleFonts.montserrat(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                  ontap2: () async {
                                    await _postController.deletePost(
                                      postModel.value.id,
                                    );
                                    Get.back();
                                  });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.more_vert,
                                size: 17,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () async {
                      Get.toNamed(AppRoutes.swipedUserCardProfile, arguments: {
                        "userId": postModel.value.createdBy.id,
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 1,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey.shade100,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                              imageUrl: postModel.value.createdBy.avatar,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Row(
                          children: [
                            Text(
                              postModel.value.createdBy.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Obx(
                  () => GestureDetector(
                    onLongPress: () {
                      Get.to(() => ReactedScreen(postModel: postModel.value));
                    },
                    child: LikeButton(
                      isLiked: postModel.value.isLikeByUser,
                      onTap: (isLiked) async {
                        if (isLiked) {
                          _postController.disLikeAPost(
                              postModel.value.id, context);
                        } else {
                          _postController.likeAPost(
                              postModel.value.id, context);
                        }
                        return !isLiked;
                      },
                      // circleColor: const CircleColor(
                      //   start: Colors.redAccent,
                      //   end: Colors.redAccent,
                      // ),
                      // bubblesColor: const BubblesColor(
                      //   dotPrimaryColor: Colors.redAccent,
                      //   dotSecondaryColor: Colors.redAccent,
                      // ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: isLiked ? Colors.redAccent : Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                // GestureDetector(
                //   onLongPress: () {
                //     Get.to(() => ReactedScreen(postModel: postModel.value));
                //   },
                //   onTap: () {
                //     if (postModel.value.isLikeByUser) {
                //       _postController.disLikeAPost(
                //         postModel.value.id,
                //         context,
                //       );
                //     } else {
                //       _postController.likeAPost(postModel.value.id, context);
                //     }
                //   },
                //   child: postModel.value.isLikeByUser
                //       ? const Icon(
                //           FontAwesomeIcons.solidHeart,
                //           color: Colors.redAccent,
                //         )
                //       : const Icon(
                //           FontAwesomeIcons.heart,
                //         ),
                // ),
                const SizedBox(width: 4),
                Text(
                  postModel.value.likes.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    _postController.getComments(postModel.value.id, context);
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      context: Get.context!,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentScreen(
                        postController: _postController,
                        postModel: postModel.value,
                        retrieveController: retrieveController,
                      ),
                    );
                  },
                  child: const Icon(
                    FontAwesomeIcons.comment,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "${postModel.value.comments}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => GestureDetector(
                onTap: () {
                  _isExpand.value = !_isExpand.value;
                },
                child: _isExpand.value
                    ? Text(
                        postModel.value.text,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    : postModel.value.text.length > 80
                        ? Text.rich(
                            TextSpan(
                              text: postModel.value.text.substring(0, 79),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              children: const [
                                TextSpan(
                                  text: "...See more",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            postModel.value.text,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                DateFormat("MMM dd yyyy").format(postModel.value.createdAt),
                style: const TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                )),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class CommentScreen extends StatefulWidget {
  final PostController postController;
  final PostModel postModel;
  final RetrieveController retrieveController;
  const CommentScreen({
    super.key,
    required this.postController,
    required this.postModel,
    required this.retrieveController,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    widget.postController.commentModelsList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Get.height / 3.7),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          /// Top Comment and Icon Row
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),

          /// Top Comment
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: AppColor.borderColor.withOpacity(0.2),
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                      () {
                        return widget.postController.isCommentLoading.value
                            ? const Center(
                                child: Loader(
                                  color: Colors.deepOrangeAccent,
                                ),
                              )
                            : widget.postController.commentModelsList.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.55,
                                    child: Center(
                                      child: Lottie.network(
                                        "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                                        height: 200,
                                        width: 200,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.postController
                                        .commentModelsList.length,
                                    itemBuilder: (context, index) {
                                      final commentsMod = widget.postController
                                          .commentModelsList[index];

                                      return widget.retrieveController.userModel
                                                  .value!.id ==
                                              commentsMod.createdBy.id
                                          ? Dismissible(
                                              key: ValueKey(
                                                commentsMod.id,
                                              ),
                                              onDismissed: (direction) {
                                                widget.postController
                                                    .commentModelsList
                                                    .removeAt(index);
                                                widget.postController
                                                    .deleteComment(
                                                  commentId: commentsMod.id,
                                                  postId: widget.postModel.id,
                                                  context: context,
                                                );
                                              },
                                              child: CommentCard(
                                                commentModel: commentsMod,
                                                postController:
                                                    widget.postController,
                                                postModel: widget.postModel,
                                              ),
                                            )
                                          : CommentCard(
                                              commentModel: commentsMod,
                                              postController:
                                                  widget.postController,
                                              postModel: widget.postModel,
                                            );
                                    },
                                  );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// TextField View
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
            ),
            child: TextFormField(
              controller: _commentController,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.w800,
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
                        widget.postController.commentOnPost(
                          widget.postModel.id,
                          _commentController,
                          context,
                        );
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColor.themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => Center(
                            child: widget.postController.isloading.value
                                ? const Loader(color: Colors.deepOrangeAccent)
                                : const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                          ),
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
            ),
          )
        ],
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  final CommentModel commentModel;
  final PostModel postModel;
  final PostController postController;
  const CommentCard({
    super.key,
    required this.commentModel,
    required this.postController,
    required this.postModel,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.swipedUserCardProfile, arguments: {
                "userId": widget.commentModel.createdBy.id,
              });
            },
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(
                widget.commentModel.createdBy.avatar,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width / 1.6,
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.swipedUserCardProfile, arguments: {
                      "userId": widget.commentModel.createdBy.id,
                    });
                  },
                  child: Text(
                    widget.commentModel.createdBy.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  widget.commentModel.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // const SizedBox(height: 5),
                // const Text(
                //   "Reply",
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey,
                //     fontStyle: FontStyle.italic,
                //   ),
                // ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.commentModel.isLikeByUser) {
                    widget.postController
                        .dislikeComement(widget.commentModel.id, context);
                    setState(() {});
                  } else {
                    widget.postController
                        .likeComement(widget.commentModel.id, context);
                    setState(() {});
                  }
                },
                child: widget.commentModel.isLikeByUser
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 18,
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 18,
                      ),
              ),
              Text(
                widget.commentModel.likes.toString(),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserNameWidget extends StatelessWidget {
  final RetrieveController controller;
  const UserNameWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
              imageUrl: controller.userModel.value?.image ?? "",
              progressIndicatorBuilder: (context, url, progress) {
                return const Loader();
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello!",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                controller.userModel.value?.name ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(() => NotificationScreen());
            },
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.message);
            },
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.message,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
