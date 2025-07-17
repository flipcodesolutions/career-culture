import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/feedback_model/feedback_model.dart';
import 'package:mindful_youth/models/user_notification/counseling_schedual_change_model.dart';
import 'package:mindful_youth/models/user_notification/user_notification_model.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helpper.dart';

class UserNotificationService {
  /// get user notification to show
  Future<UserNotifications?> getUserNotification({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getUserNotification,
      );
      if (response.isNotEmpty) {
        return UserNotifications.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting user notification => $e ");
      return null;
    }
  }

  /// get user feedback notification to show
  Future<FeedbackModel?> getUserFeedbackNotification({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getUserFeedbackNotification,
      );
      if (response.isNotEmpty) {
        return FeedbackModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting user feedback notification => $e ");
      return null;
    }
  }

  /// sent back that user has opened the notification of id
  Future<bool> sentUserOpenedNotification({
    required BuildContext context,
    required String apiUrl,
    required Map<String, dynamic> body,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: apiUrl,
        body: body,
      );
      if (response.isNotEmpty) {
        return response['success'];
      } else {
        return false;
      }
    } catch (e) {
      log("error while sending notification id that just got opened => $e ");
      return false;
    }
  }

  /// sent back that user has opened the notification of id
  Future<bool> sentUserFeedbackOpenedNotification({
    required BuildContext context,
    required String notificationId,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: ApiHelper.sentUserFeedbackNotificationOpened,
        body: {"appointmentId": notificationId},
      );
      if (response.isNotEmpty) {
        return response['success'];
      } else {
        return false;
      }
    } catch (e) {
      log("error while sending notification id that just got opened => $e ");
      return false;
    }
  }

  /// get notifications releated to counseling schedual
  Future<CounselingSchedualChangeNotificationModel?>
  getCounselingSchedualChangeNotificationModel({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getAppointmentStatusChangeNotification,
      );
      if (response.isNotEmpty) {
        return CounselingSchedualChangeNotificationModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log(
        "error while getting counseling schedual releated notifications => $e",
      );
      return null;
    }
  }
}
