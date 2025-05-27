import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helpper.dart';

class UserTimeTrackingService {
  Future<bool> logUserTiming({
    required BuildContext context,
    required Map<String, dynamic> logData,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.screenTime,
        context: context,
        body: logData,
      );
      if (response.isNotEmpty) {
        return response['success'];
      }
      return false;
    } catch (e) {
      log(
        "error while logging screen  => ${logData.toString()} , error ===> $e",
      );
      return false;
    }
  }
}
