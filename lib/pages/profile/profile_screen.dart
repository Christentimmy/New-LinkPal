import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/pages/setting/matches_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _pageController = PageController();
  final _postController = Get.put(PostController());
  final _retrieveController = Get.find<RetrieveController>();
  final _locationController = Get.put(LocationController());
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
      isPlaying.value = _controller.value!.value.isPlaying;
    }
  }

  bool _isImage(String file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = file.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
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
                                    child: AspectRatio(
                                      aspectRatio:
                                          _controller.value!.value.aspectRatio,
                                      child: VideoPlayer(
                                        _controller.value!,
                                      ),
                                    ),
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
                                  curve: Curves.easeInOut,
                                );
                                _controller.value!.pause();
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
                Obx(
                  () => FutureBuilder(
                    future: _locationController.displayLocation(
                      latitude: _retrieveController.userModel.value?.latitude,
                      longitude: _retrieveController.userModel.value?.longitude,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Location not available');
                      } else {
                        return Text(snapshot.data!);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    _retrieveController.userModel.value?.gender.toUpperCase() ??
                        "",
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                  "Acitivity/Mood",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.interest);
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
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.editProfile);
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Get.toNamed(AppRoutes.allpost);
                        await _postController.getAllUserPost();
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
                Obx(
                  () {
                    if (_postController.allUserPost.isEmpty) {
                      return Center(
                        child: Lottie.network(
                          "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _postController.allUserPost.length >= 2
                                ? 2
                                : _postController.allUserPost.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final postData =
                                  _postController.allUserPost[index];
                              final imageFiles =
                                  postData.files.where(_isImage).toList();

                              return Row(
                                children: imageFiles.map((file) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: file,
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error),
                                        ),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: Loader(
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                      );
                    }
                  },
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
