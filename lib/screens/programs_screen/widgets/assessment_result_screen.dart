import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_screen.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/media_assessment_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_image_strings.dart';
import '../../../app_const/app_strings.dart';
import '../../../widgets/custom_score_with_animation.dart';
import '../../../widgets/primary_btn.dart';
import 'package:screenshot/screenshot.dart';

class AssessmentResultScreen extends StatefulWidget {
  const AssessmentResultScreen({super.key, required this.postName});
  final String postName;
  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen>
    with NavigateHelper {
  final ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final AssessmentProvider assessmentProvider =
        context.read<AssessmentProvider>();
    final HomeScreenProvider homeScreenProvider =
        context.read<HomeScreenProvider>();
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: AppColors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                alignment: Alignment.center,
                child: CustomText(
                  text: AppStrings.congratulations,
                  style: TextStyleHelper.largeHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizeHelper.height(height: 1.h),
              CustomContainer(
                alignment: Alignment.center,
                child: CustomText(
                  text: AppStrings.youHaveCompletedAssessmentQuiz,
                  style: TextStyleHelper.xSmallText.copyWith(
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizeHelper.height(height: 1.h),
              CustomContainer(
                child: Stack(
                  children: [
                    Image.asset(
                      AppImageStrings.celebrationFirework,
                      height: 35.h,
                    ),
                    Image.asset(
                      AppImageStrings.assessmentResultTrophy,
                      fit: BoxFit.cover,
                      height: 35.h,
                      width: 100.w,
                    ),
                  ],
                ),
              ),
              SizeHelper.height(height: 1.h),

              /// name and user student id row
              // CustomContainer(
              //   margin: EdgeInsets.symmetric(horizontal: 5.w),
              //   child: UserNameAndUIdRow(),
              // ),
              SizeHelper.height(height: 3.h),

              /// create a user assessment score
              AssessmentScoreBoard(
                coins: assessmentProvider.coinsEarned(),
                score: assessmentProvider.noOfCorrectAnswer(),
                time: assessmentProvider.totalTimeOfTest(),
                totalCoins:
                    "${int.parse(homeScreenProvider.overAllScoreModel?.data?.totalPoints.toString() ?? "0") + int.parse(assessmentProvider.coinsEarned())}",
              ),
              SizeHelper.height(height: 5.h),

              /// review and share score btn
              CustomContainer(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(AppSize.size30),
                      onTap:
                          () => push(
                            context: context,
                            widget: AssessmentScreen(
                              postName: widget.postName,
                              isInReviewMode: true,
                            ),
                            transition: OpenUpwardsPageTransitionsBuilder(),
                          ),
                      child: CustomContainer(
                        width: 44.w,
                        height: 5.h,
                        borderRadius: BorderRadius.circular(AppSize.size30),
                        backGroundColor: AppColors.lightGrey,
                        child: Row(
                          children: [
                            Image.asset(
                              AppImageStrings.correctSign,
                              width: 10.w,
                              height: 3.h,
                            ),
                            SizeHelper.width(),
                            CustomText(
                              text: AppStrings.reviewAnswer,
                              style: TextStyleHelper.smallHeading,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(AppSize.size30),
                      onTap:
                          () => MethodHelper.shareAssessmentResultScreen(
                            screenShotController: screenshotController,
                          ),
                      child: CustomContainer(
                        width: 44.w,
                        height: 5.h,
                        borderRadius: BorderRadius.circular(AppSize.size30),
                        backGroundColor: AppColors.secondary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizeHelper.width(),
                            CustomText(
                              text: AppStrings.shareScore,
                              style: TextStyleHelper.smallHeading,
                            ),
                            Image.asset(
                              AppImageStrings.shareIcon,
                              width: 9.w,
                              height: 3.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomContainer(
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: PrimaryBtn(
            isIcon: true,
            icon: Image.asset(
              AppImageStrings.arrowRight2,
              width: 10.w,
              height: 3.h,
            ),
            btnText: AppStrings.nextLevel,
            onTap:
                () => push(
                  context: context,
                  widget: MediaAssessmentScreen(),
                  transition: FadeUpwardsPageTransitionsBuilder(),
                ),
          ),
        ),
      ),
    );
  }
}

/// assessment board
class AssessmentScoreBoard extends StatelessWidget {
  const AssessmentScoreBoard({
    super.key,
    required this.coins,
    required this.score,
    required this.time,
    required this.totalCoins,
  });
  final String score;
  final String time;
  final String coins;
  final String totalCoins;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 15.h,
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      backGroundColor: AppColors.body2,
      borderRadius: BorderRadius.circular(AppSize.size10),
      boxShadow: ShadowHelper.scoreContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResultTileWithImage(
            icon: AppImageStrings.trophy,
            heading: AppStrings.score,
            score: score,
          ),
          VertDivider(),
          ResultTileWithImage(
            icon: AppImageStrings.timeIcon,
            heading: AppStrings.time,
            score: time,
          ),
          VertDivider(),
          ResultTileWithImage(
            icon: AppImageStrings.coin,
            heading: AppStrings.coins,
            score: coins,
            isAnimatedScore: true,
          ),
          VertDivider(),
          ResultTileWithImage(
            icon: AppImageStrings.coins,
            heading: AppStrings.totalCoins,
            score: totalCoins,
            isAnimatedScore: true,
          ),
        ],
      ),
    );
  }
}

// custom vert divider
class VertDivider extends StatelessWidget {
  const VertDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(endIndent: 1.h, indent: 1.h, width: 0.3.w);
  }
}

/// used to display some scores with
class ResultTileWithImage extends StatelessWidget {
  const ResultTileWithImage({
    super.key,
    required this.icon,
    required this.heading,
    required this.score,
    this.isAnimatedScore = false,
  });
  final String icon;
  final String heading;
  final String score;
  final bool isAnimatedScore;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, height: 5.h, width: 10.w),
          SizeHelper.height(height: 1.h),
          CustomText(text: heading),
          SizeHelper.height(height: 1.h),
          isAnimatedScore
              ? CustomAnimatedScore(
                score: score,
                textStyle: TextStyleHelper.smallHeading,
              )
              : CustomText(text: score, style: TextStyleHelper.smallHeading),
        ],
      ),
    );
  }
}
