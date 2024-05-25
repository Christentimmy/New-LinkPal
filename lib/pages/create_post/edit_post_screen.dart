import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linkingpal/controller/post_controller.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/res/common_button.dart';
import 'package:linkingpal/res/common_textfield.dart';
import 'package:linkingpal/theme/app_theme.dart';
import 'package:linkingpal/widgets/loading_widget.dart';
import 'package:linkingpal/widgets/snack_bar.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel postModel;
  const EditPostScreen({
    super.key,
    required this.postModel,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _postController = Get.put(PostController());
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.postModel.text);
  }

  var _textController = TextEditingController();
  final RxList _tagList = [].obs;

  void extractHashtags(String input) {
    List<String> words = input.split(' ');
    List<String> hashtags =
        words.where((word) => word.startsWith('#')).toList();
    _tagList.value = hashtags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: widget.postModel.files.length,
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
                          image: NetworkImage(
                            widget.postModel.files[index],
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
                    extractHashtags(_textController.text);
                    if (_textController.text.isNotEmpty) {
                      _postController.editPost(
                        postId: widget.postModel.id,
                        textEdited: _textController.text,
                      );
                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                      CustomSnackbar.show("Error", "Fill the text");
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
