import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  RxBool isloading = false.obs;
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxList<PostModel> allUserPost = RxList<PostModel>();

  @override
  void onInit() {
    super.onInit();
    getAllPost();
  }

  Future<void> createPost({
    required String text,
    required List<XFile> pickedFiles,
    List<String>? tags,
  }) async {
    isloading.value = true;

    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      var uri = Uri.parse('https://linkingpal.dasimems.com/v1/post');

      var request = http.MultipartRequest('POST', uri);

      //Authorization
      request.headers['Authorization'] = token;

      // Add the text parameter
      request.fields['text'] = text;

      // Add the tags parameter if present
      if (tags != null && tags.isNotEmpty) {
        request.fields['tags'] = jsonEncode(tags);
      }

      // Add the files
      for (var file in pickedFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

      // Send the request
      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final decodedResponse = await json.decode(responseBody);
      debugPrint(decodedResponse.toString());
      if (response.statusCode != 201) {
        return CustomSnackbar.show(
          "Error",
          decodedResponse["message"].toString(),
        );
      }
      CustomSnackbar.show("Success", "Your post is now live!");
      PostModel.fromJson(decodedResponse["data"]);
      await getAllPost();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
      pickedFiles.clear();
    }
  }

  Future<void> getAllPost() async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.get(Uri.parse("$baseUrl/post/all"), headers: {
        "Authorization": "Bearer $token",
      });

      final decodedResponce = await json.decode(response.body);

      if (response.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          decodedResponce["message"].toString(),
        );
      }
      debugPrint(decodedResponce["total"].toString());
      List<dynamic> postsFromData = decodedResponce["data"];
      List<PostModel> postModels = postsFromData.map((e) => PostModel.fromJson(e)).toList();
      allUserPost.addAll(postModels);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
