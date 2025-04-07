import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../models/assessment_question_model/assessment_question_model.dart';

class AssessmentScreen extends StatelessWidget {
  AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.assessment,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: CustomListWidget(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        data: assessmentProvider.assessmentQuestions ?? <QuestionModel>[],
        itemBuilder:
            (item, index) => QuestionWidget(
              question: item,
              selectedIndex: assessmentProvider.answerSelection(
                questionId: item.id,
              ),
              onAnswerSelected:
                  (answer) => assessmentProvider.updateAnswerSelection(
                    selectedIndex: answer,
                    questionId: item.id,
                  ),
            ),
      ),
      bottomNavigationBar: CustomContainer(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: PrimaryBtn(
          btnText: AppStrings.submit,
          onTap: () {
            /// logic to submit after finishing all questions
          },
        ),
      ),
    );
  }
}

class QuestionWidget<T> extends StatelessWidget {
  final QuestionModel question;
  final Function(int) onAnswerSelected;
  final int selectedIndex;
  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              useOverflow: false,
              text: "${question.id}. ${question.questionText}",
              style: TextStyleHelper.mediumHeading,
            ),
            ...question.options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              return RadioListTile<int>(
                activeColor: AppColors.primary,
                selected: index == selectedIndex,
                selectedTileColor: AppColors.lightWhite,
                title: CustomText(text: option, useOverflow: false),
                value: index,
                groupValue: question.selectedAnswer,
                onChanged: (value) {
                  if (value != null) onAnswerSelected(value);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
