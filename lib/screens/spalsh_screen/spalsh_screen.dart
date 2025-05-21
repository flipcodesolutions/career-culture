import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:mindful_youth/screens/wall_screen/individual_wall_post_screen.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_image_strings.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/method_helper.dart';

/// --------------------------------------
/// SPLASH SCREEN WIDGET OVERVIEW
/// --------------------------------------
///
/// This is the entry point screen of the application. It serves three primary purposes:
///
/// 1. **Show a brief animated splash logo (branding)**
/// 2. **Check authentication and user status**
/// 3. **Navigate to the appropriate next screen**
///
///
/// --------------------------------------
/// CLASS: SplashScreen
/// --------------------------------------
///
/// A [StatefulWidget] that animates a splash image (scale & opacity) and
/// performs authentication checks using locally stored token and user status.
///
/// Navigation is handled using the [NavigateHelper] mixin (assumed to contain utility navigation methods).
///
///

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavigateHelper {
  double _scale = 0;
  double _opacity = 0.0;
  int time = 1;
  StreamSubscription? _sub;

  /// --------------------------------------
  /// SCENARIO HANDLING (What it does and when)
  /// --------------------------------------
  ///
  /// ✅ **Initial Animation (Branding/Intro):**
  /// - On `initState`, it triggers animation by changing `_scale` and `_opacity` after 100ms.
  /// - The animation uses [AnimatedScale] and `AnimatedOpacity` for smooth entrance.
  ///
  /// ✅ **User Auth Check (After Animation Delay):**
  /// - After 3 seconds (`time + time + time`), it performs:
  ///   - Fetching the `token` from shared preferences.
  ///   - Checking the `status` of the user (active/deactivated).
  ///
  ///
  /// --------------------------------------
  /// NAVIGATION LOGIC:
  /// --------------------------------------
  ///
  /// 🔒 Case 1: **User is logged in (token exists)**
  /// - Mark user as logged in via [UserProvider] .
  /// - If user status is **not 'active'** (e.g., suspended or deleted):
  ///     - Redirects to login via `MethodHelper.redirectDeletedOrInActiveUserToLoginPage()`
  /// - If user is valid and active:
  ///     - Navigate to `MainScreen` using `pushRemoveUntil()` (clears navigation stack).
  ///
  /// 🆕 Case 2: **User is NOT logged in**
  /// - Navigate to `OnBoardingScreen` to begin the new-user flow.
  ///
  ///
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() async {
    try {
      final AppLinks appLinks = AppLinks(); // AppLinks is singleton
      // Listen when the app is already running
      appLinks.uriLinkStream.listen((uri) {
        _handleDeepLink(uri);
      });
      // Handle initial link when app is launched
      final Uri? initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      } else {
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            _scale = 1.0;
            _opacity = 1.0;
          });
        });

        Future.delayed(Duration(seconds: time + time + time), () async {
          UserProvider userProvider = context.read<UserProvider>();
          String token = await SharedPrefs.getToken();
          String status = await SharedPrefs.getSharedString(AppStrings.status);
          if (token != "" && token.isNotEmpty) {
            userProvider.setIsUserLoggedIn = true;
            if (status != "active" && status != "") {
              MethodHelper().redirectDeletedOrInActiveUserToLoginPage(
                context: context,
              );
              return;
            }
            pushRemoveUntil(
              context: context,
              widget: MainScreen(),
              transition: FadeForwardsPageTransitionsBuilder(),
            );
          } else {
            pushRemoveUntil(
              context: context,
              widget: OnBoardingScreen(),
              transition: FadeForwardsPageTransitionsBuilder(),
            );
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _handleDeepLink(Uri uri) {
    // Example: https://career-culture.flipcodesolutions.com/uploads/my-post-slug
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'uploads') {
      final String slug = uri.pathSegments[1];
      WidgetHelper.customSnackBar(title: slug);
      // Navigate to the post page and pass the slug
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IndividualWallPostScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAnimatedContainer(
        duration: Duration(seconds: time),
        width: 100.w,
        height: 100.h,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(seconds: time + time),
            opacity: _opacity,
            child: AnimatedScale(
              duration: Duration(seconds: time),
              scale: _scale,
              curve: Curves.decelerate,
              child: Image.asset(AppImageStrings.splashScreen, width: 60.w),
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------
/// DEPENDENCIES:
/// --------------------------------------
/// - `SharedPrefs`: Used to retrieve user session data like token and status.
/// - `UserProvider`: A provider that stores global auth state (login status).
/// - `AppStrings`: Contains constants for shared preference keys.
/// - `AppImageStrings`: Contains path for splash image.
/// - `NavigateHelper`: Custom mixin providing `pushRemoveUntil()` for navigation.
/// - `CustomAnimatedContainer`: A wrapper presumably used for global animated containers.
/// - `MainScreen` & `OnBoardingScreen`: Target screens based on session state.
///
///
/// --------------------------------------
/// TIMING & UX NOTES:
/// --------------------------------------
/// - `_scale` and `_opacity` are both animated with a delay to provide a polished, slow intro effect.
/// - The total wait before navigation is **3 seconds**, giving enough time for:
///     - Branding effect
///     - Async token/status fetch
///     - Smooth transition
///
///
/// --------------------------------------
/// EXAMPLE USAGE:
/// --------------------------------------
/// ```dart
/// MaterialApp(
///   home: SplashScreen(),
/// );
/// ```
///
/// --------------------------------------
/// FUTURE IMPROVEMENTS (OPTIONAL):
/// --------------------------------------
/// - Add a fallback for token/status fetch failure (e.g., try-catch).
/// - Allow custom splash duration from app config.
/// - Optionally preload assets or fetch config before home screen.
