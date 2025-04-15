import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
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

class _ShareContactDetailsState extends State<ShareContactDetails>
    with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Form(
            key: signUpProvider.secondPageFormKey,
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
                    isVerified: signUpProvider.isEmailVerified,
                    label: AppStrings.email,
                    controller: signUpProvider.email,
                    validator:
                        (value) => ValidatorHelper.validateEmail(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),
                  CustomTextFieldWithAnimatedIconForVerification(
                    isVerified: signUpProvider.isContactNo1Verified,
                    label: AppStrings.contactNo1,
                    controller: signUpProvider.contactNo1,
                    validator:
                        (value) => ValidatorHelper.validateMobileNumber(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),
                  CustomTextFieldWithAnimatedIconForVerification(
                    isVerified: false,
                    label: AppStrings.contactNo2,
                    controller: signUpProvider.contactNo2,
                    validator:
                        (value) =>
                            signUpProvider.contactNo2.text.isEmpty
                                ? null
                                : ValidatorHelper.validateMobileNumber(
                                  value: value,
                                  context: context,
                                ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.address1,
                      controller: signUpProvider.address1,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.address2,
                      controller: signUpProvider.address2,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.city,
                      controller: signUpProvider.city,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.state,
                      controller: signUpProvider.state,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.country,
                      controller: signUpProvider.country,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.district,
                      controller: signUpProvider.district,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                ],
              ),
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
