import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:mindful_youth/models/login_model/user_signup_confirm_model.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/service/user_time_tracking_service/user_time_tracking_service.dart';
// import 'package:provider/provider.dart';

class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  Map<String, dynamic> screenLog = {};
  Map<String, dynamic> resetMap = {
    "start_time": "",
    "end_time": "",
    "module": "",
  };

  String? _activeScreen;

  Future<void> logEvent({
    required String startTime,
    required String screenName,
    required BuildContext context,
    required UserProvider userProvider,
  }) async {
    // Flush previous log before starting a new one
    if (_activeScreen != null && _activeScreen != screenName) {
      exitLogEvent(endTime: DateTime.now().toIso8601String());
      await flush(userProvider: userProvider,context: context); // Now flush with old screen data
    }

    _activeScreen = screenName;
    screenLog = {"start_time": startTime, "end_time": "", "module": screenName};

    log("STARTED: $screenLog");
  }

  void exitLogEvent({required String endTime}) {
    if (_activeScreen != null && screenLog["end_time"] == "") {
      screenLog['end_time'] = endTime;
      log("ENDED: $screenLog");
    }
  }

  UserTimeTrackingService userTimeTrackingService = UserTimeTrackingService();

  Future<void> flush(
  {required BuildContext context,
  required UserProvider userProvider}) async {
    /// if user is not logged in
    if (!userProvider.isUserLoggedIn) return;
    //// else  make call
    if (_activeScreen != null && screenLog["end_time"] != "") {
      bool success = await userTimeTrackingService.logUserTiming(
        context: context,
        logData: screenLog,
      );
      if (success) {
        _activeScreen = null;
        screenLog = resetMap;
      }
    }
  }
}
