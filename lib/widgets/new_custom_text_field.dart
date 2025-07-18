import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class CustomFormFieldContainer extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Widget child;
  final String? errorText;
  final void Function()? onLeadingTap;
  const CustomFormFieldContainer({
    super.key,
    this.icon,
    this.errorText,
    required this.label,
    required this.child,
    this.onLeadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(text: label, style: TextStyleHelper.smallText),
        SizeHelper.height(height: 1.h),
        CustomContainer(
          borderRadius: BorderRadius.circular(AppSize.size10),
          borderColor: AppColors.grey,
          borderWidth: 0.5,
          backGroundColor: AppColors.faqAnswer,
          // padding: EdgeInsets.all(5),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (icon != null)
                  InkWell(
                    onTap: onLeadingTap,
                    child: CustomContainer(
                      width: AppSize.size50,
                      backGroundColor: AppColors.darkPurple,
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: Icon(icon, color: Colors.white),
                    ),
                  ),
                SizeHelper.width(),
                Expanded(child: child),
              ],
            ),
          ),
        ),

        /// error display
        if (errorText?.trim().isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: CustomText(
              text: errorText ?? "",
              style: TextStyleHelper.xSmallText.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
