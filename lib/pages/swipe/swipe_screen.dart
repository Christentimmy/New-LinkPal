import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/swipe_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/pages/message/message_screen.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  final _retrieveController = Get.find<RetrieveController>();
  final _userController = Get.put(UserController());
  final AppinioSwiperController _controller = AppinioSwiperController();
  final _swipeController = Get.put(SwipeController());

  final RxBool _isSwipeRight = false.obs;
  final RxBool _isSwipeLeft = false.obs;

  @override
  void initState() {
    getCards();
    super.initState();
  }

  void getCards() async {
    await _userController.getNearByUSer(
      age: "90",
      mood: _retrieveController.userModel.value?.mood[0].toString() ?? "",
      distance: "800",
      interest: "all",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              widget1(
                controller: _retrieveController,
                onTap1: () {
                  Get.to(() => MessageScreen());
                },
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CustomBottomSheet(
                        controller: _userController,
                        retrieveController: _retrieveController,
                      );
                    },
                  );
                },
              ),
              Obx(() {
                return _userController.peopleNearBy.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height / 1.55,
                        child: Center(
                          child: Column(
                            children: [
                              Lottie.asset("assets/images/empty.json"),
                              const Text("Empty? filter your cards above"),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: AppinioSwiper(
                          loop: true,
                          controller: _controller,
                          onSwipeBegin: (previousIndex, targetIndex, activity) {
                            final UserModel userModel =
                                _userController.peopleNearBy[previousIndex];
                            final String receiverId = userModel.id;
                            if (activity.direction == AxisDirection.right) {
                              _isSwipeRight.value = true;
                              _swipeController.swipe(receiverId: receiverId);
                            } else {
                              _isSwipeLeft.value = true;
                            }
                            Future.delayed(const Duration(seconds: 1), () {
                              _isSwipeLeft.value = false;
                              _isSwipeRight.value = false;
                            });
                          },
                          swipeOptions:
                              const SwipeOptions.symmetric(horizontal: true),
                          cardBuilder: (context, index) {
                            final UserModel userModel =
                                _userController.peopleNearBy[index];

                            // return AltSwipeCard(
                            //   userModel: userModel,
                            //   ontap: () {},
                            //   retrieveController: _retrieveController,
                            //   userController: _userController,
                            //   appinioSwiperController: _controller,
                            // );
                            return SwipeCard(
                              retrieveController: _retrieveController,
                              userController: _userController,
                              ontap: () {
                                Get.toNamed(
                                  AppRoutes.swipedUserCardProfile,
                                  arguments: {
                                    "userId": userModel.id,
                                    "isSent": userModel.isMatchRequestSent,
                                  },
                                );
                              },
                              userModel: userModel,
                            );
                          },
                          cardCount: _userController.peopleNearBy.length,
                        ),
                      );
              }),
              const SizedBox(height: 15),
              // const Spacer(),
              Obx(() {
                return _userController.peopleNearBy.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _controller.swipeLeft();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: _isSwipeLeft.value ? 70 : 60,
                                width: _isSwipeLeft.value ? 70 : 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(2, 2),
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                      ),
                                    ]),
                                alignment: Alignment.center,
                                child: Icon(
                                  FontAwesomeIcons.x,
                                  size: 20,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _controller.swipeRight();
                              },
                              child: AnimatedContainer(
                                height: _isSwipeRight.value ? 70 : 60,
                                width: _isSwipeRight.value ? 70 : 60,
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(2, 2),
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Obx widget1({
    required VoidCallback onTap,
    required VoidCallback onTap1,
    required RetrieveController controller,
  }) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                height: 44,
                width: 45,
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
                imageUrl: controller.userModel.value?.image ?? "",
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello!",
                ),
                Text(
                  controller.userModel.value?.name ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: onTap1,
              child: Container(
                height: 45,
                width: 45,
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
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(10),
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
                child: Image.asset(
                  "assets/images/filter-icon.png",
                  color: Colors.blue,
                ),
                // child: const Icon(
                //   FontAwesomeIcons.filter,
                //   color: Colors.blue,
                //   size: 15,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AltSwipeCard extends StatelessWidget {
  AltSwipeCard({
    super.key,
    required this.userModel,
    required this.ontap,
    required this.retrieveController,
    required this.userController,
    required this.appinioSwiperController,
  });

  final UserModel userModel;
  final VoidCallback ontap;
  final RetrieveController retrieveController;
  final UserController userController;
  final _locationController = Get.put(LocationController());
  final AppinioSwiperController appinioSwiperController;

  @override
  Widget build(BuildContext context) {
    String distanceApart = userController
        .calculateDistance(
          retrieveController.userModel.value!.latitude,
          retrieveController.userModel.value!.longitude,
          userModel.latitude,
          userModel.longitude,
        )
        .toStringAsFixed(2);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CachedNetworkImage(
              imageUrl: userModel.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Container(
                  color: Colors.black,
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              },
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                begin: Alignment.center,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        userModel.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.house,
                        size: 16,
                        color: Colors.white,
                      ),
                      FutureBuilder(
                        future: _locationController.displayLocation(
                          latitude: userModel.latitude,
                          longitude: userModel.longitude,
                        ),
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
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white,
                      ),
                      Text(
                        "$distanceApart km",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    appinioSwiperController.swipeLeft();
                  },
                  child: Container(
                      height: 55,
                      width: 150,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(66, 255, 82, 82),
                        border: Border.all(
                          width: 2,
                          color: Colors.red,
                        ),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.x,
                        color: Colors.red,
                        size: 15,
                      )),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    appinioSwiperController.swipeRight();
                  },
                  child: Container(
                    height: 55,
                    width: 150,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(68, 104, 58, 183),
                      border: Border.all(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeCard extends StatelessWidget {
  SwipeCard({
    super.key,
    required this.ontap,
    required this.userModel,
    required this.retrieveController,
    required this.userController,
  });

  final UserModel userModel;
  final VoidCallback ontap;
  final RetrieveController retrieveController;
  final UserController userController;
  final _locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    String distanceApart = userController
        .calculateDistance(
          retrieveController.userModel.value!.latitude,
          retrieveController.userModel.value!.longitude,
          userModel.latitude,
          userModel.longitude,
        )
        .toStringAsFixed(2);

    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: userModel.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.black,
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Container(
              height: Get.height / 3.635,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        userModel.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.house,
                        size: 16,
                        color: Colors.white,
                      ),
                      FutureBuilder(
                        future: _locationController.displayLocation(
                          latitude: userModel.latitude,
                          longitude: userModel.longitude,
                        ),
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
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white,
                      ),
                      Text(
                        "$distanceApart km",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomBottomSheet extends StatelessWidget {
  final UserController controller;
  final RetrieveController retrieveController;
  CustomBottomSheet({
    super.key,
    required this.controller,
    required this.retrieveController,
  });

  final RxBool _isloading = false.obs;

  final List _allIntetrest = [
    "Game",
    "Clubbing",
    "Having breakfast",
    "Going out for lunch",
    "Having dinner together",
    "Going for drinks",
    "Working out at the gym",
    "Attending church/mosque",
    "Going on holiday trips",
    "Getting spa treatments",
    "Shopping together",
    "Watching Netflix and chilling",
    "Being event or party partners",
    "Cooking and chilling",
    "Smoking together",
    "Studying together",
    "Playing sports",
    "Going to concerts",
    "Hiking or outdoor activities",
    "Playing board games or video games",
    "Traveling buddy",
  ];

  final List<String> _genders = [
    "Male",
    "Female",
    "Others",
    "All",
  ];

  final RxDouble _distanceValue = 0.0.obs;
  final RxDouble _minAge = 18.0.obs;
  final RxDouble _maxAge = 30.0.obs;
  final RxInt _genderIndex = (-1).obs;
  final RxInt _interest = (-1).obs;

  String selectedInterest = "";
  String selectedMood = "";

  void filterCards() async {
    _isloading.value = true;
    controller.peopleNearBy.clear();
    await controller.getNearByUSer(
      age: _maxAge.value.toString(),
      mood: selectedMood,
      distance: _distanceValue.value.toString(),
      interest: selectedInterest,
    );
    _isloading.value = false;
  }

  void clearFilter(BuildContext context) async {
    Navigator.pop(context);
    await controller.getNearByUSer(
      age: "80",
      mood: retrieveController.userModel.value!.mood[0].toString(),
      distance: "10",
      interest: retrieveController.userModel.value!.gender,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Filter",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          Obx(
            () => Text(
              "Distance: $_distanceValue Km",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          FlutterSlider(
            values: const [0, 0],
            rangeSlider: false,
            max: 800,
            min: 0,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              _distanceValue.value = lowerValue - upperValue;
            },
          ),
          Obx(
            () => Text(
              "Age: ${_minAge.round()} - ${_maxAge.round()}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          FlutterSlider(
            values: [_minAge.value, _maxAge.value],
            rangeSlider: true,
            max: 80,
            rightHandler: FlutterSliderHandler(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            handler: FlutterSliderHandler(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
            ),
            min: _minAge.value,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              _minAge.value = lowerValue;
              _maxAge.value = upperValue;
            },
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Interested In",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              itemCount: _genders.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _genderIndex.value = index;
                    selectedInterest = _genders[index];
                  },
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(left: 9, top: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _genderIndex.value == index
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _genders[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _genderIndex.value == index
                              ? Colors.deepPurple
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Activity/Mood",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              itemCount: _allIntetrest.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _interest.value = index;
                    selectedMood = _allIntetrest[index];
                  },
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(left: 9, top: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _interest.value == index
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _allIntetrest[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _interest.value == index
                              ? Colors.deepPurpleAccent
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    clearFilter(context);
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Clear Filter",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    filterCards();
                    Get.back();
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: _isloading.value
                        ? const Loader()
                        : const Text(
                            "Apply Now",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
