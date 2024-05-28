import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/retrieve_controller.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/comment_model.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isCommentLoading = false.obs;
  String baseUrl = "https://linkingpal.dasimems.com/v1";
  RxList<PostModel> allPost = RxList<PostModel>();
  RxList<PostModel> allUserPost = RxList<PostModel>();
  RxList<CommentModel?> commentModelsList = RxList<CommentModel?>();

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
    required BuildContext context,
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
      postModelUserData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allUserPost.addAll(postModelUserData);
    } catch (e) {
      debugPrint(e.toString());
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
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].likes = allPost[index].likes += 1;
        updatedAllPost[index].isLikeByUser = true;
        allPost.addAll(updatedAllPost);

        //userpost list
        List<PostModel> updatedAllUSerPost = List.from(allUserPost);
        updatedAllUSerPost[indexUserPost].likes =
            allPost[indexUserPost].likes += 1;
        updatedAllUSerPost[indexUserPost].isLikeByUser = true;
        allUserPost.addAll(updatedAllPost);
      }
      final uri =
          Uri.parse("$baseUrl/post/$postId/like").replace(queryParameters: {
        'postId': postId,
      });

      await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
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
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);
      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].likes = allPost[index].likes -= 1;
        updatedAllPost[index].isLikeByUser = false;
        allPost.clear();
        allPost.addAll(updatedAllPost);

        //userpost
        List<PostModel> updatedAllUserPost = List.from(allUserPost);
        updatedAllUserPost[indexUserPost].likes =
            allUserPost[indexUserPost].likes -= 1;
        updatedAllUserPost[indexUserPost].isLikeByUser = false;
        allUserPost.clear();
        allUserPost.addAll(updatedAllUserPost);
      }

      final uri =
          Uri.parse("$baseUrl/post/$postId/like").replace(queryParameters: {
        'postId': postId,
      });

      await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    List<PostModel> shadowCopy = List.from(allPost);
    shadowCopy.removeWhere((element) => element.id == postId);
    allPost.clear();
    allPost.addAll(shadowCopy);
    Navigator.pop(context);

    List<PostModel> shadowCopyUserPost = List.from(allUserPost);
    shadowCopyUserPost.removeWhere((element) => element.id == postId);
    allUserPost.clear();
    allUserPost.addAll(shadowCopy);

    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri = Uri.parse("$baseUrl/post/$postId").replace(queryParameters: {
        'postId': postId,
      });
      final response = await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      final decodedResponce = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.show("Error", decodedResponce["message"]);
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
          "Error",
          decodedResponce["message"].toString(),
        );
      }

      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].likes = allPost[index].comments += 1;
        allPost.addAll(updatedAllPost);

        //userpost list
        List<PostModel> updatedAllUSerPost = List.from(allUserPost);
        updatedAllUSerPost[indexUserPost].likes =
            allPost[indexUserPost].comments += 1;
        allUserPost.addAll(updatedAllPost);
      }

      final commentData = CommentModel.fromJson(decodedResponce["data"]);
      commentModelsList.add(commentData);
      CustomSnackbar.show("Success", "Comment done");
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      comment.clear();
      isloading.value = false;
    }
  }

  Future<void> editPost({
    required String postId,
    required String textEdited,
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
      final uri = Uri.parse("$baseUrl/post/$postId");
      final responce = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "text": textEdited,
        }),
      );
      final decoded = json.decode(responce.body);
      if (responce.statusCode != 200) {
        return CustomSnackbar.show("Error", decoded["message"].toString());
      }
      int index = allPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].text = decoded["data"]["text"];
        allPost.addAll(updatedAllPost);
      }
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getComments(String postId) async {
    isCommentLoading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri = Uri.parse("$baseUrl/post/$postId/comment").replace(
        queryParameters: {
          "postId": postId,
        },
      );
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        List<dynamic> commentFromData = decoded["data"];
        List<CommentModel> commentMod =
            commentFromData.map((e) => CommentModel.fromJson(e)).toList();
        commentModelsList.addAll(commentMod);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isCommentLoading.value = false;
    }
  }

  Future<void> deleteComment(String commentId) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.show("Error", "Login Again");
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final uri = Uri.parse("$baseUrl//post/comment/$commentId").replace(
        queryParameters: {
          "commentId": commentId,
        },
      );
      final response = await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      print(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
