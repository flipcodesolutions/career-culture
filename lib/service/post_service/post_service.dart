import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

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
  Future<PostListModel?> getWallPosts({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getWallPosts,
      );
      if (response.isNotEmpty) {
        PostListModel model = PostListModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting wall post => $e') : null;
      return null;
    }
  }
}
