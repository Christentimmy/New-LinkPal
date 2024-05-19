import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/pages/profile/all_post_screen.dart';
import 'package:linkingpal/pages/profile/edit_profile.dart';
import 'package:linkingpal/pages/setting/matches_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _pageController = PageController();

  final _retrieveController = Get.put(RetrieveController());
  final _userController = Get.put(UserController());
  final _isInitialized = false.obs;
  var isPlaying = false.obs;
  final Rx<VideoPlayerController?> _controller =
      Rx<VideoPlayerController?>(null);

  void _onVideoPlayerChanged() {
    if (_controller.value!.value.position ==
        _controller.value!.value.duration) {
      isPlaying.value = false;
    } else {
      // Update play/pause state
      isPlaying.value = _controller.value!.value.isPlaying;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.value = VideoPlayerController.networkUrl(
      Uri.parse(
        _retrieveController.userModel.value?.video ?? "",
      ),
    );
    _controller.value!.initialize().then((_) {
      _isInitialized.value = true;
      isPlaying.value = true;
      _controller.value!.addListener(_onVideoPlayerChanged);
    });
  }

  @override
  void dispose() {
    _controller.value!.dispose();
    _controller.value!.removeListener(_onVideoPlayerChanged);
    super.dispose();
  }

  void playPause() {
    if (_controller.value!.value.isPlaying) {
      _controller.value!.pause();
    } else {
      _controller.value!.play();
    }
    isPlaying.value = _controller.value!.value.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView(
                        controller: _pageController,
                        children: [
                          Obx(
                            () => ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: _retrieveController
                                          .userModel.value?.image ??
                                      "",
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey.shade50,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                )),
                          ),
                          Obx(() {
                            if (_isInitialized.value) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: VideoPlayer(_controller.value!),
                                  ),
                                  GestureDetector(
                                    onTap: playPause,
                                    child: Icon(
                                      isPlaying.value
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      size: 50,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }),
                        ],
                      ),
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOut);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.arrow_back_ios_new),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {

                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                );
                                _controller.value!.play();
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Obx(
                      () => Text(
                        "${_retrieveController.userModel.value?.name ?? ""},  ${_userController.calculateAge(_retrieveController.userModel.value?.dob ?? "")}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.location_on,
                //       color: Colors.blue,
                //       size: 20,
                //     ),
                //     Text(
                //       _userController
                //           .getCityNameFromCoordiantion(
                //               latitude: _retrieveController
                //                       .userModel.value?.latitude ??
                //                   "0.0",
                //               longitude: _retrieveController
                //                       .userModel.value?.longitude ??
                //                   "0.0")
                //           .toString(),
                //       style: const TextStyle(
                //         fontSize: 13,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 15),
                const Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    _retrieveController.userModel.value?.bio ?? "",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Contacts",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Text(
                        "+${_retrieveController.userModel.value?.mobileNumber.toString() ?? ""}",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Text(
                        _retrieveController.userModel.value?.email ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Interested In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.interest, arguments: {
                        "action": () {
                          Get.offAllNamed(AppRoutes.dashboard);
                        }
                      });
                    },
                    child: Container(
                      height: 35,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _retrieveController.userModel.value?.mood[0],
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                // const Text(
                //   "Activity/Mood",
                //   style: TextStyle(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                // ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const EditProfileScreen());
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  "Subscription Type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Premium",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "My Posts",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const AllPostScreen());
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const MatchesScreen());
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF496C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "My Matches",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
