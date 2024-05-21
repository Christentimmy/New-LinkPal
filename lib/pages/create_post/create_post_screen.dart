import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/pages/dashboard_screen.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  final TextEditingController _textController = TextEditingController();
  final _postController = Get.put(PostController());
  final RxList<XFile> _imagesList = <XFile>[].obs;

  final Rx<XFile?> _file = Rx<XFile?>(null);

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _file.value = imagePicked;
      _imagesList.add(imagePicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => DashBoardScreen());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Create Post",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImageForUser();
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade300,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => Expanded(
                        child: ListView.builder(
                          itemCount: _imagesList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.deepOrangeAccent,
                                ),
                                image: DecorationImage(
                                  image: FileImage(
                                    File(_imagesList[index].path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade300,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: "Write here...",
                controller: _textController,
                isObscureText: false,
                icon: Icons.text_fields_rounded,
                action: TextInputAction.newline,
                maxline: 4,
              ),
              const SizedBox(height: 30),
              Obx(
                () => CustomButton(
                  ontap: () {
                    if (_textController.text.isNotEmpty &&
                        _imagesList.isNotEmpty) {
                      _postController.createPost(
                        text: _textController.text,
                        pickedFiles: _imagesList,
                      );
                      FocusManager.instance.primaryFocus?.unfocus();
                      _textController.text = "";
                    } else {
                      CustomSnackbar.show("Error", "Fill the text and fill");
                    }
                  },
                  child: _postController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Post Now",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
