import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
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
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/navigation_helper/navigation_helper.dart';
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
    int noQuestions = assessmentProvider.assessmentQuestions?.data?.length ?? 0;
    return Scaffold(
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
                            heading1: "$noQuestions ${AppStrings.questions}",
                            heading2: AppStrings.multipleChoiceAnswer,
                            icon: Icons.question_mark_outlined,
                          ),
                          SizeHelper.height(height: 1.h),
                          QuestionRowAndColumInfoWithIcon(
                            heading1: AppStrings.points10,
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
                                    children: List.generate(noQuestions, (
                                      index,
                                    ) {
                                      AssessmentQuestion? item =
                                          assessmentProvider
                                              .assessmentQuestions
                                              ?.data?[index];
                                      if (!isMedia && item?.type == "video" ||
                                          item?.type == "audio" ||
                                          item?.type == "image") {
                                        isMedia = true;
                                      }
                                      return QuestionWidget(
                                        isInReviewMode: widget.isInReviewMode,
                                        question: item ?? AssessmentQuestion(),
                                        questionIndex: index + 1,
                                      );
                                    }),
                                  ),
                                  if (!assessmentProvider.isTestStarted)
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
                  btnText:
                      !assessmentProvider.isTestStarted
                          ? AppStrings.startTheTest
                          : AppStrings.submitAnswer,
                  onTap: () {
                    /// logic to submit after finishing all questions
                    assessmentProvider.isTestStarted
                        ? finishTest(
                          assessmentProvider: assessmentProvider,
                          ctx: context,
                        )
                        : assessmentProvider.startTest();
                    // if (assessmentProvider.formKey.currentState?.validate() ==
                    //     true) {
                    //   assessmentProvider.submitAssessmentQuestions(
                    //     context: context,
                    //   );
                    // } else {
                    //   WidgetHelper.customSnackBar(
                    //     title: "Validation Failed",
                    //     isError: true,
                    //   );
                    // }
                  },
                ),
              )
              : null,
    );
  }

  void finishTest({
    required AssessmentProvider assessmentProvider,
    required BuildContext ctx,
  }) async {
    bool isTestCompleted = await assessmentProvider.finishTest();
    if (isTestCompleted) {
      push(context: ctx, widget: AssessmentResultScreen());
    } else {
      WidgetHelper.customSnackBar(title: AppStrings.somethingWentWrong);
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
  });
  final IconData icon;
  final String heading1;
  final String heading2;

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
                decoration: BorderHelper.containerLikeTextField(
                  hintText: AppStrings.yourAnswer,
                ),
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
                decoration: BorderHelper.containerLikeTextField(
                  hintText: AppStrings.yourVideoUrl,
                ),
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
              CustomContainer(
                alignment: Alignment.center,
                child: CustomText(text: "OR"),
              ),
              CustomContainer(
                child: AudioRecorderPlayer(questionId: widget.question.id),
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

class AudioRecorderPlayer extends StatefulWidget {
  final int? questionId;
  const AudioRecorderPlayer({super.key, required this.questionId});
  @override
  _AudioRecorderPlayerState createState() => _AudioRecorderPlayerState();
}

class _AudioRecorderPlayerState extends State<AudioRecorderPlayer> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  final int _maxFileSize = 5 * 1024 * 1024; // 5 MB
  StreamSubscription? _sizeMonitor;

  @override
  void initState() {
    super.initState();
    _recorder.openRecorder();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _sizeMonitor?.cancel();
    super.dispose();
  }

  Future<void> _startRecording({
    required AssessmentProvider assessmentProvider,
  }) async {
    bool permissionGranted = await Permission.microphone.request().isGranted;
    if (!permissionGranted) return;

    Directory tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/${DateTime.now().toIso8601String()}.aac';
    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
    setState(() => _isRecording = true);
    _monitorFileSize(assessmentProvider: assessmentProvider);
  }

  void _monitorFileSize({required AssessmentProvider assessmentProvider}) {
    _sizeMonitor = Stream.periodic(Duration(milliseconds: 500)).listen((
      _,
    ) async {
      if (_filePath == null) return;
      final file = File(_filePath!);
      if (await file.exists()) {
        final size = await file.length();
        if (size >= _maxFileSize) {
          _stopRecording(assessmentProvider: assessmentProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording stopped: Max size 5MB reached')),
          );
        }
      }
    });
  }

  Future<void> _stopRecording({
    required AssessmentProvider assessmentProvider,
  }) async {
    await _recorder.stopRecorder();
    _sizeMonitor?.cancel();
    // assessmentProvider.makeFilesSelection(
    //   questionId: widget.questionId ?? -1,
    //   selectedFiles: accepted,
    // );
    setState(() => _isRecording = false);
  }

  Future<void> _playRecording() async {
    if (_filePath == null || _isPlaying) return;
    await _player.startPlayer(
      fromURI: _filePath,
      whenFinished: () {
        setState(() => _isPlaying = false);
      },
    );
    setState(() => _isPlaying = true);
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    AssessmentProvider assessmentProvider = context.watch<AssessmentProvider>();
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 64,
              color: _isRecording ? Colors.red : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording ? 'Recording...' : 'Press to record (max 5MB)',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      () =>
                          _isRecording
                              ? _stopRecording(
                                assessmentProvider: assessmentProvider,
                              )
                              : _startRecording(
                                assessmentProvider: assessmentProvider,
                              ),
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  ),
                  label: Text(_isRecording ? 'Stop' : 'Record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _stopPlayback : _playRecording,
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Stop' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
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
