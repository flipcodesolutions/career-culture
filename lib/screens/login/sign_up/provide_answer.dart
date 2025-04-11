import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_screen.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_text.dart';

class ProvideAnswer extends StatelessWidget {
  const ProvideAnswer({super.key});
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
                  text: AppStrings.provideAnswers,
                  style: TextStyleHelper.largeHeading,
                ),
                SizeHelper.height(height: 3.h),
                CustomText(
                  text: AppStrings.giveAnswerOfTheseQuestions,
                  style: TextStyleHelper.smallText,
                ),
                SizeHelper.height(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: QuestionWidget(
                    question: AssessmentQuestion(
                      question: "Do You Ever Feel Stressed?",
                      type: "radio",
                      options: "Yes | No",
                      extractedOptions: ["Yes", "No"],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: QuestionWidget(
                    question: AssessmentQuestion(
                      question: "Are You Happy With Your Life?",
                      type: "radio",
                      options: "Yes , No",
                      extractedOptions: ["Yes", "No"],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: QuestionWidget(
                    question: AssessmentQuestion(
                      question: "Do You Need Help?",
                      type: "radio",
                      options: "Yes | No",
                      extractedOptions: ["Yes", "No"],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: QuestionWidget(
                    question: AssessmentQuestion(
                      question: "Do You Need Help?",
                      type: "radio",
                      options: "Yes | No",
                      extractedOptions: ["Yes", "No"],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: QuestionWidget(
                    question: AssessmentQuestion(
                      question: "Do You Need Help?",
                      type: "radio",
                      options: "Yes | No",
                      extractedOptions: ["Yes", "No"],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
