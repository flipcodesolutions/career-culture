import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/on_boarding_provider/on_boarding_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_smooth_page_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with NavigateHelper {
  final PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      if (!context.mounted) return;
      final provider = context.read<OnBoardingProvider>();
      provider.getOnBoarding(context: context);
    });
  }

  void redirectUserToLoginPage() {
    pushRemoveUntil(
      context: context,
      widget: LoginScreen(isToNavigateHome: true),
      transition: ZoomPageTransitionsBuilder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    OnBoardingProvider onBoardingProvider = context.watch<OnBoardingProvider>();
    if (onBoardingProvider.isLoading) {
      return Scaffold(body: Center(child: CustomLoader()));
    } else {
      return onBoardingProvider.onBoardingModel?.data?.isNotEmpty == true
          ? Scaffold(
            appBar: AppBar(
              leading: CustomSmoothPageIndicator(
                pageCount:
                    onBoardingProvider.onBoardingModel?.data?.length ?? 0,
                activeIndex: onBoardingProvider.currentPage,
              ),
              actions: [
                PrimaryBtn(
                  width: 20.w,
                  backGroundColor: AppColors.white,
                  borderColor: AppColors.white,
                  btnText: AppStrings.skip,
                  onTap: () => redirectUserToLoginPage(),
                ),
              ],
            ),
            body: PageView(
              controller: pageController,
              onPageChanged:
                  (value) => onBoardingProvider.setCurrentPage = value,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: onBoardingProvider.onBoardingSinglePageList(),
            ),
            bottomNavigationBar: CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child:
                  (onBoardingProvider.currentPage <
                              (onBoardingProvider
                                          .onBoardingModel
                                          ?.data
                                          ?.length ??
                                      0) -
                                  1) ==
                          true
                      ? PrimaryBtn(
                        btnText: AppStrings.next,
                        onTap: () {
                          pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          onBoardingProvider.setCurrentPage =
                              onBoardingProvider.currentPage + 1;
                        },
                        textStyle: TextStyleHelper.mediumHeading,
                      )
                      : PrimaryBtn(
                        btnText: AppStrings.letsBegin,
                        onTap: () => redirectUserToLoginPage(),
                        textStyle: TextStyleHelper.mediumHeading,
                      ),
            ),
          )
          : RedirectToLoginScreen();
    }
  }
}

class RedirectToLoginScreen extends StatefulWidget {
  const RedirectToLoginScreen({super.key});

  @override
  State<RedirectToLoginScreen> createState() => _RedirectToLoginScreenState();
}

class _RedirectToLoginScreenState extends State<RedirectToLoginScreen> {
  late Timer _timer;
  int _secondsLeft = 5;

  @override
  void initState() {
    super.initState();

    // start countdown + redirect
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 1) {
        timer.cancel();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(isToNavigateHome: true),
          ),
        );
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade700),
            const SizedBox(height: 16),
            CustomText(
              text: AppStrings.somethingWentWrong,
              style: TextStyleHelper.mediumText,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Redirecting to login in $_secondsLeft s',
              style: TextStyleHelper.mediumText,
            ),
          ],
        ),
      ),
    );
  }
}
