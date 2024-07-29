import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/video_play_widget.dart';
import 'package:lottie/lottie.dart';

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
  var isPlaying = false.obs;

  bool _isImage(String file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = file.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.bodyMedium,
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
                          Obx(
                            () => VideoNetworkPlayWidget(
                              videoUrl:
                                  _retrieveController.userModel.value?.video ??
                                      "",
                            ),
                          ),
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
                        "${_retrieveController.userModel.value?.name ?? ""},  ${_userController.calculateAge(
                          _retrieveController.userModel.value?.dob ??
                              DateTime.now().toString(),
                        )}",
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
                      latitude:
                          _retrieveController.userModel.value?.latitude ?? 0.0,
                      longitude:
                          _retrieveController.userModel.value?.longitude ?? 0.0,
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
                Obx(() {
                  if (_retrieveController.userModel.value?.mood == null ||
                      _retrieveController.userModel.value!.mood.isEmpty) {
                    return Container(
                      height: 40,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "Empty",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.interest);
                      },
                      child: Container(
                        height: 40,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          _retrieveController.userModel.value!.mood.isEmpty
                              ? "Null"
                              : _retrieveController.userModel.value!.mood[0],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.editProfile);
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                    final allFiles = _postController.allUserPost;
                    if(allFiles.isEmpty || allFiles == null){
                      return Center(
                        child: Lottie.asset(
                          "assets/images/empty.json",
                        ),
                      );
                    }
                    List displayFiles = [];
                    for (var element in allFiles) {
                      final imageList =
                          element.files.where((e) => _isImage(e)).toList();
                      displayFiles.addAll(imageList);
                    }
                    final images = displayFiles.take(2).toList();

                    if (images.isEmpty) {
                      return Center(
                        child: Lottie.asset(
                          "assets/images/empty.json",
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: images.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: images[index],
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
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.matches);
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
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.matchesRequest);
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF496C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Matches Request",
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
