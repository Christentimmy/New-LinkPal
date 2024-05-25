import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/pages/home/full_details_of_post.dart';
import 'package:linkingpal/pages/home/notification.dart';
import 'package:linkingpal/pages/swipe/users_profile_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _retrieveController = Get.put(RetrieveController());
  final _postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(50, 158, 158, 158),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: UserNameWidget(controller: _retrieveController),
            ),
            const SizedBox(height: 5),
            Obx(
              () {
                return _postController.allPost.isEmpty
                    ? Center(
                        child: Lottie.network(
                          "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final post = _postController.allPost[index];
                            return PostCardDisplay(postModel: post);
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostCardDisplay extends StatelessWidget {
  final PostModel postModel;
  PostCardDisplay({
    required this.postModel,
    super.key,
  });

  final RxInt _currentViewPic = 1.obs;
  final RxBool _isExpand = false.obs;
  final _postController = Get.put(PostController());
  final _retrieveController = Get.put(RetrieveController());

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 372,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postModel.files.length,
                    onPageChanged: (value) {
                      _currentViewPic.value = value + 1;
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => FullDetailsOfPost(
                              postModel: postModel,
                              initalPage: index,
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error),
                          ),
                          width: double.infinity,
                          placeholder: (context, url) {
                            return const Center(
                              child: Loader(color: Colors.deepOrangeAccent),
                            );
                          },
                          imageUrl: postModel.files[index],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: postModel.files.length != 1
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
                              "${_currentViewPic.value.toString()}/${postModel.files.length}",
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
                            postModel.createdBy.name
                        ? GestureDetector(
                            onTap: () async {
                              displayDialogBoX(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration:  BoxDecoration(
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
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const UsersProfileScreen()),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      height: 38,
                      width: 38,
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
                      imageUrl: postModel.createdBy.avatar,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          postModel.createdBy.name,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const FaIcon(
                          FontAwesomeIcons.certificate,
                          size: 14,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Text(
                      DateFormat("MMM dd yyyy").format(postModel.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    print("hi");
                    if (postModel.isLikeByUser) {
                      _postController.disLikeAPost(postModel.id);
                    } else {
                      _postController.likeAPost(postModel.id);
                    }
                  },
                  child: postModel.isLikeByUser
                      ? const Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.redAccent,
                        )
                      : const Icon(
                          FontAwesomeIcons.heart,
                        ),
                ),
                const SizedBox(width: 5),
                Text(postModel.likes.toString()),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      context: Get.context!,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentScreen(
                        postController: _postController,
                        postModel: postModel,
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
                  "${postModel.comments}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
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
                    ? Text(postModel.text)
                    : postModel.text.length > 80
                        ? Text.rich(
                            TextSpan(
                              text: postModel.text.substring(0, 79),
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
                        : Text(postModel.text),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<dynamic> displayDialogBoX(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.editPost, arguments: {
                  "model": postModel,
                });
              },
              style: ElevatedButton.styleFrom(),
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _postController.deletePost(postModel.id, context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          title: const Text(
            "Confirmation",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                "Do you want to edit or delete this post?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentScreen extends StatelessWidget {
  final PostController postController;
  final PostModel postModel;
  CommentScreen({
    super.key,
    required this.postController,
    required this.postModel,
  });
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(
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
                // const AppText(
                //   text: "Comments",
                //   fontSize: 17,
                //   color: AppColor.textfieldText,
                //   fontWeight: FontWeight.w600,
                // ),
                const Text(
                  "Comments",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColor.textfieldText,
                    fontWeight: FontWeight.w600,
                  ),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AppColor.borderColor.withOpacity(0.2),
                          thickness: 1,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    /// ListView Builder
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return const CommentCard();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// TextField View
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: TextFormField(
              controller: _commentController,
              style: const TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
              maxLines: 5,
              minLines: 1,
              obscureText: false,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.fieldColor.withOpacity(0.5),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        postController.commentOnPost(
                          postModel.id,
                          _commentController,
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
                            child: postController.isloading.value
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

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
  });

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
          const CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D",
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width / 1.6,
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fatime Collins",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Wow you both look cute together. I love your kfiukbvifvubjjkfvjfkdjkndfjk;bnjsblndfkjnfdjkdbafbsf",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.share,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "reply (25)",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          const Column(
            children: [
              Icon(
                Icons.favorite,
                size: 18,
              ),
              Text(
                "22k",
                style: TextStyle(
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
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade300,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello!",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                controller.userModel.value?.name ?? "",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(() => const NotificationScreen());
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
          Container(
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
              Icons.search,
              color: Colors.blue,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
