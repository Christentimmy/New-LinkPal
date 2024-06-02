import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/widgets/loading_widget.dart';

// ignore: must_be_immutable
class SelectGenderScreen extends StatelessWidget {

  SelectGenderScreen({super.key});
  final RxBool _isloading = false.obs;

  final RxList _genderList = [
    [
      "Male",
      Colors.blueAccent.shade400,
      Icons.male,
      false,
    ],
    [
      "Female",
      Colors.pinkAccent.shade400,
      Icons.female,
      false,
    ],
    [
      "Others",
      Colors.deepPurpleAccent,
      Icons.flag,
      false,
    ],
  ].obs;

  void onTap(int index) async {
    for (var i = 0; i < _genderList.length; i++) {
      _genderList[i][3] = false;
    }
    _genderList[index][3] = true;
    _genderList.refresh();
  }

  final _userController = Get.put(UserController());
  RxString selectedGender = "".obs;
  void updateGender() async {
    _isloading.value = true;
    await _userController.updateUserDetails(
      gender: selectedGender.value.toLowerCase(),
      isSignUp: false,
    );
    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Select Gender",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Obx(
          () => SizedBox(
            height: currentHeight / 1.80,
            child: ListView.builder(
              itemCount: _genderList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      onTap(index);
                      selectedGender.value = _genderList[index][0];
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _genderList[index][3]
                                ? _genderList[index][1]
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _genderList[index][2],
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _genderList[index][0],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomButton(
              ontap: () {},
              child: _isloading.value
                  ? const Loader()
                  : const Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
