import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPasswordScreen>
    with NavigateHelper {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassNotVisible = true;
  @override
  Widget build(BuildContext context) {
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
                        text: AppStrings.forgetPassword,
                        style: TextStyleHelper.largeText.copyWith(
                          color: AppColors.white,
                          fontSize: 23.sp,
                        ),
                      ),
                      SizeHelper.height(),
                      CustomText(
                        useOverflow: false,
                        text: AppStrings.enterYourEmailToResetYourPassword,
                        style: TextStyleHelper.smallText.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizeHelper.height(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomTextFormField(
                    controller: emailOrPhoneController,
                    labelText: AppStrings.email,
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                ),
                SizeHelper.height(height: 5.h),
                PrimaryBtn(
                  width: 90.w,
                  textStyle: TextStyleHelper.mediumHeading,
                  btnText: AppStrings.continue_,
                  onTap: () {},
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
