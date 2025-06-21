import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class FeedbackService {
  /// sent back user feedback
  Future<bool> feedback({
    required BuildContext context,
    required String mentorId,
    required String counselingDate,
    required String slotTime,
    required String rating,
    required String goal,
    required String message,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: ApiHelper.feedback,
        body: {
          "counseling_by": mentorId,
          "counseling_date": counselingDate,
          "counseling_slot": slotTime,
          "rating": rating,
          "goal": goal,
          "message": message,
        },
      );
      if (response.isNotEmpty) {
        return response['success'];
      } else {
        return false;
      }
    } catch (e) {
      log("error while sending feedback => $e");
      return false;
    }
  }
}
