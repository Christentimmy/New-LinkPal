import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  final PageController _pageController = PageController();

  final RxList _introPages = [
    [
      "assets/images/net.jpg",
      "Netflix & Chill? More like Netflix & Connect! Find a buddy to binge with!",
      "Netflix and Chill",
    ],
    [
      "assets/images/massage.jpg",
      "Massage Monday (or any day)! 🤩 We've got a friend for you to relax with",
      "Massage",
    ],
    [
      "assets/images/dinner.jpg",
      "Dinner for one? No way! Link up with a pal and make mealtime a social delight",
      "Dinner",
    ],
  ].obs;

  final RxInt _currentPage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: Get.height / 1.8,
                    decoration: const BoxDecoration(
                      color: AppColor.themeColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(200),
                      ),
                    ),
                  ),
                  Obx(
                    () => PageView.builder(
                      itemCount: _introPages.length,
                      physics: const ScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (value) {
                        _currentPage.value = value;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 40,
                                  right: 40,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    _introPages[index][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Text(
                              _introPages[index][2],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColor.themeColor,
                                fontSize: 25.0,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: Text(
                                _introPages[index][1],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  color: AppColor.textColor,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Obx(
              () => Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _introPages.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 5.0,
                      radius: 10.0,
                      dotWidth: 12.0,
                      dotHeight: 6.0,
                      strokeWidth: 6.5,
                      activeDotColor: AppColor.themeColor,
                      dotColor: AppColor.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                if (_currentPage.value == 2) {
                  Get.offAllNamed(AppRoutes.signin);
                }
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                );
              },
              child: Container(
                height: 45,
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: AppColor.lightgrey,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
