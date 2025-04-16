import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_image_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavigateHelper {
  double _scale = 0;
  double _opacity = 0.0;
  int time = 1;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });

    Future.delayed(Duration(seconds: time + time + time), () async {
      UserProvider userProvider = context.read<UserProvider>();
      String token = await SharedPrefs.getToken();
      if (token != "" && token.isNotEmpty) {
        userProvider.setIsUserLoggedIn = true;
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
