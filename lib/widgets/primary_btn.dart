import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../utils/text_style_helper/text_style_helper.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    super.key,
    this.height,
    this.width,
    this.backGroundColor,
    this.borderRadius,
    required this.btnText,
    this.textStyle,
    required this.onTap,
    this.borderColor,
    this.borderWidth,
    this.isIcon = false,
    this.isLeft = false,
    this.icon,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.mainAxisSize = MainAxisSize.max,
    this.iconFlex = 1,
    this.textFlex = 9,
  });
  final double? width;
  final double? height;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final String btnText;
  final TextStyle? textStyle;
  final void Function()? onTap;
  final Color? borderColor;
  final double? borderWidth;
  final bool isIcon;
  final bool isLeft;
  final Widget? icon;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final int textFlex;
  final int iconFlex;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 80.w,
      height: height ?? 6.h,
      child: MaterialButton(
        onPressed: onTap,
        elevation: 0,
        color: backGroundColor ?? AppColors.secondary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? AppColors.secondary,
            width: borderWidth ?? 1,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(AppSize.size10),
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          mainAxisSize: mainAxisSize,
          children: [
            if (isIcon && isLeft)
              Expanded(flex: iconFlex, child: icon ?? SizedBox.shrink()),
            isIcon
                ? Expanded(
                  flex: 9,
                  child: CustomContainer(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: btnText,
                      maxLines: 1,
                      useOverflow: true,
                      style:
                          textStyle ??
                          TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.black,
                          ),
                    ),
                  ),
                )
                : CustomText(
                  text: btnText,
                  maxLines: 1,
                  useOverflow: true,
                  style:
                      textStyle ??
                      TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.black,
                      ),
                ),
            if (isIcon && !isLeft)
              Expanded(flex: iconFlex, child: icon ?? SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
