import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/list_helper/list_helper.dart';
import 'package:mindful_youth/widgets/custom_radio_question_widget_wtih_heading.dart';
import 'package:mindful_youth/widgets/new_custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: AnimationLimiter(
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
                CustomFormFieldContainer(
                  label: AppStrings.presentStudy,
                  icon: Icons.school,
                  errorText: signUpProvider.isPresentStudyErr,
                  child: CustomTextFormField(
                    maxLength: 50,
                    decoration: BorderHelper.noBorder(
                      hintText: AppStrings.nameOfPresentStudy,
                    ),
                    onChanged: (value) => signUpProvider.validatePresentStudy(),
                    controller: signUpProvider.presentStudy,
                    suggestions: ListHelper.degreesList,
                  ),
                ),
                SizeHelper.height(),
                CustomFormFieldContainer(
                  label: AppStrings.lastStudy,
                  errorText: signUpProvider.isLastStudyErr,
                  icon: Icons.school,
                  child: CustomTextFormField(
                    maxLength: 50,
                    decoration: BorderHelper.noBorder(
                      hintText: AppStrings.nameOfLastStudy,
                    ),
                    suggestions: ListHelper.degreesList,
                    controller: signUpProvider.lastStudy,
                    onChanged: (value) => signUpProvider.validateLastStudy(),
                  ),
                ),
                SizeHelper.height(),
                CustomFormFieldContainer(
                  label: AppStrings.collegeOrUniversity,
                  errorText: signUpProvider.isCollegeUniErr,
                  icon: Icons.school,
                  child: CustomTextFormField(
                    maxLines: 5,
                    decoration: BorderHelper.noBorder(
                      hintText: AppStrings.nameOfCollegeOrUniversity,
                    ),
                    controller: signUpProvider.collegeOrUniversity,
                    onChanged: (value) => signUpProvider.validateCollegeUni(),
                  ),
                ),
                SizeHelper.height(),
                RadioQuestionWidgetWithHeading(
                  padding: EdgeInsets.all(0),
                  question: signUpProvider.areYouWorking,
                  onChanged:
                      (value) => signUpProvider.setWorking(working: value),
                ),
                if (signUpProvider.isWorkingErr != null)
                  CustomContainer(
                    width: 90.w,
                    padding: const EdgeInsets.only(top: 5, left: 5),
                    child: CustomText(
                      text: signUpProvider.isWorkingErr ?? "",
                      style: TextStyleHelper.xSmallText.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                SizeHelper.height(),
                if (signUpProvider.areYouWorking.answer?.toLowerCase() ==
                    "yes") ...[
                  CustomFormFieldContainer(
                    label: AppStrings.companyOrBusiness,
                    errorText: signUpProvider.isCompanyOrBussinessErr,
                    icon: Icons.work,
                    child: CustomTextFormField(
                      maxLines: 3,
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.nameOfCompanyOrBusiness,
                      ),
                      controller: signUpProvider.companyOrBusiness,
                      onChanged:
                          (value) =>
                              signUpProvider.validateCompanyOrBussiness(),
                    ),
                  ),
                  SizeHelper.height(),
                ],
                if (!signUpProvider.isUpdatingProfile) ...[
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isReferCodeErr,
                    label: AppStrings.referCode,
                    icon: Icons.share,
                    child: CustomTextFormField(
                      labelText: AppStrings.referCode,
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.enterReferCodeIfAny,
                      ),
                      controller: signUpProvider.referCode,
                      maxLength: 6,
                      onChanged: (value) => signUpProvider.validateReferCode(),
                    ),
                  ),
                  SizeHelper.height(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
