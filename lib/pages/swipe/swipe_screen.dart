import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/pages/message/message_screen.dart';
import 'package:linkingpal/pages/swipe/users_profile_screen.dart';
import 'package:linkingpal/res/common_button.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => SwipeScreenState();
}

class SwipeScreenState extends State<SwipeScreen> {
  final _retrieveController = Get.put(RetrieveController());

  List<String> cards = [
    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZmVtYWxlJTIwcGljdHVyZXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1496440737103-cd596325d314?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZmVtYWxlJTIwcGljdHVyZXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D",
  ];

  CardSwiperController controller = CardSwiperController();
  RangeValues values = const RangeValues(10, 90);

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
                      return CustomBottomSheet();
                    },
                  );
                },
              ),
              Expanded(
                child: CardSwiper(
                  controller: controller,
                  allowedSwipeDirection:
                      const AllowedSwipeDirection.symmetric(horizontal: true),
                  cardBuilder: (context, index, horizontalOffsetPercentage,
                      verticalOffsetPercentage) {
                    return SwipeCard(
                      ontap: () {
                        Get.to(() => const UsersProfileScreen());
                      },
                      cards: cards,
                      index: index,
                    );
                  },
                  cardsCount: cards.length,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
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
                          child: const Icon(FontAwesomeIcons.x, size: 20)),
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
              ),
              const SizedBox(height: 30),
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
  const SwipeCard({
    super.key,
    required this.cards,
    required this.index,
    required this.ontap,
  });

  final List<String> cards;
  final int index;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
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
                imageUrl: cards[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "Michelle, 26",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.verified,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.house,
                        size: 16,
                        color: Colors.white,
                      ),
                      Text(
                        "Lives In Playa Del Carmen",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white,
                      ),
                      Text(
                        "29Km away",
                        style: TextStyle(
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

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({super.key});

  final List _allIntetrest = [
    [FontAwesomeIcons.music, "Clubbing"],
    [FontAwesomeIcons.breadSlice, "Having breakfast"],
    [FontAwesomeIcons.utensils, "Going out for lunch"],
    [FontAwesomeIcons.wineGlassEmpty, "Having dinner together"],
    [FontAwesomeIcons.martiniGlassCitrus, "Going for drinks"],
    [FontAwesomeIcons.dumbbell, "Working out at the gym"],
    [FontAwesomeIcons.handsPraying, "Attending church/mosque"],
    [FontAwesomeIcons.planeDeparture, "Going on holiday trips"],
    [FontAwesomeIcons.spa, "Getting spa treatments"],
    [FontAwesomeIcons.bagShopping, "Shopping together"],
    [FontAwesomeIcons.tv, "Watching Netflix and chilling"],
    [FontAwesomeIcons.calendarDays, "Being event or party partners"],
    [FontAwesomeIcons.utensils, "Cooking and chilling"],
    [FontAwesomeIcons.smoking, "Smoking together"],
    [FontAwesomeIcons.book, "Studying together"],
    [FontAwesomeIcons.basketball, "Playing sports"],
    [FontAwesomeIcons.music, "Going to concerts"],
    [FontAwesomeIcons.personHiking, "Hiking or outdoor activities"],
    [FontAwesomeIcons.gamepad, "Playing board games or video games"],
    [FontAwesomeIcons.compass, "Traveling buddy"],
  ];

  final List<String> _genders = [
    "Man",
    "Woman",
    "Trans",
    "Gay",
  ];

  final RxDouble _distanceValue = 0.0.obs;
  final RxDouble _minAge = 18.0.obs;
  final RxDouble _maxAge = 30.0.obs;
  final RxInt _ageIndex = (-1).obs;
  final RxInt _currentlyTapped2 = (-1).obs;

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
                    _ageIndex.value = index;
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
                        color: _ageIndex.value == index
                            ? Colors.black
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _genders[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: _ageIndex.value == index
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
                    _currentlyTapped2.value = index;
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
                        color: _currentlyTapped2.value == index
                            ? Colors.black
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        _allIntetrest[index][1],
                        style: TextStyle(
                          fontSize: 12,
                          color: _currentlyTapped2.value == index
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
