import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../models/assessment_question_model/assessment_question_model.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class RadioQuestionWidgetWithHeading extends StatelessWidget {
  const RadioQuestionWidgetWithHeading({
    super.key,
    required this.question,
    required this.onChanged,
  });

  final AssessmentQuestion question;
  final void Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: question.question ?? "",
            style: TextStyleHelper.smallHeading,
          ),
          ...question.extractedOptions?.asMap().entries.map((entry) {
                String option = entry.value;
                return RadioListTile<String>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: AppColors.primary,
                  selected: entry.value == question.answer,
                  selectedTileColor: AppColors.lightWhite,
                  title: CustomText(text: option, useOverflow: false),
                  value: entry.value,
                  groupValue: question.answer,
                  onChanged: onChanged,
                );
              }) ??
              [],
        ],
      ),
    );
  }
}
