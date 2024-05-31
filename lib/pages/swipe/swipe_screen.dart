import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:linkingpal/pages/message/message_screen.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:lottie/lottie.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  @override
  void initState() {
    super.initState();
    _userController.getNearByUSer(
      age: "80",
      mood: _retrieveController.userModel.value!.mood[0],
      distance: "80",
      interest: "all",
    );
  }

  final _retrieveController = Get.put(RetrieveController());
  final _userController = Get.put(UserController());

  CardSwiperController controller = CardSwiperController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              widget1(
                controller: _retrieveController,
                onTap1: () {
                  Get.to(() => const MessageScreen());
                },
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CustomBottomSheet(
                        controller: _userController,
                      );
                    },
                  );
                },
              ),
              Obx(() {
                return _userController.peopleNearBy.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Lottie.network(
                            "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json",
                          ),
                        ),
                      )
                    : Expanded(
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: _userController.peopleNearBy.length,
                          allowedSwipeDirection:
                              const AllowedSwipeDirection.symmetric(
                                  horizontal: true),
                          cardBuilder: (context,
                              index,
                              horizontalOffsetPercentage,
                              verticalOffsetPercentage) {
                            final UserModel userModel =
                                _userController.peopleNearBy[index];
                            return SwipeCard(
                              retrieveController: _retrieveController,
                              userController: _userController,
                              ontap: () async {
                               await  _retrieveController
                                    .getSpecificUserId(userModel.id);
                                Get.toNamed(
                                  AppRoutes.swipedUserCardProfile,
                                  arguments: {
                                    "userId": userModel.id,
                                  },
                                );
                              },
                              userModel: userModel,
                            );
                          },
                        ),
                      );
              }),
              const SizedBox(height: 20),
              Obx(() {
                return _userController.peopleNearBy.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.swipe(CardSwiperDirection.left);
                              },
                              child: Container(
                                  height: 60,
                                  width: 60,
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
                                  alignment: Alignment.center,
                                  child:
                                      const Icon(FontAwesomeIcons.x, size: 20)),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                controller.swipe(CardSwiperDirection.right);
                              },
                              child: Container(
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
              const SizedBox(height: 40),
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
                imageUrl: controller.userModel.value?.image ??
                    "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D",
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello!",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
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
          retrieveController.userModel.value?.latitude ?? 0.00,
          retrieveController.userModel.value?.longitude ?? 0.00,
          userModel.latitude,
          userModel.longitude,
        )
        .toStringAsFixed(2);
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 15,
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
              height: 150,
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
  CustomBottomSheet({super.key, required this.controller});

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
    "Men",
    "Women",
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
              const Text(
                "Filter",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FlutterSlider(
            values: const [0, 0],
            rangeSlider: false,
            max: 500,
            min: 0,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              _distanceValue.value = lowerValue - upperValue;
            },
          ),
          Obx(
            () => Text(
              "Age: ${_minAge.round()} - ${_maxAge.round()}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
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
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Interested In",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
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
                            ? Colors.black
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _genders[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _genderIndex.value == index
                              ? Colors.white
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Activity/Mood",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
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
                            ? Colors.black
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _allIntetrest[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _interest.value == index
                              ? Colors.white
                              : Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          CustomButton(
            ontap: () {
              controller.getNearByUSer(
                age: _maxAge.value.toString(),
                mood: selectedMood,
                distance: _distanceValue.value.toString(),
                interest: selectedInterest,
              );
              Get.back();
            },
            child: const Text(
              "Apply Now",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
