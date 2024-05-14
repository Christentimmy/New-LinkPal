import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:linkingpal/pages/auth/location_access_screen.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkingpal/theme/app_routes.dart';

class InterestScreen extends StatelessWidget {
  InterestScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  final List _allIntetrest = [
    [FontAwesomeIcons.planeDeparture, "Avation"],
    [FontAwesomeIcons.paintbrush, "Art"],
    [FontAwesomeIcons.earthAmericas, "Crypto"],
    [FontAwesomeIcons.breadSlice, "Baking"],
    [FontAwesomeIcons.canadianMapleLeaf, "Botany"],
    [FontAwesomeIcons.car, "Cars"],
    [FontAwesomeIcons.houseUser, "Real Estate"],
    [FontAwesomeIcons.microchip, "Technology"],
    [FontAwesomeIcons.dog, "Dogs"],
    [FontAwesomeIcons.dove, "Birds"],
    [FontAwesomeIcons.notesMedical, "Health care"],
    [FontAwesomeIcons.bookAtlas, "Geography"],
    [FontAwesomeIcons.buildingColumns, "Finance"],
    [FontAwesomeIcons.cat, "Cats"],
    [FontAwesomeIcons.flagCheckered, "LGBTQ"],
    [FontAwesomeIcons.brain, "Mental Health"],
    [FontAwesomeIcons.laptop, "Programming"],
    [FontAwesomeIcons.film, "Cinema"],
    [FontAwesomeIcons.baseball, "Sports"],
    [FontAwesomeIcons.compass, "Travel"],
    [FontAwesomeIcons.gamepad, "Gaming"],
    [FontAwesomeIcons.camera, "Photography"],
    [FontAwesomeIcons.palette, "Design"],
    [FontAwesomeIcons.planeArrival, "UFO"],
    [FontAwesomeIcons.music, "Music"],
  ];

  final RxInt _selectedIndex = (-1).obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.locationAccess);
          },
          child: const Icon(Icons.check),
        ),
        appBar: AppBar(
          title: const Text("Activity/Mood"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                CustomTextField(
                  hintText: "Search",
                  controller: _searchController,
                  isObscureText: false,
                  icon: Icons.search,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            _allIntetrest.length,
                            (index) => GestureDetector(
                              onTap: () {
                                _selectedIndex.value = index;
                              },
                              child: Obx(
                                () => Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      _allIntetrest[index][0],
                                      size: 17,
                                    ),
                                  ),
                                  label: Text(_allIntetrest[index][1]),
                                  side: BorderSide(
                                    color: _selectedIndex.value == index
                                        ? Colors.deepOrangeAccent
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
