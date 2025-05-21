import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
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
    required this.userId,
  });
  final String score;
  final String? scoreMessage;
  final Duration animationDuration;
  final String userId;
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return GestureDetector(
      onTap:
          () => push(
            context: context,
            widget: ScoreboardPage(),
            transition: FadeSlidePageTransitionsBuilder(),
          ),
      child: CustomContainer(
        width: 90.w,
        // height: 10.h,
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
                shape: BoxShape.circle,
                child:
                    signUpProvider.signUpRequestModel.images?.isNotEmpty == true
                        ? CustomImageWithLoader(
                          fit: BoxFit.contain,
                          width: 15.w,
                          height: 8.h,
                          imageUrl:
                              "${AppStrings.assetsUrl}${signUpProvider.signUpRequestModel.images}",
                        )
                        : Icon(
                          Icons.star_rate_rounded,
                          size: AppSize.size40,
                          color: AppColors.secondary,
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
                    CustomText(
                      text: signUpProvider.firstName.text,
                      style: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    CustomText(
                      text: "UId : $userId",
                      style: TextStyleHelper.smallText.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    CustomAnimatedScore(
                      score: score,
                      animationDuration: animationDuration,
                    ),
                    CustomText(text: scoreMessage ?? AppStrings.yourCoins),
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
