import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../shared_prefs_helper/shared_prefs_helper.dart';

class MethodHelper {
  /// launch urls
  static Future<bool> launchUrlInBrowser({required String url}) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      print('❌ Invalid or unsupported URL: $url');
      return false;
    }

    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: BrowserConfiguration(showTitle: true),
        webViewConfiguration: WebViewConfiguration(
          enableDomStorage: true,
          enableJavaScript: true,
        ),
      );
      return true;
    } else {
      print('❌ Cannot launch URL: $url');
      return false;
    }
  }

  /// will extract options from string
  static List<String> parseOptions(String? jsonString) {
    try {
      if (jsonString?.isNotEmpty == true) {
        return jsonString?.split('|') ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to parse options: $e');
      return [];
    }
  }

  // Debounce function to prevent multiple API calls
  static void Function() debounce(
    VoidCallback action, {
    int milliseconds = 500,
  }) {
    Timer? _timer;

    return () {
      print('ksdnsjv');
      // Cancel any previous timer if it exists
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }

      // Start a new timer with a delay
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    };
  }

  static Widget buildFilePreview(PlatformFile file) {
    final mimeType = file.extension?.toLowerCase();

    if (mimeType == 'jpg' ||
        mimeType == 'jpeg' ||
        mimeType == 'png' ||
        mimeType == 'gif') {
      return Image.file(
        File(file.path!),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (mimeType == 'pdf') {
      return Icon(
        Icons.picture_as_pdf,
        color: AppColors.error,
        size: AppSize.size40,
      );
    } else if (mimeType == 'mp4' || mimeType == 'mov' || mimeType == 'avi') {
      return Icon(
        Icons.videocam,
        color: AppColors.primary,
        size: AppSize.size40,
      );
    } else if (mimeType == 'mp3' || mimeType == 'wav') {
      return Icon(
        Icons.audiotrack,
        color: AppColors.primary,
        size: AppSize.size40,
      );
    } else if (mimeType == 'doc' || mimeType == 'docx') {
      return Icon(
        Icons.description,
        color: AppColors.primary,
        size: AppSize.size40,
      );
    } else {
      return Icon(
        Icons.insert_drive_file,
        color: AppColors.primary,
        size: AppSize.size40,
      );
    }
  }

  //// user info in local storage
  //// user infos in local store
  static void saveUserInfoInLocale({
    required String userName,
    required String userEmail,
    required String isEmailVerified,
    required String isContactVerified,
    required String role,
    required String isApproved,
    required String status,
    required String id,
    required String images,
    required String userId,
    required String userContactNo1,
    required String userContactNo2,
    required String userGender,
    required String dateOfBirth,
    required String addressLine1,
    required String addressLine2,
    required String userCity,
    required String userState,
    required String userCountry,
    required String userDistrict,
    required String study,
    required String degree,
    required String university,
    required String workingStatus,
    required String userNameOfCompanyOrBusiness,
    required String userToken,
  }) async {
    await SharedPrefs.saveString(AppStrings.userName, userName);
    await SharedPrefs.saveString(AppStrings.userEmail, userEmail);
    await SharedPrefs.saveString(AppStrings.isEmailVerified, isEmailVerified);
    await SharedPrefs.saveString(
      AppStrings.isContactVerified,
      isContactVerified,
    );
    await SharedPrefs.saveString(AppStrings.role, role);
    await SharedPrefs.saveString(AppStrings.isApproved, isApproved);
    await SharedPrefs.saveString(AppStrings.status, status);
    await SharedPrefs.saveString(AppStrings.id, id);
    await SharedPrefs.saveString(AppStrings.images, images);
    await SharedPrefs.saveString(AppStrings.userId, userId);
    await SharedPrefs.saveString(AppStrings.userContactNo1, userContactNo1);
    await SharedPrefs.saveString(AppStrings.userContactNo2, userContactNo2);
    await SharedPrefs.saveString(AppStrings.userGender, userGender);
    await SharedPrefs.saveString(AppStrings.dateOfBirth, dateOfBirth);
    await SharedPrefs.saveString(AppStrings.addressLine1, addressLine1);
    await SharedPrefs.saveString(AppStrings.addressLine2, addressLine2);
    await SharedPrefs.saveString(AppStrings.userCity, userCity);
    await SharedPrefs.saveString(AppStrings.userState, userState);
    await SharedPrefs.saveString(AppStrings.userCountry, userCountry);
    await SharedPrefs.saveString(AppStrings.userDistrict, userDistrict);
    await SharedPrefs.saveString(AppStrings.study, study);
    await SharedPrefs.saveString(AppStrings.degree, degree);
    await SharedPrefs.saveString(AppStrings.university, university);
    await SharedPrefs.saveString(AppStrings.workingStatus, workingStatus);
    await SharedPrefs.saveString(
      AppStrings.userNameOfCompanyOrBusiness,
      userNameOfCompanyOrBusiness,
    );
    await SharedPrefs.saveString(AppStrings.userToken, userToken);
  }

  /// remove strings
  static void removeLocaleStrings({required List<String> listOfStrings}) async {
    for (String i in listOfStrings) {
      SharedPrefs.removeSharedString(i);
    }
  }
}
