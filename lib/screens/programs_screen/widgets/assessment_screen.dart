import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/method_helpers/image_picker_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../models/assessment_question_model/assessment_question_model.dart';
import 'dart:async';
import 'dart:io';
import '../../../provider/programs_provider/post_provider/post_provider.dart';
import '../../../utils/navigation_helper/navigation_helper.dart';
import '../../../widgets/audio_record_container.dart';
import 'assessment_result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({
    super.key,
    required this.postName,
    this.isInReviewMode = false,
  });
  final String postName;
  final bool isInReviewMode;
  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with NavigateHelper {
  bool isMedia = false;
  bool isTestDone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isTestDone = widget.isInReviewMode;
    AssessmentProvider assessmentProvider = context.read<AssessmentProvider>();
    Future.microtask(() {
      assessmentProvider.getAssessmentQuestionsByPostId(
        context: context,
        isInReviewMode: widget.isInReviewMode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AssessmentProvider assessmentProvider =
        context.watch<AssessmentProvider>();
    final PostProvider postProvider = context.watch<PostProvider>();
    // Non-media questions (text, multiple choice, etc.)
    bool isQuestions =
        assessmentProvider.assessmentQuestions?.data?.any(
          (e) => assessmentProvider.mediaTypes.contains(e.type) != true,
        ) ==
        true;

    ///
    final List<AssessmentQuestion>? mediaList =
        assessmentProvider.assessmentQuestions?.data
            ?.where(
              (e) => assessmentProvider.mediaTypes.contains(e.type) != true,
            )
            .toList();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          assessmentProvider.resetTest();
          pop(context, result: isTestDone);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // title: CustomText(
          //   text: AppStrings.assessment,
          //   style: TextStyleHelper.mediumHeading,
          // ),
          shape: Border(bottom: BorderSide(color: AppColors.white)),
        ),
        body:
            assessmentProvider.isLoading
                ? Center(child: CustomLoader())
                : isQuestions
                ? SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              child: FadeInAnimation(child: widget),
                            ),
                        children: [
                          /// assessment heading
                          CustomContainer(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: AppStrings.assessment,
                              style: TextStyleHelper.largeHeading.copyWith(
                                color: AppColors.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          CustomContainer(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: AppStrings.level1QuizTest,
                              style: TextStyleHelper.smallText.copyWith(
                                color: AppColors.blackShade75,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizeHelper.height(),
                          QuestionRowAndColumInfoWithIcon(
                            heading1:
                                "${mediaList?.length ?? 0} ${AppStrings.questions}",
                            heading2: AppStrings.multipleChoiceAnswer,
                            icon: Icons.question_mark_outlined,
                          ),
                          SizeHelper.height(height: 1.h),
                          QuestionRowAndColumInfoWithIcon(
                            heading1: assessmentProvider.point.toString(),
                            heading2: AppStrings.perQuestion,
                            icon: Icons.checklist_rtl_rounded,
                          ),
                          SizeHelper.height(height: 1.h),
                          Divider(),
                          CustomContainer(
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  Column(
                                    children: List.generate(
                                      mediaList?.length ?? 0,
                                      (index) {
                                        AssessmentQuestion? item =
                                            mediaList?[index];
                                        if (!isMedia && item?.type == "video" ||
                                            item?.type == "audio" ||
                                            item?.type == "image") {
                                          isMedia = true;
                                        }
                                        return QuestionWidget(
                                          isInReviewMode: widget.isInReviewMode,
                                          question:
                                              item ?? AssessmentQuestion(),
                                          questionIndex: index + 1,
                                        );
                                      },
                                    ),
                                  ),
                                  if (!assessmentProvider.isTestStarted &&
                                      !widget.isInReviewMode)
                                    ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5.0,
                                          sigmaY: 5.0,
                                        ),
                                        child: CustomContainer(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : CustomContainer(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  width: 90.w,
                  height: 80.h,
                  child: NoDataFoundWidget(),
                ),
        bottomNavigationBar:
            isQuestions
                ? CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  child: PrimaryBtn(
                    btnText:
                        /// if widget is build for review we assume the test is done or when user finish test on success will update it to
                        isTestDone
                            ? AppStrings.testCompleted
                            : !assessmentProvider.isTestStarted
                            ? AppStrings.startTheTest
                            : AppStrings.submitAnswer,
                    onTap:
                        isTestDone
                            ? null
                            : () {
                              /// logic to submit after finishing all questions
                              assessmentProvider.isTestStarted
                                  ? finishTest(
                                    assessmentProvider: assessmentProvider,
                                    ctx: context,
                                  )
                                  : assessmentProvider.startTest();
                            },
                  ),
                )
                : null,
      ),
    );
  }

  void finishTest({
    required AssessmentProvider assessmentProvider,
    required BuildContext ctx,
  }) async {
    bool isTestCompleted = await assessmentProvider.finishTest();
    if (isTestCompleted) {
      setState(() {
        isTestDone = true;
      });
      push(
        context: ctx,
        widget: AssessmentResultScreen(
          postName: widget.postName,
          isAssessmentPhase2: false,
        ),
        transition: FadeForwardsPageTransitionsBuilder(),
      );
    }
  }
}

/// will be used to render the info about assessment on screen with heading info and icon using Row and Column
class QuestionRowAndColumInfoWithIcon extends StatelessWidget {
  const QuestionRowAndColumInfoWithIcon({
    super.key,
    required this.heading1,
    required this.heading2,
    required this.icon,
    this.listOfHeading2 = const [],
  });
  final IconData icon;
  final String heading1;
  final String heading2;
  final List<String> listOfHeading2;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          CustomContainer(
            borderColor: AppColors.darkBlue,
            shape: BoxShape.circle,
            child: Icon(icon, color: AppColors.darkBlue),
          ),
          SizeHelper.width(width: 5.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(text: heading1, style: TextStyleHelper.smallHeading),
              CustomText(
                text: heading2,
                style: TextStyleHelper.smallText.copyWith(
                  color: AppColors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              ...listOfHeading2.map(
                (e) => CustomText(
                  text: e,
                  style: TextStyleHelper.smallText.copyWith(
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuestionWidget<T> extends StatefulWidget {
  final AssessmentQuestion question;
  final int questionIndex;
  final bool isInReviewMode;
  QuestionWidget({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.isInReviewMode,
  });

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
              text: "Question - ${widget.questionIndex}",
              style: TextStyleHelper.smallText.copyWith(
                color: AppColors.blackShade75,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizeHelper.height(height: 0.5.h),
            CustomText(
              useOverflow: false,
              text: "${widget.question.question?.trim()}",
              style: TextStyleHelper.smallHeading,
              // textAlign: TextAlign.justify,
            ),
            SizeHelper.height(height: 0.5.h),
            if (widget.question.type == "checkbox") ...[
              ...widget.question.extractedOptions?.asMap().entries.map((entry) {
                    String option = entry.value.trim();

                    return OptionTile(
                      option: option,
                      isSelected:
                          widget.question.userAnswer?.contains(entry.value) ??
                          false,
                      isCorrect:
                          widget.question.correctAnswer?.contains(option) ==
                          true,
                      isReviewMode: widget.isInReviewMode,
                      isMultiSelect: true,
                      onCheckboxToggled: (value) {
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

                    return OptionTile(
                      option: option,
                      isSelected: widget.question.userAnswer == option,
                      isCorrect:
                          widget.question.correctAnswer?.contains(option) ==
                          true,
                      isReviewMode: widget.isInReviewMode,
                      isMultiSelect: false,
                      onRadioSelected: (value) {
                        if (value.isNotEmpty) {
                          assessmentProvider.makeRadioSelection(
                            questionId: widget.question.id ?? -1,
                            selection: option,
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
                decoration: BorderHelper.containerLikeTextField(
                  hintText: AppStrings.yourAnswer,
                ),
                maxLines: 1,
                maxLength: 200,
                validator: (value) {
                  final validate = ValidatorHelper.validateValue(value: value);
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
                decoration: BorderHelper.containerLikeTextField(
                  hintText: AppStrings.yourAnswer,
                ),
                minLines: 5,
                maxLines: 5,
                maxLength: 500,
                validator: (value) {
                  final validate = ValidatorHelper.validateValue(value: value);
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
              Form(
                key: assessmentProvider.videoTextFieldKey,
                autovalidateMode: AutovalidateMode.always,
                child: CustomTextFormField(
                  controller: answerController,
                  decoration: BorderHelper.containerLikeTextField(
                    hintText: AppStrings.yourVideoUrl,
                  ),
                  maxLines: 1,
                  maxLength: 200,
                  onChanged:
                      (value) =>
                          ValidatorHelper.validateYoutubeLink(value: value),
                  validator: (value) {
                    final validate = ValidatorHelper.validateYoutubeLink(
                      value: value,
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
              ),
            ] else if (widget.question.type == "audio") ...[
              CustomContainer(
                child: AudioRecorderPlayer(questionId: widget.question.id),
              ),
            ] else if (widget.question.type == "image") ...[
              SizeHelper.height(height: 1.h),
              PickImage(question: widget.question),
            ] else ...[
              CustomText(text: AppStrings.somethingWentWrong),
            ],
          ],
        ),
      ),
    );
  }
}

class PickImage extends StatefulWidget {
  const PickImage({super.key, required this.question});
  final AssessmentQuestion question;
  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
    final AssessmentProvider assessmentProvider =
        context.watch<AssessmentProvider>();
    List<PlatformFile> files =
        assessmentProvider.assessmentQuestions?.data
            ?.firstWhere((e) => e.id == widget.question.id)
            .selectedFiles ??
        [];

    return InkWell(
      onTap:
          () =>
              files.isEmpty
                  ? ImagePickerHelper.showImagePicker(
                    context,
                    (image) async => assessmentProvider.makeFilesSelection(
                      questionId: widget.question.id ?? -1,
                      maxFileSize: 2,
                      selectedFiles: [
                        await ImagePickerHelper.convertFileToPlatformFile(
                          image ?? File(""),
                        ),
                      ],
                    ),
                  )
                  : null,
      child: CustomContainer(
        height: 20.h,
        width: 90.w,
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.lightWhite,
        child:
            files.isEmpty
                ? Center(
                  child: Icon(
                    Icons.cloud_upload,
                    color: AppColors.primary,
                    size: AppSize.size50,
                  ),
                )
                : Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.memory(files.first.bytes ?? Uint8List(0)),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          files.clear();
                          assessmentProvider.clearFilesSelection(
                            questionId: widget.question.id ?? -1,
                          );
                        },
                        icon: Icon(Icons.cancel, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

/// A reusable option tile for both radio (single-select) and checkbox (multi-select) questions,
/// supporting input and review modes with correct/incorrect highlighting.
class OptionTile extends StatelessWidget {
  final String option;
  final bool isSelected; // whether user selected this option
  final bool isCorrect; // whether this option is a correct answer
  final bool isReviewMode; // whether we are in review mode
  final bool isMultiSelect; // true = checkbox, false = radio
  final ValueChanged<String>? onRadioSelected;
  final ValueChanged<bool?>? onCheckboxToggled;

  const OptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isReviewMode,
    required this.isMultiSelect,
    this.onRadioSelected,
    this.onCheckboxToggled,
  });

  @override
  Widget build(BuildContext context) {
    // Determine tile background color
    Color? bgColor;
    if (isReviewMode) {
      if (isCorrect) {
        bgColor = AppColors.lightPrimary; // e.g. correct highlight
      } else if (isSelected && !isCorrect) {
        bgColor = AppColors.errorShade100; // wrong selection highlight
      }
    } else {
      if (isSelected) {
        bgColor = AppColors.lightGrey;
      }
    }

    return CustomContainer(
      backGroundColor: bgColor,
      margin: EdgeInsets.symmetric(vertical: 8),
      borderColor: AppColors.lightGrey,
      borderWidth: 0.5,
      borderRadius: BorderRadius.circular(AppSize.size10),
      child:
          isMultiSelect
              ? CheckboxListTile(
                contentPadding: EdgeInsets.only(left: 5.w),
                controlAffinity: ListTileControlAffinity.trailing,
                dense: true,
                activeColor:
                    isReviewMode ? AppColors.primary : AppColors.secondary,
                title: CustomText(text: option, useOverflow: false),
                value: isSelected,
                onChanged: isReviewMode ? null : onCheckboxToggled,
              )
              : RadioListTile<String>(
                contentPadding: EdgeInsets.only(left: 5.w),
                controlAffinity: ListTileControlAffinity.trailing,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                dense: true,
                activeColor:
                    isReviewMode ? AppColors.primary : AppColors.secondary,
                title: CustomText(text: option, useOverflow: false),
                value: option,
                groupValue: isSelected ? option : null,
                onChanged:
                    isReviewMode ? null : (_) => onRadioSelected?.call(option),
              ),
    );
  }
}
