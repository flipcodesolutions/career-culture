import 'package:flutter/material.dart';
import 'user_screen_time_tracking.dart';

mixin ScreenTracker<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  String get screenName; // implement this in your State
  bool get debug => false; // override this in your widget if needed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logScreenOpen();
    if (debug) debugPrint("[$screenName] initState called");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    logScreenClose();
    if (debug) debugPrint("[$screenName] dispose called");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (debug) debugPrint("[$screenName] AppLifecycleState: $state");
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      logScreenClose();
    } else if (state == AppLifecycleState.resumed) {
      logScreenOpen();
    }
  }

  void logScreenOpen() {
    if (debug) debugPrint("[$screenName] logScreenOpen at ${DateTime.now()}");
    AnalyticsService.instance.logEvent(
      startTime: DateTime.now().toIso8601String(),
      screenName: screenName,
    );
  }

  void logScreenClose() async {
    if (debug) debugPrint("[$screenName] logScreenClose at ${DateTime.now()}");
    AnalyticsService.instance.exitLogEvent(
      endTime: DateTime.now().toIso8601String(),
    );
    await AnalyticsService.instance.flush(context: context);
  }
}
///
/// copy this in the screen where we want tracking of user time spend
//  @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // TODO: implement didChangeAppLifecycleState
//     super.didChangeAppLifecycleState(state);
//   }

//   @override
//   String get screenName => 'HomeScreen';
//   @override
//   bool get debug => false; // Enable debug logs