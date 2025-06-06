import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_const/app_regex.dart';
import '../../app_const/app_strings.dart';
import '../navigation_helper/navigation_helper.dart';

class ValidatorHelper with NavigateHelper {
  //// validate mobile number
  static String? validateMobileNumber({
    required String? value,
    required BuildContext context,
    int? lengthToCheck = 10,
  }) {
    if (value?.isEmpty == true) {
      return AppStrings.numberRequired;
    }
    if ((value?.length ?? 0) != lengthToCheck) {
      return AppStrings.numberValidReq;
    }
    if (value?.contains(AppRegex.onlyDigitReg) == false) {
      return AppStrings.numberInvalid;
    }
    return null;
  }

  /// validate name of user
  static String? validateName({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      /// locale error text for no name
      return AppStrings.nameRequired;
    }
    if (value.length < 3) {
      /// locale error text for name char need 3
      return AppStrings.nameReq3Char;
    }
    return null;
  }

  /// validate email
  static String? validateEmail({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterEmail;
    }
    final emailRegex = AppRegex.emailReg;
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.nameReq3Char;
    }
    return null;
  }

  static String? validateValue({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterMessage;
    }
    return null;
  }

  static String? validateDateFormate({
    required String? value,
    required BuildContext context,
  }) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterMessage;
    }

    final trimmedValue = value.trim();

    // Validate pattern: DD-Mmm-YYYY (e.g., 05-Jan-2002)
    final regex = RegExp(r'^\d{2}-[A-Z][a-z]{2}-\d{4}$');
    if (!regex.hasMatch(trimmedValue)) {
      return AppStrings.needProperDateFormate;
    }

    // Validate actual date
    try {
      DateFormat('dd-MMM-yyyy').parseStrict(trimmedValue);
    } catch (e) {
      return AppStrings.needProperDateFormate;
    }

    return null; // Valid
  }
}
