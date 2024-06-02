import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:video_player/video_player.dart';

class UpdateVideoScreen extends StatelessWidget {
  UpdateVideoScreen({
    super.key,
  });

  final Rx<File?> _videoFile = Rx<File?>(null);
  final _userController = Get.put(UserController());
  final RxBool _isloading = false.obs;
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
    _isloading.value = true;
    await _userController.uploadVideo(
      video: _videoFile.value!,
      isSignUp: false,
    );
    _isloading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Video"),
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
                    return const SizedBox(
                      height: 300,
                      width: 400,
                      child: Icon(
                        Icons.cloud_upload,
                        size: 120,
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
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (_videoFile.value != null) {
                    submitVideo();
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
                      ),
                    ),
                    child: _isloading.value
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
