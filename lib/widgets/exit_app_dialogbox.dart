import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';

class ExitAppDialog extends StatelessWidget with NavigateHelper {
  const ExitAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size20),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => ScaleAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                CustomText(
                  text: AppStrings.areYouSureWantToExit,
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizeHelper.height(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryBtn(
                      width: 30.w,
                      btnText: AppStrings.cancel,
                      onTap: () => pop(context),
                    ),
                    PrimaryBtn(
                      borderColor: AppColors.error,
                      backGroundColor: AppColors.error,
                      width: 30.w,
                      btnText: AppStrings.exit,
                      textStyle: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.white,
                      ),
                      onTap: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
