import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
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
                    assessmentProvider.submitAssessmentQuestions();
                  },
                ),
              )
              : null,
    );
  }
}

class QuestionWidget<T> extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AssessmentQuestion question;
  QuestionWidget({super.key, required this.question});
  final TextEditingController answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    answerController.text = question.selectedOption ?? "";
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
              textAlign: TextAlign.justify,
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
              ...question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value;
                    return RadioListTile<String>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: AppColors.primary,
                      selected: entry.value == question.selectedOption,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value: entry.value,
                      groupValue: question.selectedOption,
                      onChanged: (value) {
                        if (value != null) {
                          assessmentProvider.makeRadioSelection(
                            questionId: question.id ?? -1,
                            selection: entry.value,
                          );
                        }
                      },
                    );
                  }) ??
                  [SizedBox.shrink()],
            ] else if (question.type == "text") ...[
              SizeHelper.height(height: 1.h),
              CustomTextFormField(
                controller: answerController,
                maxLines: 1,
                maxLength: 200,
                validator:
                    (value) => ValidatorHelper.validateValue(
                      value: value,
                      context: context,
                    ),
              ),
            ] else if (question.type == "textArea") ...[
              SizeHelper.height(height: 1.h),
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: CustomTextFormField(
                  controller: answerController,
                  maxLines: 5,
                  maxLength: 500,
                  validator: (value) {
                    final validate = ValidatorHelper.validateValue(
                      value: value,
                      context: context,
                    );
                    if (validate == null) {
                      assessmentProvider.textAreaAnswer(
                        questionId: question.id ?? -1,
                        selection: answerController.text,
                      );
                    }
                    return validate;
                  },
                ),
              ),
            ] else ...[
              CustomText(text: AppStrings.somethingWentWrong),
            ],
          ],
        ),
      ),
    );
  }
}
