import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/pages/home/notification.dart';
import 'package:linkingpal/pages/swipe/users_profile_screen.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _retrieveController = Get.put(RetrieveController());
  final _postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(50, 158, 158, 158),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 4),
              UserNameWidget(controller: _retrieveController),
              const SizedBox(height: 10),
              // Expanded(
              //   child: Obx(() {
              //     if (_postController.allUserPost.isEmpty) {
              //       return const Center(
              //         child: Text("No posts available"),
              //       );
              //     } else {
              //       return ListView.builder(
              //         itemCount: _postController.allUserPost.length,
              //         itemBuilder: (context, index) {
              //           final post = _postController.allUserPost[index];
              //           return const AltPageView();
              //         },
              //       );
              //     }
              //   }),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const AltPageView();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AltPageView extends StatelessWidget {
  const AltPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 5,
      ),
      height: 360,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: 270,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
              width: double.infinity,
              placeholder: (context, url) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade100,
                  ),
                );
              },
              imageUrl:
                  "https://images.unsplash.com/photo-1531256456869-ce942a665e80?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            ),
          ),
          const SizedBox(height: 10),
          Row(
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
                    imageUrl:
                        "https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDV8fGZlbWFsZSUyMHBpY3R1cmUlMjBwb3J0cmFpdHxlbnwwfHwwfHx8MA%3D%3D",
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Charlie Jolie",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 5),
                      FaIcon(
                        FontAwesomeIcons.certificate,
                        size: 14,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Text(
                    "Jan 24, 12:45PM",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Column(
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 22,
                  ),
                  Text(
                    "22k",
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: true,
                        context: Get.context!,
                        backgroundColor: Colors.transparent,
                        builder: (context) => altcommentSheet(context),
                      );
                    },
                    child: const Icon(
                      FontAwesomeIcons.comment,
                      size: 22,
                    ),
                  ),
                  const Text(
                    "22k",
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Text(
            "Its really cool playing today, who is online to challenge me, drop a comment and i will add......",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> displayComment(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 1.0,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return const Extra();
          },
        );
      },
    );
  }

  Widget altcommentSheet(BuildContext context) {
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
                      itemCount: 10,
                      itemBuilder: (context, index) {
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
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Wow you both look cute together. I love your kfiukbvifvubjjkfvjfkdjkndfjk;bnjsblndfkjnfdjkdbafbsf",
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.share),
                                        SizedBox(width: 6),
                                        Text("reply (25)"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const Column(
                                children: [
                                  Icon(Icons.favorite),
                                  Text("22k"),
                                ],
                              )
                            ],
                          ),
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
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: TextFormField(
              style: const TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
              // controller: controller.commentController,
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
                        // controller.postCommentApi(postId: "${model?.id}");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColor.themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
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

class Extra extends StatelessWidget {
  const Extra({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Comments",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
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
                        backgroundImage: AssetImage(
                          "assets/fatima.jpg",
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
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Wow you both look cute together. I love your kfiukbvifvubjjkfvjfkdjkndfjk;bnjsblndfkjnfdjkdbafbsf",
                            ),
                            Row(
                              children: [
                                Icon(Icons.share),
                                SizedBox(width: 6),
                                Text("reply (25)"),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Icon(Icons.favorite),
                          Text("22k"),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 45,
              child: TextFormField(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.send),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
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
