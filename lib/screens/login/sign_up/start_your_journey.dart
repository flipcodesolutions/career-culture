import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_icons.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_radio_question_widget_wtih_heading.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'sign_up.dart';

class StartYourJourney extends StatelessWidget {
  StartYourJourney({super.key});
  final AssessmentQuestion question = AssessmentQuestion(
    question: AppStrings.gender,
    extractedOptions: [AppStrings.male, AppStrings.female],
  );
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
                  text: AppStrings.startYourJourney,
                  style: TextStyleHelper.largeHeading,
                ),
                SizeHelper.height(height: 3.h),
                CustomText(
                  text: AppStrings.createAnAccountToJoinUS,
                  style: TextStyleHelper.smallText,
                ),
                SizeHelper.height(height: 5.h),
                CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomTextFormField(
                    labelText: AppStrings.firstName,
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
                    labelText: AppStrings.middleName,
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
                    labelText: AppStrings.lastName,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                ),
                SizeHelper.height(),
                RadioQuestionWidgetWithHeading(
                  question: question,
                  onChanged: (value) => question.answer = value,
                ),
                SizeHelper.height(),
                CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomTextFormField(
                    labelText: AppStrings.birthDate,
                    suffix: CustomContainer(
                      width: 10.w,
                      child: GestureDetector(
                        child: AppIcons.calender,
                        onTap:
                            () => showDatePicker(
                              context: context,
                              firstDate: DateTime(1947),
                              lastDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                            ),
                      ),
                    ),
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                ),
                SizeHelper.height(),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: CustomText(
                        text: AppStrings.uploadPhoto,
                        style: TextStyleHelper.smallHeading,
                      ),
                    ),
                  ],
                ),
                SizeHelper.height(),
                CustomFilePickerV2(
                  allowMultiple: true,
                  allowedExtensions: ["jpg", "png", "jpeg"],
                  icon: AppIconsData.audio,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
