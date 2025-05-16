import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider/user_provider.dart';
import 'user_screen_time_tracking.dart';

mixin ScreenTracker<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  String get screenName; // Must be implemented in consuming class
  bool get debug => false; // Can be overridden in consuming class

  UserProvider? _userProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userProvider == null
        ? _userProvider = Provider.of<UserProvider>(context, listen: false)
        : null;
    // Now it's safe to log screen open (context is valid now)
    logScreenOpen();
    if (debug) debugPrint("[$screenName] initState called");
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Safely cache the provider here (mounted and stable)
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    logScreenClose(); // safe — uses cached _userProvider
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
    if (_userProvider != null) {
      AnalyticsService.instance.logEvent(
        startTime: DateTime.now().toIso8601String(),
        screenName: screenName,
        userProvider: _userProvider ?? UserProvider(),
      );
    }
  }

  void logScreenClose() async {
    if (debug) debugPrint("[$screenName] logScreenClose at ${DateTime.now()}");
    AnalyticsService.instance.exitLogEvent(
      endTime: DateTime.now().toIso8601String(),
    );
    if (_userProvider != null) {
      await AnalyticsService.instance.flush(
        userProvider: _userProvider ?? UserProvider(),
      );
    }
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
