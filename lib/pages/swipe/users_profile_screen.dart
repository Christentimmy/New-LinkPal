import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/pages/profile/all_post_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

class UsersProfileScreen extends StatefulWidget {
  final PostModel? model;
  final PostController? controller;
  const UsersProfileScreen({
    super.key,
    required this.model,
    required this.controller,
  });

  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen> {
  // final PageController _pageController = PageController();
  // final _isInitialized = false.obs;
  // var isPlaying = false.obs;
  // final Rx<VideoPlayerController?> _controller =
  //     Rx<VideoPlayerController?>(null);

  //    @override
  // void initState() {
  //   super.initState();
  //   _controller.value = VideoPlayerController.networkUrl(
  //     Uri.parse(
  //       "Video Url"
  //     ),
  //   );
  //   _controller.value!.initialize().then((_) {
  //     _isInitialized.value = true;
  //     isPlaying.value = true;
  //     _controller.value!.addListener(_onVideoPlayerChanged);
  //   });
  // }

  //    @override
  // void dispose() {
  //   _controller.value!.dispose();
  //   _controller.value!.removeListener(_onVideoPlayerChanged);
  //   super.dispose();
  // }

  // void _onVideoPlayerChanged() {
  //   if (_controller.value!.value.position ==
  //       _controller.value!.value.duration) {
  //     isPlaying.value = false;
  //   } else {
  //     // Update play/pause state
  //     isPlaying.value = _controller.value!.value.isPlaying;
  //   }
  // }

  // void playPause() {
  //   if (_controller.value!.value.isPlaying) {
  //     _controller.value!.pause();
  //   } else {
  //     _controller.value!.play();
  //   }
  //   isPlaying.value = _controller.value!.value.isPlaying;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: widget.model?.createdBy.avatar ?? "",
                    height: MediaQuery.of(context).size.height / 3.2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return const Center(
                        child: Loader(
                          color: Colors.deepOrangeAccent,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),

                // displayuserProfileAndVideo(pageController: _pageController, widget: widget),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.model?.createdBy.name ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 20,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                //location not done yet
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(
                //       Icons.location_on,
                //       color: Colors.blue,
                //     ),
                //     Text(
                //       "New York, USA",
                //       style: TextStyle(
                //         fontSize: 18,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.message);
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 2),
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.message,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(2, 2),
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: LikeButton(
                          size: 30,
                          isLiked: widget.model!.isLikeByUser,
                          onTap: (isLiked) async {
                            if (widget.model!.isLikeByUser) {
                              widget.controller!.disLikeAPost(widget.model!.id);
                              return !isLiked;
                            } else {
                              widget.controller!.likeAPost(widget.model!.id);
                              return isLiked;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Bio",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Loving and caring guy, gentle and calm, Ready to love and settle for marriage",
                    style: TextStyle(color: Color.fromARGB(200, 0, 0, 0)),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Interested In",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  width: 80,
                  margin: const EdgeInsets.only(left: 9, top: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Text(
                    "Women",
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Activity/Mood",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(
                    minHeight: 35,
                  ),
                  margin: const EdgeInsets.only(left: 9, top: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    widget.model?.createdBy.mood[0] ?? "",
                    style: const TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      const Text(
                        "Post",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AllPostScreen());
                        },
                        child: const Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://images.unsplash.com/photo-1521676129211-b7a9e7592e65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTV8fGZlbWFsZSUyMHBpY3R1cmUlMjBwb3J0cmFpdHxlbnwwfHwwfHx8MA%3D%3D",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error),
                          ),
                        ));
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class displayuserProfileAndVideo extends StatelessWidget {
//   const displayuserProfileAndVideo({
//     super.key,
//     required PageController pageController,
//     required this.widget,
//   }) : _pageController = pageController;

//   final PageController _pageController;
//   final UsersProfileScreen widget;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 3.2,
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           PageView(
//             controller: _pageController,
//             scrollDirection: Axis.horizontal,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(13),
//                 child: CachedNetworkImage(
//                   imageUrl: widget.model?.createdBy.avatar ?? "",
//                   height: double.infinity,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.grey.shade100,
//                       ),
//                     );
//                   },
//                   errorWidget: (context, url, error) =>
//                       const Center(
//                     child: Icon(Icons.error),
//                   ),
//                 ),
//               ),
//               Obx(() {
//                 if (_isInitialized.value) {
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: AspectRatio(
//                           aspectRatio:
//                               _controller.value!.value.aspectRatio,
//                           child: VideoPlayer(
//                             _controller.value!,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: Icon(
//                           isPlaying.value
//                               ? Icons.pause_circle_filled
//                               : Icons.play_circle_filled,
//                           size: 50,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               }),
//             ],
//           ),
//           Container(
//             height: 55,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.5),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//               ),
//             ),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _pageController.previousPage(
//                         duration: const Duration(milliseconds: 600),
//                         curve: Curves.easeInOut);
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 30,
//                     alignment: Alignment.center,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     child: const Icon(Icons.arrow_back_ios_new),
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     _pageController.nextPage(
//                         duration: const Duration(milliseconds: 600),
//                         curve: Curves.easeInOut);
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 30,
//                     alignment: Alignment.center,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                     child: const Icon(Icons.arrow_forward_ios),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
