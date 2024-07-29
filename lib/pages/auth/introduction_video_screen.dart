import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkingpal/controller/user_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/theme/app_routes.dart';
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
  final RxBool _isPick = false.obs;
  final RxBool _isVideoInitialized = false.obs;

  final Rx<VideoPlayerController?> _videoPlayerController =
      Rx<VideoPlayerController?>(null);

  final Rx<ChewieController?> _chewieController = Rx<ChewieController?>(null);

  Future<int> getVideoDurationInSeconds(File videoFile) async {
    VideoPlayerController controller = VideoPlayerController.file(videoFile);

    // Initialize the controller
    await controller.initialize();

    // Get the duration in seconds
    int durationInSeconds = controller.value.duration.inSeconds;

    // Dispose of the controller when done
    await controller.dispose();

    return durationInSeconds;
  }

  void pickUserVideo() async {
    _isPick.value = true;
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
    _isPick.value = false;
  }

  void submitVideo(BuildContext context) async {
    if (_videoFile.value == null) {
      return CustomSnackbar.showErrorSnackBar("Select a video");
    }
    int duration = await getVideoDurationInSeconds(_videoFile.value!);
    if (duration > 10) {
      return CustomSnackbar.showErrorSnackBar(
        "Select video less than 10seconds",
      );
    }
    _isLoading.value = true;
    Get.toNamed(AppRoutes.personalDataFromUser);
    _userController.uploadVideo(
      video: _videoFile.value!,
      isUpdateVideo: false,
    );
    _isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Introduction Video"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () {
                  if (_isPick.value) {
                    return Container(
                      height: 500,
                      width: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: const Loader(color: Colors.deepOrangeAccent),
                    );
                  } else if (_videoFile.value == null) {
                    return Container(
                      height: 500,
                      width: 400,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: const Text(
                        "Click Select Video\nButton Below",
                        textAlign: TextAlign.center,
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
                child: Text(
                  "Select video",
                  style: GoogleFonts.montserrat(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  submitVideo(context);
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
                    child: _isLoading.value
                        ? const Loader(
                            color: Colors.deepOrangeAccent,
                          )
                        : Text(
                            "Submit",
                            style: GoogleFonts.montserrat(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
