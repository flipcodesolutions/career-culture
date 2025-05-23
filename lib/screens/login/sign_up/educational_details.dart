import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/widgets/custom_radio_question_widget_wtih_heading.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';
import '../../../provider/user_provider/sign_up_provider.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';

class EducationalDetails extends StatelessWidget {
  EducationalDetails({super.key});
  final AssessmentQuestion question = AssessmentQuestion(
    question: AppStrings.areYouWorking,
    extractedOptions: ["Yes", "No"],
  );
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Form(
            key: signUpProvider.thirdPageFormKey,
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      duration: Duration(milliseconds: 500),
                      horizontalOffset: 30.w,
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
                  if (!signUpProvider.isUpdatingProfile)
                    CustomText(
                      text: AppStrings.shareYourEducationalDetails,
                      style: TextStyleHelper.smallText,
                    ),
                  if (!signUpProvider.isUpdatingProfile)
                    SizeHelper.height(height: 5.h),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      maxLines: 5,
                      hintText: AppStrings.nameOfDegree,
                      labelText: AppStrings.presentORLastStudy,
                      controller: signUpProvider.presentOrLastStudy,
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
                      labelText: AppStrings.collegeOrUniversity,
                      hintText: AppStrings.nameOfCollegeOrUniversity,
                      controller: signUpProvider.collegeOrUniversity,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    child: RadioQuestionWidgetWithHeading(
                      question: signUpProvider.areYouWorking,
                      onChanged:
                          (value) => signUpProvider.setWorking(working: value),
                    ),
                  ),
                  SizeHelper.height(),
                  if (signUpProvider.areYouWorking.answer?.toLowerCase() ==
                      "yes") ...[
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: CustomTextFormField(
                        maxLines: 5,
                        labelText: AppStrings.companyOrBusiness,
                        hintText: AppStrings.nameOfCompanyOrBusiness,
                        controller: signUpProvider.companyOrBusiness,
                        validator:
                            (value) =>
                                signUpProvider.areYouWorking.answer
                                            ?.toLowerCase() ==
                                        "yes"
                                    ? ValidatorHelper.validateValue(
                                      value: value,
                                      context: context,
                                    )
                                    : null,
                      ),
                    ),
                    SizeHelper.height(),
                  ],
                  if (!signUpProvider.isUpdatingProfile) ...[
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: CustomTextFormField(
                        labelText: AppStrings.referCode,
                        hintText: AppStrings.enterReferCodeIfAny,
                        controller: signUpProvider.referCode,
                        // keyboardType: TextInputType.numberWithOptions(),
                        adaptiveTextSelectionToolbarChildren: [],
                        maxLength: 6,
                        validator:
                            (value) =>
                                signUpProvider.referCode.text.isNotEmpty
                                    ? ValidatorHelper.validateValue(
                                      value: value,
                                      context: context,
                                      // lengthToCheck: 8,
                                    )
                                    : null,
                      ),
                    ),
                    SizeHelper.height(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
