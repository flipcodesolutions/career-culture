import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_result_screen.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_strings.dart';
import '../../../provider/assessment_provider/assessment_provider.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/navigation_helper/navigation_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/cutom_loader.dart';
import 'assessment_screen.dart';

class MediaAssessmentScreen extends StatefulWidget {
  const MediaAssessmentScreen({super.key, required this.shouldPop3});
  final bool shouldPop3;
  @override
  State<MediaAssessmentScreen> createState() => _MediaAssessmentScreenState();
}

class _MediaAssessmentScreenState extends State<MediaAssessmentScreen>
    with NavigateHelper {
  bool isTestDone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssessmentProvider assessmentProvider = context.read<AssessmentProvider>();
    Future.microtask(() {
      assessmentProvider.getAssessmentQuestionsByPostId(
        context: context,
        isInReviewMode: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AssessmentProvider assessmentProvider =
        context.watch<AssessmentProvider>();
    //// get question and filter out for audio , video and audio
    final List<AssessmentQuestion>? mediaList =
        assessmentProvider.assessmentQuestions?.data
            ?.where(
              (e) =>
                  e.type == "image" || e.type == "video" || e.type == "audio",
            )
            .toList();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          assessmentProvider.resetTest();
          pop(context, result: isTestDone);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: AppColors.white)),
        ),
        body: SafeArea(
          child:
              assessmentProvider.isLoading
                  ? Center(child: CustomLoader())
                  : mediaList?.isNotEmpty == true
                  ? SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
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
                                text: AppStrings.level2ActivitySubmission,
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
                              heading2: AppStrings.uploadMediaAnswer,
                              icon: Icons.question_mark_outlined,
                            ),
                            Divider(),
                            CustomContainer(
                              child: Form(
                                key: assessmentProvider.videoTextFieldKey,
                                autovalidateMode: AutovalidateMode.always,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    mediaList?.length ?? 0,
                                    (index) {
                                      mediaList?[index];
                                      return QuestionWidget(
                                        isInReviewMode: false,
                                        question:
                                            mediaList?[index] ??
                                            AssessmentQuestion(),
                                        questionIndex: index + 1,
                                      );
                                    },
                                  ),
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
        ),
        bottomNavigationBar: SafeArea(
          child: CustomContainer(
            margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            child: PrimaryBtn(
              btnText: AppStrings.submitAnswer,
              onTap: () async {
                final bool success = await assessmentProvider
                    .submitAssessmentMediaQuestions(context: context);
                if (success) {
                  if (!context.mounted) return;
                  final bool success = await push(
                    context: context,
                    widget: AssessmentResultScreen(
                      postName: "",
                      isAssessmentPhase2: true,
                    ),
                  );

                  /// this will determine if the page should pop once or 3 times
                  if (success) {
                    widget.shouldPop3
                        ? {
                          pop(context, result: success),
                          pop(context, result: success),
                          pop(context, result: success),
                        }
                        : pop(context, result: success);
                    assessmentProvider.emptyAssessmentQuestions();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
