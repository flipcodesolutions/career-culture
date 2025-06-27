import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/notification_handler/notification_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_image_strings.dart';
import '../../app_const/app_strings.dart';
import '../../provider/user_provider/user_provider.dart';
import '../../utils/method_helpers/method_helper.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../main_screen/main_screen.dart';
import '../on_boarding_screen/on_boarding_screen.dart';

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
  final int _animationDelay = 1;

  @override
  void initState() {
    super.initState();
    _initSplashSequence();
  }

  Future<void> _initSplashSequence() async {
    await _startIntroAnimation();
    await handleAuthAndNavigate();
  }

  Future<void> _startIntroAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    setState(() {
      _scale = 1.0;
      _opacity = 1.0;
    });
    await Future.delayed(Duration(seconds: _animationDelay * 3));
  }

  ///
  Future<void> handleAuthAndNavigate() async {
    final userProvider = context.read<UserProvider>();
    final token = await SharedPrefs.getToken();
    final status = await SharedPrefs.getSharedString(AppStrings.status);

    if (token.isNotEmpty) {
      /// if there is token that means user have logged in so set flag to true
      userProvider.setIsUserLoggedIn = true;

      if (status != "active") {
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
  }

  @override
  void dispose() {
    // _deepLinkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomAnimatedContainer(
        duration: Duration(seconds: _animationDelay),
        width: 100.w,
        height: 100.h,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(seconds: _animationDelay * 2),
            opacity: _opacity,
            child: AnimatedScale(
              duration: Duration(seconds: _animationDelay),
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
