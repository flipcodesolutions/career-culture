import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

import '../../../app_const/app_image_strings.dart';
import '../../../app_const/app_strings.dart';

class AssessmentResultScreen extends StatefulWidget {
  const AssessmentResultScreen({super.key});

  @override
  State<AssessmentResultScreen> createState() => _AssessmentResultScreenState();
}

class _AssessmentResultScreenState extends State<AssessmentResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shape: Border(bottom: BorderSide(color: AppColors.white))),
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
          ],
        ),
      ),
    );
  }
}
