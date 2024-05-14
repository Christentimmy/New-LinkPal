import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/pages/profile/all_post_screen.dart';
import 'package:linkingpal/pages/profile/edit_profile.dart';
import 'package:linkingpal/pages/setting/matches_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                      PageView.builder(
                        itemCount: 5,
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://images.unsplash.com/photo-1516637787777-d175e2e95b65?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjN8fGZlbWFsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D",
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
                              ));
                        },
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
                const Row(
                  children: [
                    Text(
                      "Timothy Charlie, 35",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    Text(
                      "New York, USA",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "Loving and caring guy",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Contacts",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "+1-432-767-4543",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "samalfred34@gmail.com",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Interested In",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
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
                const Text(
                  "Activity/Mood",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
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
                    "Sport",
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() =>  EditProfileScreen());
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
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  "Subscription Type",
                  style: TextStyle(
                    fontSize: 20,
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
                        fontSize: 20,
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
                        fontSize: 18,
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
