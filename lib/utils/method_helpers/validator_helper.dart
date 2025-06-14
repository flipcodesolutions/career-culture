import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_const/app_regex.dart';
import '../../app_const/app_strings.dart';
import '../navigation_helper/navigation_helper.dart';

class ValidatorHelper with NavigateHelper {
  //// validate mobile number
  static String? validateMobileNumber({
    required String? value,
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
  static String? validateName({required String? value}) {
    if (value == null || value.trim().isEmpty) {
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
  static String? validateEmail({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.enterEmail;
    }
    final emailRegex = AppRegex.emailReg;
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.nameReq3Char;
    }
    return null;
  }

  static String? validateValue({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterMessage;
    }
    return null;
  }

  static String? validateYoutubeLink({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmedValue = value.trim();
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?' // Optional protocol
      r'(www\.|m\.)?' // Optional subdomain
      r'(youtube\.com|youtu\.be)\/' // Domain
      r'(watch\?v=|embed\/|v\/|shorts\/)?' // Path
      r'([\w\-]{11})' // Video ID (11 characters)
      r'([^\s]*)$', // Optional query string
      caseSensitive: false,
    );

    if (!youtubeRegex.hasMatch(trimmedValue)) {
      return 'Please enter a valid YouTube link';
    }

    return null; // Valid
  }

  static String? validateDateFormate({required String? value}) {
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
