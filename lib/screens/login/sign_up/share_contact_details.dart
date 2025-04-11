import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../widgets/custom_text_form_field.dart';

class ShareContactDetails extends StatefulWidget {
  const ShareContactDetails({super.key});

  @override
  State<ShareContactDetails> createState() => _ShareContactDetailsState();
}

class _ShareContactDetailsState extends State<ShareContactDetails> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    horizontalOffset: 30.w,
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                SizeHelper.height(height: 5.h),
                CustomText(
                  text: AppStrings.shareContactDetails,
                  style: TextStyleHelper.largeHeading,
                ),
                SizeHelper.height(height: 3.h),
                CustomText(
                  text: AppStrings.shareContactDetailsToContinue,
                  style: TextStyleHelper.smallText,
                ),
                SizeHelper.height(height: 5.h),
                CustomTextFieldWithAnimatedIconForVerification(
                  isVerified: false,
                  label: AppStrings.email,
                  controller: TextEditingController(),
                ),
                SizeHelper.height(),
                CustomTextFieldWithAnimatedIconForVerification(
                  isVerified: false,
                  label: AppStrings.contactNo1,
                  controller: TextEditingController(),
                ),
                SizeHelper.height(),
                CustomTextFieldWithAnimatedIconForVerification(
                  isVerified: false,
                  label: AppStrings.contactNo2,
                  controller: TextEditingController(),
                ),
                SizeHelper.height(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWithAnimatedIconForVerification extends StatelessWidget {
  const CustomTextFieldWithAnimatedIconForVerification({
    super.key,
    required this.isVerified,
    required this.label,
    this.validator,
    required this.controller,
    this.onTap,
  });
  final TextEditingController? controller;
  final String label;
  final bool isVerified;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: CustomTextFormField(
        labelText: label,
        controller: controller,
        validator:
            validator ??
            (value) =>
                ValidatorHelper.validateValue(value: value, context: context),
        suffix: GestureDetector(
          onTap: onTap,
          child: CustomContainer(
            width: 10.w,
            alignment: Alignment.center,
            child: AnimatedCrossFade(
              firstChild: Icon(Icons.verified_outlined, color: AppColors.grey),
              secondChild: Icon(Icons.verified, color: AppColors.primary),
              crossFadeState:
                  isVerified
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ),
    );
  }
}
