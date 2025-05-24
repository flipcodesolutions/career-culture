import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_file_picker.dart';
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
  const AssessmentScreen({super.key, required this.postNameAndId});
  final String postNameAndId;
  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with WidgetsBindingObserver, ScreenTracker<AssessmentScreen> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'Assessment_${widget.postNameAndId}';
  @override
  bool get debug => false; // Enable debug logs

  bool isMedia = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssessmentProvider assessmentProvider = context.read<AssessmentProvider>();
    Future.microtask(() {
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
              ? Form(
                key: assessmentProvider.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              child: FadeInAnimation(child: widget),
                            ),
                        children: List.generate(
                          assessmentProvider
                                  .assessmentQuestions
                                  ?.data
                                  ?.length ??
                              0,
                          (index) {
                            AssessmentQuestion? item =
                                assessmentProvider
                                    .assessmentQuestions
                                    ?.data?[index];
                            if (!isMedia && item?.type == "video" ||
                                item?.type == "audio") {
                              isMedia = true;
                            }
                            return QuestionWidget(
                              question: item ?? AssessmentQuestion(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : Center(
                child: NoDataFoundWidget(text: AppStrings.noQuestionsFound),
              ),
      bottomNavigationBar:
          isQuestions
              ? CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: PrimaryBtn(
                  btnText: AppStrings.submit,
                  onTap: () {
                    /// logic to submit after finishing all questions
                    if (assessmentProvider.formKey.currentState?.validate() ==
                        true) {
                      assessmentProvider.submitAssessmentQuestions(
                        context: context,
                      );
                    } else {
                      WidgetHelper.customSnackBar(
                        // context: context,
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

class QuestionWidget<T> extends StatefulWidget {
  final AssessmentQuestion question;
  QuestionWidget({super.key, required this.question});

  @override
  State<QuestionWidget<T>> createState() => _QuestionWidgetState<T>();
}

class _QuestionWidgetState<T> extends State<QuestionWidget<T>> {
  final TextEditingController answerController = TextEditingController();

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
              text: widget.question.question?.trim() ?? "",
              style: TextStyleHelper.mediumHeading,
              // textAlign: TextAlign.justify,
            ),
            if (widget.question.type == "checkbox") ...[
              ...widget.question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value.trim();
                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      selected: entry.value == widget.question.answer,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value:
                          widget.question.answer?.contains(entry.value) ??
                          false,
                      onChanged: (value) {
                        if (value != null) {
                          assessmentProvider.makeOptionSelection(
                            questionId: widget.question.id ?? -1,
                            selection: entry.value,
                          );
                        }
                      },
                    );
                  }) ??
                  [SizedBox.shrink()],
            ] else if (widget.question.type == "radio") ...[
              ...widget.question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value.trim();
                    return RadioListTile<String>(
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: AppColors.primary,
                      selected: entry.value == widget.question.answer,
                      selectedTileColor: AppColors.lightWhite,
                      title: CustomText(text: option, useOverflow: false),
                      value: entry.value,
                      groupValue: widget.question.answer,
                      onChanged: (value) {
                        if (value != null) {
                          assessmentProvider.makeRadioSelection(
                            questionId: widget.question.id ?? -1,
                            selection: entry.value,
                          );
                        }
                      },
                    );
                  }) ??
                  [SizedBox.shrink()],
            ] else if (widget.question.type == "text") ...[
              SizeHelper.height(height: 1.h),
              CustomTextFormField(
                controller: answerController,
                maxLines: 1,
                maxLength: 200,
                validator: (value) {
                  final validate = ValidatorHelper.validateValue(
                    value: value,
                    context: context,
                  );
                  if (validate == null) {
                    assessmentProvider.textAreaAnswer(
                      questionId: widget.question.id ?? -1,
                      selection: answerController.text,
                    );
                  }
                  return validate;
                },
              ),
            ] else if (widget.question.type == "textArea") ...[
              SizeHelper.height(height: 1.h),
              CustomTextFormField(
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
                      questionId: widget.question.id ?? -1,
                      selection: answerController.text,
                    );
                  }
                  return validate;
                },
              ),
            ] else if (widget.question.type == "video") ...[
              SizeHelper.height(height: 1.h),
              CustomTextFormField(
                controller: answerController,
                maxLines: 1,
                maxLength: 200,
                validator: (value) {
                  final validate = ValidatorHelper.validateValue(
                    value: value,
                    context: context,
                  );
                  if (validate == null) {
                    assessmentProvider.textAreaAnswer(
                      questionId: widget.question.id ?? -1,
                      selection: answerController.text,
                    );
                  }
                  return validate;
                },
              ),
              // CustomFilePicker(
              //   questionId: widget.question.id ?? -1,
              //   allowMultiple: true,
              //   allowedExtensions: ["mp4", "mkv", "webp"],
              //   icon: AppIconsData.video,
              // ),
            ] else if (widget.question.type == "audio") ...[
              CustomFilePicker(
                questionId: widget.question.id ?? -1,
                allowMultiple: true,
                allowedExtensions: ["mp3", "ogg", "wav"],
                icon: AppIconsData.audio,
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
