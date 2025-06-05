import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import '../../app_const/app_colors.dart';
import '../../widgets/custom_text.dart';

mixin WidgetHelper {
  // custom sizedBox for height
  SizedBox height(double height) {
    return SizedBox(height: height);
  }

  // custom sizedBox for width
  SizedBox width(double width) {
    return SizedBox(width: width);
  }

  // default pin put theme
  // PinTheme defaultPinTheme(BuildContext context) {
  //   return PinTheme(
  //     width: 12.w,
  //     height: 14.w,
  //     margin: EdgeInsets.symmetric(horizontal: 0.5.w),
  //     textStyle:
  //         TextStyleHelper.largeHeading.copyWith(color: AppColors.primaryColor),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: AppColors.primaryColor),
  //         borderRadius: BorderRadius.circular(10),
  //         color: AppColors.primaryLightColor.withOpacity(0.5)),
  //   );
  // }

  // bottom sheet divider
  SizedBox customBottomSheetDivider() {
    return SizedBox(width: 9.w, child: Divider(thickness: 0.5.h));
  }

  // show dialog
  static customSnackBar({
    required String title,
    Color? color,
    bool? isError,
    bool autoClose = true,
  }) {
    toastification.dismissAll();
    if (isError ?? false) {
      toastification.show(
        icon: SizedBox.shrink(),
        borderSide: BorderSide(color: color ?? AppColors.black),
        primaryColor: color,
        applyBlurEffect: true,
        foregroundColor: AppColors.white,
        type: ToastificationType.error,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: autoClose ? Duration(seconds: 5) : null,
        showProgressBar: autoClose,
        dragToClose: true,
        title: CustomText(text: title),
        closeButton: closeBtnBuilderForToastification(),
      );
    } else {
      toastification.show(
        applyBlurEffect: true,
        foregroundColor: AppColors.white,
        backgroundColor: color ?? AppColors.white,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        showProgressBar: autoClose,
        autoCloseDuration: autoClose ? Duration(seconds: 5) : null,
        alignment: Alignment.bottomCenter,
        title: CustomText(text: title),
        closeButton: closeBtnBuilderForToastification(),
      );
    }
  }

  /// used for showing close btn in snackbar
  static ToastCloseButton closeBtnBuilderForToastification() {
    return ToastCloseButton(
      showType: CloseButtonShowType.always,
      buttonBuilder:
          (context, onClose) => CustomContainer(
            child: GestureDetector(
              onTap: onClose,
              child: Icon(Icons.cancel, color: AppColors.white),
            ),
          ),
    );
  }
}
