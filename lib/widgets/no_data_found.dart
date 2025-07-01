import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_image_strings.dart';
import '../app_const/app_strings.dart';
import 'custom_container.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({
    super.key,
    this.height,
    this.width,
    this.color,
    this.textStyle,
    this.text,
  });
  final double? height;
  final double? width;
  final Color? color;
  final TextStyle? textStyle;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      width: width ?? 80.w,
      height: height ?? 10.h,
      // borderRadius: BorderRadius.circular(10),
      // backGroundColor: color ?? AppColors.grey.withOpacity(0.5),
      child: CustomText(text: text ?? AppStrings.noDataFound),
    );
  }
}

class NoDataFoundIcon extends StatelessWidget {
  const NoDataFoundIcon({super.key, this.w, this.h, this.icon});
  final double? w;
  final double? h;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: w ?? 30.w,
            height: h ?? 15.h,
            child: Image.asset(icon ?? AppImageStrings.noDataFoundIcon),
          ),
          NoDataFoundWidget(),
        ],
      ),
    );
  }
}
