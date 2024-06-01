import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:video_player/video_player.dart';

class IntroductionVideoScreen extends StatelessWidget {
  final VoidCallback onClickToProceed;
  IntroductionVideoScreen({
    super.key,
    required this.onClickToProceed,
  });

  final Rx<File?> _videoFile = Rx<File?>(null);
  final _userController = Get.put(UserController());

  final Rx<VideoPlayerController?> _videoPlayeController =
      Rx<VideoPlayerController?>(null);

  void pickUserVideo() async {
    File? videoSelected = await selectVideo();
    if (videoSelected != null) {
      _videoFile.value = videoSelected;
      _videoPlayeController.value =
          VideoPlayerController.file(_videoFile.value!)
            ..initialize().then((_) {
              _videoPlayeController.value!.play();
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Introduction Video"),
        centerTitle: true,
      ),
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () {
                return _videoFile.value == null
                    ? const Icon(
                        Icons.cloud_upload,
                        size: 120,
                      )
                    : AspectRatio(
                        aspectRatio: 0.8,
                        child: VideoPlayer(_videoPlayeController.value!),
                      );
              },
            ),
            const SizedBox(
              height: 50,
            ),
            CustomButton(
              ontap: () {
                pickUserVideo();
              },
              child: const Text(
                "Upload video",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                if (_videoFile.value != null) {
                  _userController.uploadVideo(
                    video: _videoFile.value!,
                    onClickToProceed: onClickToProceed,
                  );
                } else {
                  CustomSnackbar.show("Error", "Select a video");
                }
              },
              child: Obx(
                () => Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: Colors.deepOrangeAccent,
                      )),
                  child: _userController.isloading.value
                      ? const Loader(
                        color: Colors.deepOrangeAccent,
                      )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: AppColor.themeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            decorationColor: AppColor.themeColor,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
