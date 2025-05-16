import 'dart:developer';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ChapterService {
  /// chapter service by  id
  Future<ChaptersModel?> getChapterById({
    // required BuildContext context,
    required String id,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        // context: context,
        uri: ApiHelper.getChapters(id: id),
      );
      if (response.isNotEmpty) {
        ChaptersModel model = ChaptersModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting chapter by id => $e') : null;
      return null;
    }
  }

  Future<ChaptersModel?> getAllChapters(
    // {required BuildContext context}
    ) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        // context: context,
        uri: ApiHelper.getAllChapters,
      );
      if (response.isNotEmpty) {
        ChaptersModel model = ChaptersModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting chapter by id => $e') : null;
      return null;
    }
  }
}
