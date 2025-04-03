import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_strings.dart';
import '../../../widgets/custom_container.dart';
import 'package:intl/intl.dart'; // Import for formatting

class DashBoardUserScoreWidget extends StatelessWidget {
  const DashBoardUserScoreWidget({
    super.key,
    required this.imageUrl,
    required this.score,
    this.scoreMessage,
    this.animationDuration = const Duration(seconds: 5),
  });
  final String imageUrl;
  final String score;
  final String? scoreMessage;
  final Duration animationDuration;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 90.w,
      height: 10.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      borderRadius: BorderRadius.circular(AppSize.size10),
      backGroundColor: AppColors.white,
      borderColor: AppColors.grey,
      borderWidth: 0.5,
      boxShadow: ShadowHelper.scoreContainer,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomContainer(
              child: CircleAvatar(
                maxRadius: AppSize.size30,
                backgroundImage: NetworkImage(imageUrl),
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
              margin: EdgeInsets.only(right: AppSize.size30),
              child: AppIcons.forwardArrow,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAnimatedScore extends StatelessWidget {
  const CustomAnimatedScore({
    super.key,
    required this.score,
    required this.animationDuration,
  });

  final String score;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    int targetScore = int.tryParse(score) ?? 0; // Convert score to int
    final formatter =
        NumberFormat.decimalPattern(); // Formatter for thousands separator
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: targetScore),
      duration: animationDuration,
      builder:
          (context, value, child) => CustomText(
            text: formatter.format(value), // Format number,
            style: TextStyleHelper.mediumHeading,
          ),
    );
  }
}
