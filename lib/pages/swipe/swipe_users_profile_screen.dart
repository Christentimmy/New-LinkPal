import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/video_play_widget.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class SwipeUsersProfileScreen extends StatefulWidget {
  final String userId;

  const SwipeUsersProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SwipeUsersProfileScreen> createState() =>
      _SwipeUsersProfileScreenState();
}

class _SwipeUsersProfileScreenState extends State<SwipeUsersProfileScreen> {
  final _retrieveController = Get.put(RetrieveController());
  final _locationController = Get.put(LocationController());
  final PageController _pageController = PageController();
  // final _swipeController = Get.put(SwipeController());

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  void retrieve() async {
    await _retrieveController.getSpecificUserId(widget.userId);
    _retrieveController.externalUserModel.refresh();
  }

  @override
  void dispose() {
    _retrieveController.externalUserModel.value = null;
    _retrieveController.allPostFiles.value = [];
    super.dispose();
  }

  bool _isImage(String file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = file.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: Theme.of(context).textTheme.bodyLarge,
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
                            () => _retrieveController
                                        .externalUserModel.value?.image ==
                                    null
                                ? const Center(
                                    child: Loader(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: _retrieveController
                                              .externalUserModel.value?.image ??
                                          "",
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: Loader(
                                          color: Colors.deepOrangeAccent,
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
                              videoUrl: _retrieveController
                                      .externalUserModel.value?.video ??
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
                // displayuserProfileAndVideo(pageController: _pageController, widget: widget),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        _retrieveController.externalUserModel.value?.name ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 16,
                    ),
                    Obx(
                      () {
                        final latitude = _retrieveController
                            .externalUserModel.value?.latitude;
                        final longitude = _retrieveController
                            .externalUserModel.value?.longitude;

                        if (latitude == null || longitude == null) {
                          return Text('Location not available',
                              style: Theme.of(context).textTheme.bodyMedium);
                        }

                        return FutureBuilder<String>(
                          future: _locationController.displayLocation(
                              latitude: latitude, longitude: longitude),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('Location not available');
                            } else {
                              return Text(
                                snapshot.data!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Bio",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 5),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _retrieveController.externalUserModel.value?.bio ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Activity/Mood",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Obx(
                  () {
                    final mood =
                        _retrieveController.externalUserModel.value?.mood;
                    return Container(
                      constraints: const BoxConstraints(
                        minHeight: 35,
                      ),
                      margin: const EdgeInsets.only(left: 9, top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: mood != null && mood.isNotEmpty
                          ? Text(
                              mood[0],
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Text(
                              "Null",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "Post",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.viewAllPostedPics, arguments: {
                            "list": _retrieveController.allPostFiles
                                .where((p) => _isImage(p))
                                .toList()
                                .obs,
                          });
                        },
                        child: const Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Obx(
                  () {
                    final allFiles = _retrieveController.allPostFiles;
                    final imageFiles =
                        allFiles.where((file) => _isImage(file)).toList();

                    // Limit the number of images to a maximum of 3
                    final displayFiles = imageFiles.take(3).toList();

                    return allFiles.isEmpty
                        ? Center(
                            child: Lottie.network(
                              "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: displayFiles.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio: 0.5,
                            ),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: displayFiles[index],
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                          );
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
