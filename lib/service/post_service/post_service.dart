import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/post_models/post_like_model.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../models/post_models/wall_model.dart';

class PostService {
  Future<PostListModel?> getPostById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getPostById(id: id),
      );
      if (response.isNotEmpty) {
        PostListModel model = PostListModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting post => $e') : null;
      return null;
    }
  }

  /// get wall post
  Future<WallListModel?> getWallPosts(
    {required BuildContext context}
  ) async {
    try {
      String uId = await SharedPrefs.getSharedString(AppStrings.id);
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getWallPosts(uId: uId),
      );
      if (response.isNotEmpty) {
        return WallListModel.fromJson(response);
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting wall post => $e') : null;
      return null;
    }
  }

  /// like a post
  Future<PostLikeModel?> likePost({
    required BuildContext context,
    required int wallId,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.likeWallPost,
        context: context,
        body: {"wall_id": wallId.toString()},
      );
      if (response.isNotEmpty) {
        PostLikeModel model = PostLikeModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log("error while liking wall post $wallId => $e");
      return null;
    }
  }

  Future<WallListModelData?> getWallPostBySlug({required String slug,required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: ApiHelper.getWallPostBySlug,
        body: {"slug": slug},
      );
      if (response.isNotEmpty) {
        return WallListModelData.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      log("error while getting wall post by slug => $e");
      return null;
    }
  }
}
