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
  RxList<PostModel> allPost = RxList<PostModel>();
  RxList<PostModel> allUserPost = RxList<PostModel>();

  @override
  void onInit() {
    super.onInit();
    getAllUserPost();
    getAllPost();
  }

  Future<void> createPost({
    required TextEditingController textController,
    required List<XFile> pickedFiles,
    List<dynamic>? tags,
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
      request.fields['text'] = textController.text;

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
      await getAllPost();
      await getAllUserPost();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
      pickedFiles.clear();
      textController.clear();
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
      final response = await http.get(
        Uri.parse("$baseUrl/post/all"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final decodedResponce = await json.decode(response.body);

      if (response.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          decodedResponce["message"].toString(),
        );
      }
      List<dynamic> postsFromData = decodedResponce["data"];
      List<PostModel> postModels =
          postsFromData.map((e) => PostModel.fromJson(e)).toList();
      postModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allPost.addAll(postModels);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getAllUserPost() async {
    isloading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/post"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final decodedResponce = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.show(
          "Error",
          decodedResponce["message"].toString(),
        );
      }

      List<dynamic> dataListFromResponce = decodedResponce["data"];
      List<PostModel> postModelUserData = dataListFromResponce
          .map(
            (e) => PostModel.fromJson(e),
          )
          .toList();
      postModelUserData.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      allUserPost.addAll(postModelUserData);
      print(allUserPost);
    } catch (e) {
      print(e);
      CustomSnackbar.show("Error", e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> likeAPost(String postId) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri =
          Uri.parse("$baseUrl/post/$postId/like").replace(queryParameters: {
        'postId': postId,
      });

      final response = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        int index = allPost.indexWhere((element) => element.id == postId);
        if (index != -1) {
          List<PostModel> updatedAllPost = List.from(allPost);
          updatedAllPost[index].likes = allPost[index].likes += 1;
          updatedAllPost[index].isLikeByUser = true;
          allPost.clear();
          allPost.addAll(updatedAllPost);
          print("success");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> disLikeAPost(String postId) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri =
          Uri.parse("$baseUrl/post/$postId/like").replace(queryParameters: {
        'postId': postId,
      });

      final response = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final decodedResponce = json.decode(response.body);
      debugPrint(decodedResponce.toString());
      if (response.statusCode == 200) {
        int index = allPost.indexWhere((element) => element.id == postId);
        if (index != -1) {
          List<PostModel> updatedAllPost = List.from(allPost);
          updatedAllPost[index].likes = allPost[index].likes -= 1;
          updatedAllPost[index].isLikeByUser = false;
          allPost.clear();
          allPost.addAll(updatedAllPost);
          print("success");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri = Uri.parse("$baseUrl/post/:$postId").replace(queryParameters: {
        'postId': postId,
      });
      final response = await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      final decodedResponce = json.decode(response.body);
      if (response.statusCode != 200) {
        print(decodedResponce);
        return CustomSnackbar.show("Error", decodedResponce["message"]);
      }
      if (response.statusCode == 200) {
        int index = allPost.indexWhere((element) => element.id == postId);
        if (index != -1) {
          allPost.removeAt(index);
          refresh();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> commentOnPost(
    String postId,
    TextEditingController comment,
  ) async {
    isloading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri =
          Uri.parse("$baseUrl/post/$postId/comment").replace(queryParameters: {
        "postId": postId,
      });
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "comment": comment.text,
        }),
      );
      final decodedResponce = json.decode(response.body);
      print(decodedResponce);
      if (response.statusCode != 200) {
        return CustomSnackbar.show(
            "Error", decodedResponce["message"].toString());
      }
      CustomSnackbar.show("Success", "Comment done");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}