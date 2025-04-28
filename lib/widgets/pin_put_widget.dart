import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../utils/text_style_helper/text_style_helper.dart';

class CustomPinPut extends StatelessWidget {
  final TextEditingController controller;
  final double? width;
  final double? height;
  const CustomPinPut({
    super.key,
    required this.controller,
    this.height,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: controller,
      defaultPinTheme: PinTheme(
        width: width ?? 15.w,
        height: height ?? 8.h,
        decoration: BoxDecoration(
          color: AppColors.lightWhite,
          borderRadius: BorderRadius.circular(AppSize.size10),
          border: Border.all(color: AppColors.primary),
        ),
        textStyle: TextStyleHelper.largeHeading,
      ),
    );
  }
}
