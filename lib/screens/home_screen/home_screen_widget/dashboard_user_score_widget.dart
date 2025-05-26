import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_profile_pic_circle.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/user_name_and_userid.dart';
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
    required this.userName,
    required this.onTap,
  });
  final String score;
  final String? scoreMessage;
  final Duration animationDuration;
  final String userId;
  final String userName;
  final void Function()? onTap;
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
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.lightWhite,
        borderColor: AppColors.grey,
        borderWidth: 0.5,
        boxShadow: ShadowHelper.scoreContainer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserNameAndUIdRow(),
            SizeHelper.height(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomUserProfilePicCircle(
                  isPhotoString:
                      signUpProvider.signUpRequestModel.images?.isNotEmpty ==
                      true,
                  photoLink: signUpProvider.signUpRequestModel.images,
                ),
                SizeHelper.width(width: 5.w),
                CustomContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAnimatedScore(
                        score: score,
                        animationDuration: animationDuration,
                      ),
                      CustomText(text: scoreMessage ?? AppStrings.yourCoins),
                    ],
                  ),
                ),
                Spacer(),
                CustomContainer(
                  padding: EdgeInsets.all(5),
                  width: 10.w,
                  height: 4.h,
                  child: Image.asset(AppImageStrings.arrowRight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
