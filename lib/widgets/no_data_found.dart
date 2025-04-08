import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_strings.dart';
import 'custom_container.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({
    super.key,
    this.height,
    this.width,
    this.color,
    this.textStyle,
  });
  final double? height;
  final double? width;
  final Color? color;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      width: width ?? 80.w,
      height: height ?? 10.h,
      // borderRadius: BorderRadius.circular(10),
      // backGroundColor: color ?? AppColors.grey.withOpacity(0.5),
      child: CustomText(text: AppStrings.noDataFound),
    );
  }
}
