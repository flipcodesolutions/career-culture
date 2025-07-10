import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/list_helper/list_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../widgets/custom_text.dart';
import '../shared_prefs_helper/shared_prefs_helper.dart';

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

  /// Clears user-related data from local storage (SharedPreferences),
  /// based on the set of keys defined in this method.
  ///
  /// This method is essentially the reverse of `_saveUserStorage`, `_saveUserProfileToLocalStorage`,
  /// `_saveUserEducationToLocalStorage`, and related save methods.
  ///
  /// It attempts to "reset" each field by overwriting it with an empty string, `false`, or other default value,
  /// rather than fully removing the key (you could optionally remove instead if needed).
  ///
  /// A [skipKeys] set can be passed to avoid clearing certain fields — for example,
  /// you may want to retain the user token or email during partial logout or soft reset flows.
  ///
  /// ### Example usage:
  /// ```dart
  /// await _clearUserStorage(
  ///   skipKeys: {
  ///     AppStrings.userToken, // retain token
  ///     AppStrings.userEmail, // retain email
  ///   },
  /// );
  /// ```
  ///
  /// This method is null-safe and does not use any force-unwrapping (!), avoiding potential runtime crashes.
  static Future<void> clearUserStorage({Set<String>? skipKeys}) async {
    skipKeys ??= {};

    final Map<String, Future<void> Function()> fieldsToClear = {
      AppStrings.userEmail:
          () => SharedPrefs.saveString(AppStrings.userEmail, ''),
      AppStrings.userName:
          () => SharedPrefs.saveString(AppStrings.userName, ''),
      AppStrings.userId: () => SharedPrefs.saveString(AppStrings.userId, ''),
      AppStrings.phone: () => SharedPrefs.saveString(AppStrings.phone, ''),
      AppStrings.isEmailVerified:
          () => SharedPrefs.saveString(AppStrings.isEmailVerified, 'no'),
      AppStrings.isContactVerified:
          () => SharedPrefs.saveString(AppStrings.isContactVerified, 'no'),
      AppStrings.role: () => SharedPrefs.saveString(AppStrings.role, ''),
      AppStrings.isApproved:
          () => SharedPrefs.saveString(AppStrings.isApproved, ''),
      AppStrings.status: () => SharedPrefs.saveString(AppStrings.status, ''),
      AppStrings.studentId:
          () => SharedPrefs.saveString(AppStrings.studentId, ''),
      AppStrings.id: () => SharedPrefs.saveString(AppStrings.id, ''),
      AppStrings.userApproved:
          () => SharedPrefs.saveString(AppStrings.userApproved, ''),
      AppStrings.myReferralCode:
          () => SharedPrefs.saveString(AppStrings.myReferralCode, ''),
      // AppStrings.userToken:
      //     () => SharedPrefs.saveString(AppStrings.userToken, ''),
      AppStrings.isNewUser:
          () => SharedPrefs.saveBool(AppStrings.isNewUser, false),

      // Profile
      AppStrings.images: () => SharedPrefs.saveString(AppStrings.images, ''),
      // AppStrings.userContactNo1:
      //     () => SharedPrefs.saveString(AppStrings.userContactNo1, ''),
      AppStrings.userContactNo2:
          () => SharedPrefs.saveString(AppStrings.userContactNo2, ''),
      AppStrings.userGender:
          () => SharedPrefs.saveString(AppStrings.userGender, ''),
      AppStrings.dateOfBirth:
          () => SharedPrefs.saveString(AppStrings.dateOfBirth, ''),
      AppStrings.addressLine1:
          () => SharedPrefs.saveString(AppStrings.addressLine1, ''),
      AppStrings.addressLine2:
          () => SharedPrefs.saveString(AppStrings.addressLine2, ''),
      AppStrings.userCity:
          () => SharedPrefs.saveString(AppStrings.userCity, ''),
      AppStrings.userState:
          () => SharedPrefs.saveString(AppStrings.userState, ''),
      AppStrings.userCountry:
          () => SharedPrefs.saveString(AppStrings.userCountry, ''),
      AppStrings.userDistrict:
          () => SharedPrefs.saveString(AppStrings.userDistrict, ''),

      // Education
      AppStrings.study: () => SharedPrefs.saveString(AppStrings.study, ''),
      AppStrings.degree: () => SharedPrefs.saveString(AppStrings.degree, ''),
      AppStrings.university:
          () => SharedPrefs.saveString(AppStrings.university, ''),
      AppStrings.workingStatus:
          () => SharedPrefs.saveString(AppStrings.workingStatus, ''),
      AppStrings.userNameOfCompanyOrBusiness:
          () => SharedPrefs.saveString(
            AppStrings.userNameOfCompanyOrBusiness,
            '',
          ),

      // Coordinator
      AppStrings.coordinatorId:
          () => SharedPrefs.saveString(AppStrings.coordinatorId, ''),

      // Flags
      AppStrings.isProfileDataIsEmpty:
          () => SharedPrefs.saveBool(AppStrings.isProfileDataIsEmpty, true),
      AppStrings.isUserEducationDataIsEmpty:
          () =>
              SharedPrefs.saveBool(AppStrings.isUserEducationDataIsEmpty, true),
    };

    for (final key in fieldsToClear.keys) {
      if (!skipKeys.contains(key)) {
        final action = fieldsToClear[key];
        if (action != null) {
          await action();
        }
      }
    }
  }
  /// get 
  static String alphabet({required int index}) {
    if (index < 0) {
      throw ArgumentError('Index must be a non-negative integer.');
    }
    String result = "";
    int base = ListHelper.alphabats.length; // Which is 26

    do {
      int remainder = index % base;
      result = ListHelper.alphabats[remainder] + result;
      index = (index ~/ base) - 1; // Integer division
    } while (index >= 0);
    return result;
  }
}
