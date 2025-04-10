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

class EducationalDetails extends StatelessWidget {
  const EducationalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                SizeHelper.height(height: 5.h),
                CustomText(
                  text: AppStrings.educationalDetails,
                  style: TextStyleHelper.largeHeading,
                ),
                SizeHelper.height(height: 3.h),
                CustomText(
                  text: AppStrings.shareYourEducationalDetails,
                  style: TextStyleHelper.smallText,
                ),
                SizeHelper.height(height: 5.h),
                CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomTextFormField(
                    maxLines: 5,
                    labelText: AppStrings.education,
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
                    labelText: AppStrings.whatYouDoInFreeTime,
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
                    labelText: AppStrings.dreamWhatYouWantToBe,
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
