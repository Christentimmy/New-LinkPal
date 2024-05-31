import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class InterestScreen extends StatelessWidget {
  final VoidCallback onClickWhatNext;
  InterestScreen({super.key, required this.onClickWhatNext});

  final TextEditingController _searchController = TextEditingController();
  final _userController = Get.put(UserController());

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
                onClickWhatNext: onClickWhatNext,
              );
            } else {
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
