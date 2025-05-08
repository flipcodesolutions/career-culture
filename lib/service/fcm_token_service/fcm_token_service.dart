import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class FcmTokenService {
  Future<void> sendFcmTokenWithUId({
    required BuildContext context,
    required String uId,
    required String fcmToken,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.sendFcmToken,
        context: context,
        body: {"user_id": uId, "fcmToken": fcmToken},
      );
      if (response.isNotEmpty) {
        log(response['message']);
      }
    } catch (e) {
      log("error while sending fcm token => $e");
    }
  }
}
