import 'dart:developer';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:mindful_youth/models/on_boarding_model/on_borading_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class OnBoardingService {
  Future<OnBoardingModel?> getOnBoardings(
    // {required BuildContext context,}
    ) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        // context: context,
        uri: ApiHelper.onBoarding,
      );
      if (response.isNotEmpty) {
        OnBoardingModel model = OnBoardingModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log('error while getting on boarding => $e') : null;
      return null;
    }
  }
}
