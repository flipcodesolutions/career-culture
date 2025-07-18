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
  // for container like border
  static OutlineInputBorder containerLikeBorder({
    required double borderRadius,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide.none, // No visible border
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

  /// ✅ Rounded, no-border container-style text field
  static InputDecoration containerLikeTextField({
    required String hintText,
    Widget? suffix,
    Color fillColor = const Color(0xFFF5F5F5), // light grey background
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 14,
    ),
    double borderRadius = 12.0,
  }) => InputDecoration(
    hintText: hintText,
    suffixIcon: suffix,
    filled: true,
    fillColor: fillColor,
    contentPadding: contentPadding,
    border: containerLikeBorder(borderRadius: borderRadius),
    enabledBorder: containerLikeBorder(borderRadius: borderRadius),
    focusedBorder: containerLikeBorder(borderRadius: borderRadius),
    errorBorder: containerLikeBorder(borderRadius: borderRadius),
    disabledBorder: containerLikeBorder(borderRadius: borderRadius),
    hintStyle: TextStyleHelper.smallText.copyWith(color: AppColors.grey),
  );

  static noBorder({String? hintText}) => InputDecoration(
    border: InputBorder.none,
    hintText: hintText,
    hintStyle: TextStyleHelper.smallText.copyWith(color: AppColors.lightGrey),
  );
}
