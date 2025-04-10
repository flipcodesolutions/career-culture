import 'package:flutter/material.dart';
import '../../app_const/app_colors.dart';
import '../text_style_helper/text_style_helper.dart';

class BorderHelper {
  /// outlinedBorder
  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 0.5, color: AppColors.black),
  );
  static OutlineInputBorder inputBorderFocused = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: AppColors.primary),
  );
  static OutlineInputBorder inputBorderError = OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: AppColors.error),
  );
  static OutlineInputBorder inputBorderDisabled = OutlineInputBorder(
    borderSide: BorderSide(width: 0.3, color: AppColors.grey),
  );

  /// textField
  static InputDecoration textFormFieldPrimary({
    String? label,
    required String hintText,
    Widget? suffix,
  }) => InputDecoration(
    // suffix: suffix,
    suffixIcon: suffix,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    floatingLabelStyle: TextStyleHelper.mediumHeading.copyWith(
      color: AppColors.primary,
    ),
    border: inputBorder,
    labelText: label, // Placeholder label, can be customized
    hintText: hintText,
    fillColor: AppColors.white,
    filled: true,
    enabledBorder: inputBorder,
    focusedBorder: inputBorderFocused,
    errorBorder: inputBorderError,
    disabledBorder: inputBorderDisabled,
    focusedErrorBorder: inputBorderError,
    hintStyle: TextStyleHelper.smallText,
    errorStyle: TextStyle(color: AppColors.error), // Error text style
  );
}
