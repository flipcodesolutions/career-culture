import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_image_strings.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/navigation_helper/transitions/fade_slide_from_belove.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_score_with_animation.dart';
import '../score_page.dart'; // Import for formatting

class DashBoardUserScoreWidget extends StatelessWidget with NavigateHelper {
  const DashBoardUserScoreWidget({
    super.key,
    required this.score,
    this.scoreMessage,
    this.animationDuration = const Duration(seconds: 3),
  });
  final String score;
  final String? scoreMessage;
  final Duration animationDuration;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => push(
            context: context,
            widget: ScoreboardPage(),
            transition: FadeSlidePageTransitionsBuilder(),
          ),
      child: CustomContainer(
        width: 90.w,
        height: 10.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.lightWhite,
        borderColor: AppColors.grey,
        borderWidth: 0.5,
        boxShadow: ShadowHelper.scoreContainer,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomContainer(
                child: Icon(
                  Icons.stars_rounded,
                  color: AppColors.secondary,
                  size: AppSize.size50,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: CustomContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAnimatedScore(
                      score: score,
                      animationDuration: animationDuration,
                    ),
                    CustomText(text: scoreMessage ?? AppStrings.yourScore),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomContainer(
                padding: EdgeInsets.all(5),
                width: 10.w,
                child: Image.asset(AppImageStrings.arrowRight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
