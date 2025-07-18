import 'package:flutter/material.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_result_screen.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
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
  int currentPage = 0;
  final PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssessmentProvider assessmentProvider = context.read<AssessmentProvider>();
    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() {
          currentPage = newPage;
        });
      }
    });
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
                  ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.size20,
                            vertical: AppSize.size20,
                          ),
                          backGroundColor: AppColors.counselingBoxV2,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                            ],
                          ),
                        ),
                        SizeHelper.height(height: 1.h),
                        Expanded(
                          child: CustomContainer(
                            constraints: BoxConstraints.tightForFinite(
                              height: 45.h,
                            ),
                            child: Form(
                              key: assessmentProvider.videoTextFieldKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: mediaList?.length ?? 0,
                                itemBuilder: (context, index) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0) ...[
                  Expanded(
                    child: PrimaryBtn(
                      btnText: "Prev",
                      onTap:
                          () => pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.linear,
                          ),
                    ),
                  ),
                  SizeHelper.width(),
                ],
                Expanded(
                  child: PrimaryBtn(
                    btnText:
                        currentPage == ((mediaList?.length ?? 1) - 1)
                            ? AppStrings.submitAnswer
                            : "Next",
                    onTap:
                        currentPage != ((mediaList?.length ?? 1) - 1)
                            ? () => pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            )
                            : () async {
                              final bool success = await assessmentProvider
                                  .submitAssessmentMediaQuestions(
                                    context: context,
                                  );
                              if (success) {
                                if (!context.mounted) return;
                                final bool navSuccess = await push(
                                  context: context,
                                  widget: AssessmentResultScreen(
                                    postName: "",
                                    isAssessmentPhase2: true,
                                  ),
                                );

                                /// this will determine if the page should pop once or 3 times
                                if (navSuccess) {
                                  setState(
                                    () => isTestDone = true,
                                  ); // ✅ set flag

                                  widget.shouldPop3
                                      ? {
                                        pop(context, result: navSuccess),
                                        pop(context, result: navSuccess),
                                        pop(context, result: navSuccess),
                                      }
                                      : pop(context, result: navSuccess);

                                  assessmentProvider.emptyAssessmentQuestions();
                                }
                              }
                            },
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
