import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class InterestScreen extends StatelessWidget {
  InterestScreen({super.key});

  final TextEditingController _searchController = TextEditingController();
  final _userController = Get.put(UserController());

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
  final RxString _choosenValue = "".obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_choosenValue.value.isNotEmpty) {
              _userController.uploadInterest(
                interests: [
                  _choosenValue.value,
                ],
              );
            }else{
              CustomSnackbar.show("Error", "Pick one interest");
            }
          },
          child: const Icon(Icons.check),
        ),
        appBar: AppBar(
          title: const Text("Activity/Mood"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Obx(
          () => _userController.isloading.value
              ? const LinearProgressIndicator()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
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
                                        _choosenValue.value =
                                            _allIntetrest[index][1];
                                        print(_choosenValue.value);
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
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
