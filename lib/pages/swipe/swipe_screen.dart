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
                      return const CustomBottomSheet();
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
                        child: const Icon(FontAwesomeIcons.x, size: 20)
                      ),
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
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      Text(
                        "29Km",
                        style: TextStyle(
                          fontSize: 16,
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

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  RangeValues values = const RangeValues(0.1, 100.0);
  RangeValues values1 = const RangeValues(0.1, 100.0);

  double ageRange = 0.0;
  double distance = 0.0;

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

  @override
  Widget build(BuildContext context) {
    RangeLabels labels = RangeLabels(
      values.start.toString(),
      values.end.toString(),
    );
    RangeLabels labels1 = RangeLabels(
      values.start.toString(),
      values.end.toString(),
    );
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
                  fontSize: 25,
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
          Text(
            "Distance $distance",
            style: const TextStyle(fontSize: 18),
          ),
          RangeSlider(
            values: values,
            labels: labels,
            divisions: 10,
            min: 0.0,
            max: 100.0,
            onChanged: (newValue) {
              if (newValue.end >= newValue.start) {
                setState(() {
                  values = newValue;
                  distance = newValue.end - newValue.start;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            "Age: $ageRange",
            style: const TextStyle(fontSize: 18),
          ),
          RangeSlider(
            values: values1,
            labels: labels1,
            divisions: 10,
            min: 0.0,
            max: 100.0,
            onChanged: (newValue) {
              if (newValue.end >= newValue.start) {
                setState(() {
                  values1 = newValue;
                  ageRange = newValue.end - newValue.start;
                });
              }
            },
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Interested In",
              style: TextStyle(
                fontSize: 20,
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
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  margin: const EdgeInsets.only(left: 9, top: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    _allIntetrest[index][1],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.deepPurple,
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
        ],
      ),
    );
  }
}
