import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../models/assessment_question_model/assessment_question_model.dart';

class AssessmentScreen extends StatefulWidget {
  AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      AssessmentProvider assessmentProvider =
          context.read<AssessmentProvider>();
      assessmentProvider.getAssessmentQuestionsByPostId(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    bool isQuestions =
        assessmentProvider.assessmentQuestions?.data?.isNotEmpty == true;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.assessment,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          assessmentProvider.isLoading
              ? Center(child: CustomLoader())
              : isQuestions
              ? CustomListWidget(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                data:
                    assessmentProvider.assessmentQuestions?.data ??
                    <AssessmentQuestion>[],
                itemBuilder: (item, index) => QuestionWidget(question: item),
              )
              : Center(child: NoDataFoundWidget()),
      bottomNavigationBar:
          isQuestions
              ? CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: PrimaryBtn(
                  btnText: AppStrings.submit,
                  onTap: () {
                    /// logic to submit after finishing all questions
                  },
                ),
              )
              : null,
    );
  }
}

class QuestionWidget<T> extends StatelessWidget {
  final AssessmentQuestion question;
  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              useOverflow: false,
              text: question.question ?? "",
              style: TextStyleHelper.mediumHeading,
            ),
            if (question.type == "checkbox") ...[
              ...question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value;
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      selected: entry.value == question.selectedOption,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value:
                          question.selectedOption?.contains(entry.value) ??
                          false,
                      onChanged: (value) {
                        if (value != null) {
                          assessmentProvider.makeOptionSelection(
                            questionId: question.id ?? -1,
                            selection: entry.value,
                          );
                        }
                      },
                    );
                  }) ??
                  [SizedBox.shrink()],
            ] else if (question.type == "radio") ...[
              CustomText(text: question.type ?? ""),
            ] else if (question.type == "text") ...[
              CustomText(text: question.type ?? ""),
            ] else if (question.type == "textarea") ...[
              CustomText(text: question.type ?? ""),
            ] else ...[
              CustomText(text: AppStrings.somethingWentWrong),
            ],
          ],
        ),
      ),
    );
  }
}
