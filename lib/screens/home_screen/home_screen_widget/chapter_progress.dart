import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../utils/method_helpers/shadow_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_animated_circular_progress.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class ChapterProgressWidget extends StatelessWidget {
  const ChapterProgressWidget({
    super.key,
    required this.imageUrl,
    required this.chapter,
    required this.description,
    required this.progressPercent,
  });
  final String imageUrl;
  final String chapter;
  final String description;
  final double progressPercent;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 90.w,
      height: 15.h,
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
              padding: EdgeInsets.symmetric(horizontal: AppSize.size10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
                child: CustomImageWithLoader(imageUrl: imageUrl),
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
                    text: chapter,
                    style: TextStyleHelper.mediumHeading,
                  ),
                  CustomText(text: description),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: CustomContainer(
              child: AnimatedCircularProgress(
                percentage: progressPercent, // Pass the desired percentage
                size: AppSize.size100, // Size of the widget
                color: AppColors.primary, // Progress color
                duration: Duration(seconds: 3), // Animation duration
              ),
            ),
          ),
        ],
      ),
    );
  }
}
