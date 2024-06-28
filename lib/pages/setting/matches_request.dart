import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/location_controller.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/models/user_model.dart';
import 'package:lottie/lottie.dart';

class MatchesRequestScreen extends StatefulWidget {
  const MatchesRequestScreen({super.key});

  @override
  State<MatchesRequestScreen> createState() => _MatchesRequestScreenState();
}

class _MatchesRequestScreenState extends State<MatchesRequestScreen> {
  final _userController = Get.put(UserController());
  final _locationController = Get.put(LocationController());
  String animationLink =
      "https://lottie.host/bc7f161c-50b2-43c8-b730-99e81bf1a548/7FkZl8ywCK.json";

  @override
  void initState() {
    _userController.matchesRequestFromOthers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Matches Request",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Obx(
                () => _userController.matchesRequest.isEmpty
                    ? Center(
                        child: Lottie.network(animationLink),
                      )
                    : Expanded(
                        child: GridView.builder(
                          itemCount: _userController.matchesRequest.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 5.0,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final UserModel users =
                                _userController.matchesRequest[index];
                            return MatchesRequestCard(
                              users: users,
                              locationController: _locationController,
                              userController: _userController,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchesRequestCard extends StatelessWidget {
  const MatchesRequestCard({
    super.key,
    required this.users,
    required LocationController locationController,
    required UserController userController,
  })  : _locationController = locationController,
        _userController = userController;

  final UserModel users;
  final LocationController _locationController;
  final UserController _userController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            users.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),

        // Dark gradient overlay at bottom
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  stops: const [0.0, 0.9],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    users.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 5),
                      FutureBuilder(
                        future: _locationController.displayLocation(
                          latitude: users.latitude ?? 0.0,
                          longitude: users.longitude ?? 0.0,
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
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              _userController.acceptMatchRequest(senderId: users.id);
            },
            child: Container(
              height: 35,
              alignment: Alignment.center,
              color: Colors.deepPurpleAccent,
              child: _userController.isFriendAccept.value
                  ? const Icon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                    )
                  : const Text(
                      "Accept",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
