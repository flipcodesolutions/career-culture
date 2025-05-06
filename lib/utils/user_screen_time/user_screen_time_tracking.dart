import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/service/user_time_tracking_service/user_time_tracking_service.dart';

class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  Map<String, dynamic> screenLog = {};
  Map<String, dynamic> resetMap = {
    "start_time": "",
    "end_time": "",
    "module": "",
  };

  void logEvent({
    required String startTime,
    // required String endTime,
    required String screenName,
  }) {
    final event = {
      "start_time": startTime,
      "end_time": "",
      "module": screenName,
    };
    screenLog = event;
    log(screenLog.toString());
  }

  void exitLogEvent({required String endTime}) {
    screenLog['end_time'] = endTime;
    log(screenLog.toString());
  }

  UserTimeTrackingService userTimeTrackingService = UserTimeTrackingService();
  Future<void> flush({required BuildContext context}) async {
    // send _buffer to your API, then clear it
    bool success = await userTimeTrackingService.logUserTiming(
      context: context,
      logData: screenLog,
    );
    if (success) {
      screenLog = resetMap;
    }
  }
}
