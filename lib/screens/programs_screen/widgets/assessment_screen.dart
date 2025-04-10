import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_file_picker.dart';
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
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isMedia = false;
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
                itemBuilder: (item, index) {
                  if (!isMedia && item.type == "video" ||
                      item.type == "audio") {
                    isMedia = true;
                  }
                  return QuestionWidget(question: item, formKey: formKey);
                },
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
                    if (formKey.currentState?.validate() == true) {
                      if (isMedia &&
                          assessmentProvider.assessmentQuestions?.data?.any(
                                (e) => e.selectedFiles?.isEmpty == true,
                              ) ==
                              true) {
                        WidgetHelper.customSnackBar(
                          context: context,
                          title: "Some Media missing",
                          isError: true,
                        );
                      } else {
                        WidgetHelper.customSnackBar(
                          context: context,
                          title: "Success And Ready",
                        );
                      }
                      assessmentProvider.submitAssessmentQuestions(
                        context: context,
                      );
                    } else {
                      WidgetHelper.customSnackBar(
                        context: context,
                        title: "Validation Failed",
                        isError: true,
                      );
                    }
                  },
                ),
              )
              : null,
    );
  }
}

class QuestionWidget<T> extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AssessmentQuestion question;
  QuestionWidget({super.key, required this.question, required this.formKey});
  final TextEditingController answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    answerController.text = question.answer ?? "";
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
              // textAlign: TextAlign.justify,
            ),
            if (question.type == "checkbox") ...[
              ...question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value;
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      selected: entry.value == question.answer,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value: question.answer?.contains(entry.value) ?? false,
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
                      selected: entry.value == question.answer,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value: entry.value,
                      groupValue: question.answer,
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
                  minLines: 5,
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
            ] else if (question.type == "video") ...[
              CustomFilePicker(
                questionId: question.id ?? -1,
                allowMultiple: true,
                allowedExtensions: ["mp4", "mkv", "webp"],
                icon: AppIconsData.video,
              ),
            ] else if (question.type == "audio") ...[
              CustomFilePicker(
                questionId: question.id ?? -1,
                allowMultiple: true,
                allowedExtensions: ["mp3", "ogg", "wav"],
                icon: AppIconsData.audio,
              ),
            ] else ...[
              CustomText(text: AppStrings.somethingWentWrong),
            ],
            // Divider(color: AppColors.grey.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
