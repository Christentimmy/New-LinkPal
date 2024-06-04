import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/video_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:video_player/video_player.dart';

class IntroductionVideoScreen extends StatelessWidget {
  IntroductionVideoScreen({
    super.key,
  });

  final Rx<File?> _videoFile = Rx<File?>(null);
  final _userController = Get.put(UserController());
  final RxBool _isLoading = false.obs;
  final RxBool _isVideoInitialized = false.obs;

  final Rx<VideoPlayerController?> _videoPlayerController =
      Rx<VideoPlayerController?>(null);

  final Rx<ChewieController?> _chewieController = Rx<ChewieController?>(null);

  void pickUserVideo() async {
    File? videoSelected = await selectVideo();
    if (videoSelected != null) {
      _videoFile.value = videoSelected;
      _videoPlayerController.value =
          VideoPlayerController.file(_videoFile.value!)
            ..initialize().then((_) {
              _chewieController.value = ChewieController(
                videoPlayerController: _videoPlayerController.value!,
                autoPlay: true,
                looping: false,
              );
              _isVideoInitialized.value = true;
            });
    }
  }

  void submitVideo() async {
    if (_videoFile.value != null) {
      _isLoading.value = true;
      await _userController.uploadVideo(
        video: _videoFile.value!,
        isSignUp: true,
      );
      _isLoading.value = false;
    } else {
      CustomSnackbar.show("Error", "Select a video");
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () {
                  if (_videoFile.value == null) {
                    return Container(
                      height: 500,
                      width: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      child: const Text(
                        "Upload Video",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  } else if (!_isVideoInitialized.value) {
                    return const SizedBox(
                      height: 300,
                      width: 400,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return AspectRatio(
                      aspectRatio:
                          _videoPlayerController.value!.value.aspectRatio,
                      child: Chewie(controller: _chewieController.value!),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                ontap: pickUserVideo,
                child: const Text(
                  "Upload video",
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: submitVideo,
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
                      ),
                    ),
                    child: _isLoading.value
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
      ),
    );
  }
}
