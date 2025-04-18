import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/user_provider/login_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';

import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.isNavigateHome});
  final bool isNavigateHome;
  @override
  State<OtpScreen> createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = context.watch<LoginProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: Duration(milliseconds: 350),
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    duration: Duration(milliseconds: 350),
                    horizontalOffset: 20.w,
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 350),
                      child: widget,
                    ),
                  ),
              children: [
                CustomContainer(
                  padding: EdgeInsets.only(left: 5.w, right: 20.w),
                  alignment: Alignment.centerLeft,
                  height: 30.h,
                  width: 100.w,
                  backGroundColor: AppColors.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        useOverflow: false,
                        text: AppStrings.verifyOtp,
                        style: TextStyleHelper.largeText.copyWith(
                          color: AppColors.white,
                          fontSize: 23.sp,
                        ),
                      ),
                      SizeHelper.height(),
                      CustomText(
                        useOverflow: false,
                        text: AppStrings.youWillReceiveOtpSoon,
                        style: TextStyleHelper.smallText.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizeHelper.height(height: 5.h),
                Pinput(
                  controller: loginProvider.otpController,
                  defaultPinTheme: PinTheme(
                    width: 20.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightWhite,
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      border: Border.all(color: AppColors.primary),
                    ),
                    textStyle: TextStyleHelper.largeHeading,
                  ),
                ),
                SizeHelper.height(height: 5.h),
                loginProvider.isLoading
                    ? Center(child: CustomLoader())
                    : PrimaryBtn(
                      width: 90.w,
                      textStyle: TextStyleHelper.mediumHeading,
                      btnText: AppStrings.verifyOtp,
                      onTap:
                          () async => loginProvider.verifyOtpToMobileNumber(
                            context: context,
                            isNavigateHome: widget.isNavigateHome,
                          ),
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Divider(
        color: AppColors.primary,
        thickness: 3,
        endIndent: 30.w,
        indent: 30.w,
      ),
    );
  }
}
