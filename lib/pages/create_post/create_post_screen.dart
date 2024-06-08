import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/utility/image_picker.dart';
import 'package:linkingpal/utility/video_picker.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();

  final _postController = Get.put(PostController());
  final Map<int, VideoPlayerController> _videoControllers = {};
  final RxList<XFile> _filesList = <XFile>[].obs;
  final RxList _tagList = [].obs;
  RxBool _isloading = false.obs;

  void _pickImageForUser() async {
    final imagePicked = await selectImageInFileFormat();
    if (imagePicked != null) {
      _filesList.add(imagePicked);
    }
  }

  void _pickVideoFoUser() async {
    final videoPicked = await selectVideoXFile();
    if (videoPicked != null) {
      _filesList.add(videoPicked);
    }
  }

  bool _isImage(XFile file) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = file.path.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  void extractHashtags(String input) {
    List<String> words = input.split(' ');
    List<String> hashtags =
        words.where((word) => word.startsWith('#')).toList();
    _tagList.value = hashtags;
  }

  void postContent() async {
    _postController.isloading.value = true;
    extractHashtags(_textController.text);
    if (_textController.text.isNotEmpty && _filesList.isNotEmpty) {
      _postController.createPost(
        textController: _textController,
        pickedFiles: _filesList,
        tags: _tagList,
        context: context,
      );
      FocusManager.instance.primaryFocus?.unfocus();
    } else {
      CustomSnackbar.show("Error", "Fill the text and fill");
    }
  }

  @override
  void dispose() {
    // Dispose all video controllers
    _videoControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  final List _allIntetrest = [
    "Game",
    "Clubbing",
    "Having breakfast",
    "Going out for lunch",
    "Having dinner together",
    "Going for drinks",
    "Working out at the gym",
    "Attending church/mosque",
    "Going on holiday trips",
    "Getting spa treatments",
    "Shopping together",
    "Watching Netflix and chilling",
    "Being event or party partners",
    "Cooking and chilling",
    "Smoking together",
    "Studying together",
    "Playing sports",
    "Going to concerts",
    "Hiking or outdoor activities",
    "Playing board games or video games",
    "Traveling buddy",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.dashboard, arguments: {
              "startScreen": 0,
            });
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 140,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    "Pick A Image or Video",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _pickImageForUser();
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _pickVideoFoUser();
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(
                                            Icons.video_camera_back_sharp,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
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
                          itemCount: _filesList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final XFile file = _filesList[index];
                            final isImage = _isImage(file);
                            if (!isImage) {
                              if (!_videoControllers.containsKey(index)) {
                                _videoControllers[index] =
                                    VideoPlayerController.file(File(file.path))
                                      ..initialize().then((_) {
                                        setState(() {});
                                      });
                              }
                            }
                            return SizedBox(
                              height: 80,
                              width: 90,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      image: isImage
                                          ? DecorationImage(
                                              image: FileImage(
                                                File(file.path),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: isImage
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.file(
                                              File(file.path),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : _videoControllers[index] != null &&
                                                _videoControllers[index]!
                                                    .value
                                                    .isInitialized
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                child: AspectRatio(
                                                  aspectRatio:
                                                      _videoControllers[index]!
                                                          .value
                                                          .aspectRatio,
                                                  child: VideoPlayer(
                                                    _videoControllers[index]!,
                                                  ),
                                                ),
                                              )
                                            : const Center(
                                                child: Loader(
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                ),
                                              ),
                                  ),
                                  Positioned(
                                    right: 1,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _filesList.removeAt(index);
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.x,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
                    postContent();
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
              const SizedBox(height: 10),
              Obx(
                () {
                  return _isloading.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Activity/Mood",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              child: ListView.builder(
                                itemCount: _allIntetrest.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 2,
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 9, top: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Text(
                                        _allIntetrest[index],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Date",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                SfDateRangePicker();
                              },
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  )
                                ),
                                child:const  Text("DD/MM/YYYY"),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      : const SizedBox();
                },
              ),
              GestureDetector(
                onTap: () {
                  _isloading.value = !_isloading.value;
                },
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.redAccent,
                    ),
                  ),
                  child: const Text(
                    "Create Event",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrangeAccent,
                    ),
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
