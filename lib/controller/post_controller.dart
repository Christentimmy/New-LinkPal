// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkingpal/controller/token_storage_controller.dart';
import 'package:linkingpal/models/comment_model.dart';
import 'package:linkingpal/models/likes_model.dart';
import 'package:linkingpal/models/post_model.dart';
import 'package:linkingpal/theme/app_routes.dart';
import 'package:linkingpal/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isDeleteLoading = false.obs;
  RxBool isCommentLoading = false.obs;
  String baseUrl = "https://linkingpal.onrender.com/v1";
  RxList<PostModel> allPost = <PostModel>[].obs;
  RxList<PostModel> allUserPost = <PostModel>[].obs;
  RxList<LikesModel> allLikes = <LikesModel>[].obs;
  RxList<CommentModel> commentModelsList = <CommentModel>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getAllUserPost();
  //   getAllPost();
  // }

  Future<void> createPost({
    required TextEditingController textController,
    required List<XFile> pickedFiles,
    List<dynamic>? tags,
    required BuildContext context,
  }) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      var uri = Uri.parse('$baseUrl/post');
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
      print(decodedResponse);
      if (response.statusCode != 201) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponse["message"].toString(),
          context,
        );
      }
      CustomSnackbar.showSuccessSnackBar("Your post is now live!", context);
      getAllPost(context: context);
      getAllUserPost(context: context);
      Get.offAllNamed(AppRoutes.dashboard, arguments: {
        "startScreen": 0,
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
      pickedFiles.clear();
      textController.clear();
    }
  }

  Future<void> getAllPost({
    required BuildContext context,
  }) async {
    isloading.value = true;
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/post/all"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final decodedResponce = await json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"].toString(),
          context,
        );
      }
      List<dynamic> postsFromData = decodedResponce["data"];
      List filterMap =
          postsFromData.where((e) => e.containsKey("created_by")).toList();
      List<PostModel> postModels =
          filterMap.map((e) => PostModel.fromJson(e)).toList();
      postModels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allPost.clear();
      allPost.addAll(postModels);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getAllUserPost({required BuildContext context}) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/post"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final decodedResponce = json.decode(response.body);
      if (response.statusCode != 200) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"].toString(),
          context,
        );
      }

      List<dynamic> dataListFromResponce = decodedResponce["data"];
      List<PostModel> postModelUserData = dataListFromResponce
          .map(
            (e) => PostModel.fromJson(e),
          )
          .toList();
      postModelUserData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allUserPost.clear();
      allUserPost.addAll(postModelUserData);
      allUserPost.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> likeAPost(String postId, BuildContext context) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);
      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].likes += 1;
        updatedAllPost[index].isLikeByUser = true;
        allPost.clear();
        allPost.addAll(updatedAllPost);
      }
      if (indexUserPost != -1) {
        //userpost list
        List<PostModel> updatedAllUSerPost = List.from(allUserPost);
        updatedAllUSerPost[indexUserPost].likes += 1;
        updatedAllUSerPost[indexUserPost].isLikeByUser = true;
        allUserPost.clear();
        allUserPost.addAll(updatedAllUSerPost);
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

  Future<void> disLikeAPost(String postId, BuildContext context) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);
      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].likes -= 1;
        updatedAllPost[index].isLikeByUser = false;
        allPost.clear();
        allPost.addAll(updatedAllPost);
      }
      if (indexUserPost != -1) {
        //userpost
        List<PostModel> updatedAllUserPost = List.from(allUserPost);
        updatedAllUserPost[indexUserPost].likes -= 1;
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

  Future<void> deletePost(String postId) async {
    isDeleteLoading.value = true;
    allPost.removeWhere((element) => element.id == postId);
    allUserPost.removeWhere((element) => element.id == postId);

    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
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
        Get.snackbar("Error", decodedResponce["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isDeleteLoading.value = false;
    }
  }

  Future<void> commentOnPost(
    String postId,
    TextEditingController comment,
    BuildContext context,
  ) async {
    isloading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
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

      if (response.statusCode != 200) {
        return CustomSnackbar.showErrorSnackBar(
          decodedResponce["message"].toString(),
          context,
        );
      }
      List<dynamic> allFreshComments = decodedResponce["data"]["comments"];
      List<CommentModel> freshMap =
          allFreshComments.map((e) => CommentModel.fromJson(e)).toList();
      commentModelsList.clear();
      commentModelsList.addAll(freshMap);
      for (var i = 0; i < allFreshComments.length; i++) {
        print(allFreshComments[i]);
      }

      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].comments += 1;
        allPost.clear();
        allPost.addAll(updatedAllPost);
      }
      if (indexUserPost != -1) {
        //userpost list
        List<PostModel> updatedAllUSerPost = List.from(allUserPost);
        updatedAllUSerPost[indexUserPost].comments += 1;
        allUserPost.clear();
        allUserPost.addAll(updatedAllUSerPost);
      }
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
    required BuildContext context,
  }) async {
    isloading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
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
        return CustomSnackbar.showErrorSnackBar(
            decoded["message"].toString(), context);
      }
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUser = allUserPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].text = decoded["data"]["text"];
        allPost.addAll(updatedAllPost);
      }
      if (indexUser != -1) {
        List<PostModel> updatedAllUserPost = List.from(allUserPost);
        updatedAllUserPost[index].text = decoded["data"]["text"];
        allUserPost.addAll(updatedAllUserPost);
      }
      Get.toNamed(AppRoutes.dashboard);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getComments(String postId, BuildContext context) async {
    isCommentLoading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
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

  Future<void> deleteComment({
    required String commentId,
    required String postId,
    required BuildContext context,
  }) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      final uri = Uri.parse("$baseUrl/post/comment/$commentId").replace(
        queryParameters: {
          "commentId": commentId,
        },
      );
      await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      int index = allPost.indexWhere((element) => element.id == postId);
      int indexUserPost =
          allUserPost.indexWhere((element) => element.id == postId);

      if (index != -1) {
        //allpost
        List<PostModel> updatedAllPost = List.from(allPost);
        updatedAllPost[index].comments -= 1;
        allPost.addAll(updatedAllPost);
      }
      if (indexUserPost != -1) {
        //userpost list
        List<PostModel> updatedAllUSerPost = List.from(allUserPost);
        updatedAllUSerPost[indexUserPost].comments -= 1;
        allUserPost.addAll(updatedAllUSerPost);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getSinglePost(String postId, BuildContext context) async {
    isloading.value = true;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final uri = Uri.parse("$baseUrl/post/$postId").replace(queryParameters: {
        "postId": postId,
      });

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final decoded = json.decode(response.body);
      List<dynamic> allLikesFromResponse = decoded["data"]["likes"];
      List filterMap = allLikesFromResponse
          .where((e) => e.containsKey("created_by"))
          .toList();
      List<LikesModel> mapLikes =
          filterMap.map((e) => LikesModel.fromJson(e)).toList();
      allLikes.value = mapLikes;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> likeComement(String commentId, BuildContext context) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      int index =
          commentModelsList.indexWhere((element) => element.id == commentId);
      if (index != -1) {
        commentModelsList[index].likes += 1;
        commentModelsList[index].isLikeByUser = true;
      }

      final uri = Uri.parse("$baseUrl/post/comment/$commentId/like")
          .replace(queryParameters: {
        "commentId": commentId,
      });

      final responce = await http.patch(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      print(responce.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> dislikeComement(String commentId, BuildContext context) async {
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }
    try {
      int index =
          commentModelsList.indexWhere((element) => element.id == commentId);
      if (index != -1) {
        List<CommentModel> shadowCopy = List.from(commentModelsList);
        shadowCopy[index].likes -= 1;
        shadowCopy[index].isLikeByUser = false;
      }

      final uri = Uri.parse("$baseUrl/post/comment/$commentId/like")
          .replace(queryParameters: {
        "commentId": commentId,
      });

      final responce = await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      print(responce.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> editComment(
      String commentId, String textComment, BuildContext context) async {
    isloading.value = false;
    //token validation
    final tokenStorage = Get.put(TokenStorage());
    String? token = await tokenStorage.getToken();
    if (token!.isEmpty) {
      CustomSnackbar.showErrorSnackBar("Login Again", context);
      return Get.toNamed(AppRoutes.signin);
    }

    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/post/comment/$commentId").replace(queryParameters: {
          "commentId": commentId,
        }),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "comment": textComment,
        }),
      );
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
            decoded["message"].toString(), context);
      }
      int index =
          commentModelsList.indexWhere((element) => element.id == commentId);
      CommentModel incomingComment = CommentModel.fromJson(decoded["data"]);
      if (index != -1) {
        List<CommentModel> freshEdit = List.from(commentModelsList);
        commentModelsList[index].comment = incomingComment.comment;
        commentModelsList.addAll(freshEdit);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  void reset() {
    allPost.clear();
    allUserPost.clear();
    allLikes.clear();
    commentModelsList.clear();
  }
}
