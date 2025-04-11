import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';

class FamilyDetails extends StatelessWidget {
  const FamilyDetails({super.key});

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
                  text: AppStrings.familyDetails,
                  style: TextStyleHelper.largeHeading,
                ),
                SizeHelper.height(height: 3.h),
                CustomText(
                  text: AppStrings.shareYourPersonalAndFamilyDetails,
                  style: TextStyleHelper.smallText,
                ),
                SizeHelper.height(height: 5.h),
                CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomTextFormField(
                    labelText: AppStrings.nativePlace,
                    controller: TextEditingController(),
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
                    maxLines: 5,
                    labelText: AppStrings.currentLocation,
                    controller: TextEditingController(),
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
                    maxLines: 5,
                    labelText: AppStrings.familyDetails,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                ),
                SizeHelper.height(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
