import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/score_model/score_board_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ScoreBoardService {
  Future<ScoreBoardModel?> getScoreBoard(
    { required BuildContext context,}
  ) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getScoreBoard,
      );
      if (response.isNotEmpty) {
        ScoreBoardModel model = ScoreBoardModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log('error while getting score board => $e');
      return null;
    }
  }
}
