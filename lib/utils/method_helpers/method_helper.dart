import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_result_screen.dart';
import 'package:mindful_youth/screens/wall_screen/individual_wall_post_screen.dart';
import 'package:mindful_youth/screens/wall_screen/wall_screen.dart';
import 'package:mindful_youth/service/fcm_token_service/fcm_token_service.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../provider/wall_provider/wall_provider.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_text.dart';
import '../shared_prefs_helper/shared_prefs_helper.dart';
import '../widget_helper/widget_helper.dart';

class MethodHelper with NavigateHelper {
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
        return jsonString?.split('|').map((e) => e.trim()).toList() ?? [];
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
  static Future<void> saveUserInfoInLocale({
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
    print("AppStrings.userName ======> $userName");

    await SharedPrefs.saveString(AppStrings.userEmail, userEmail);
    print("AppStrings.userEmail ======> $userEmail");

    await SharedPrefs.saveString(AppStrings.isEmailVerified, isEmailVerified);
    print("AppStrings.isEmailVerified ======> $isEmailVerified");

    await SharedPrefs.saveString(
      AppStrings.isContactVerified,
      isContactVerified,
    );
    print("AppStrings.isContactVerified ======> $isContactVerified");

    await SharedPrefs.saveString(AppStrings.role, role);
    print("AppStrings.role ======> $role");

    await SharedPrefs.saveString(AppStrings.isApproved, isApproved);
    print("AppStrings.isApproved ======> $isApproved");

    await SharedPrefs.saveString(AppStrings.status, status);
    print("AppStrings.status ======> $status");

    await SharedPrefs.saveString(AppStrings.id, id);
    print("AppStrings.id ======> $id");

    await SharedPrefs.saveString(AppStrings.images, images);
    print("AppStrings.images ======> $images");

    await SharedPrefs.saveString(AppStrings.userId, userId);
    print("AppStrings.userId ======> $userId");

    await SharedPrefs.saveString(AppStrings.userContactNo1, userContactNo1);
    print("AppStrings.userContactNo1 ======> $userContactNo1");

    await SharedPrefs.saveString(AppStrings.userContactNo2, userContactNo2);
    print("AppStrings.userContactNo2 ======> $userContactNo2");

    await SharedPrefs.saveString(AppStrings.userGender, userGender);
    print("AppStrings.userGender ======> $userGender");

    await SharedPrefs.saveString(AppStrings.dateOfBirth, dateOfBirth);
    print("AppStrings.dateOfBirth ======> $dateOfBirth");

    await SharedPrefs.saveString(AppStrings.addressLine1, addressLine1);
    print("AppStrings.addressLine1 ======> $addressLine1");

    await SharedPrefs.saveString(AppStrings.addressLine2, addressLine2);
    print("AppStrings.addressLine2 ======> $addressLine2");

    await SharedPrefs.saveString(AppStrings.userCity, userCity);
    print("AppStrings.userCity ======> $userCity");

    await SharedPrefs.saveString(AppStrings.userState, userState);
    print("AppStrings.userState ======> $userState");

    await SharedPrefs.saveString(AppStrings.userCountry, userCountry);
    print("AppStrings.userCountry ======> $userCountry");

    await SharedPrefs.saveString(AppStrings.userDistrict, userDistrict);
    print("AppStrings.userDistrict ======> $userDistrict");

    await SharedPrefs.saveString(AppStrings.study, study);
    print("AppStrings.study ======> $study");

    await SharedPrefs.saveString(AppStrings.degree, degree);
    print("AppStrings.degree ======> $degree");

    await SharedPrefs.saveString(AppStrings.university, university);
    print("AppStrings.university ======> $university");

    await SharedPrefs.saveString(AppStrings.workingStatus, workingStatus);
    print("AppStrings.workingStatus ======> $workingStatus");

    await SharedPrefs.saveString(
      AppStrings.userNameOfCompanyOrBusiness,
      userNameOfCompanyOrBusiness,
    );
    print(
      "AppStrings.userNameOfCompanyOrBusiness ======> $userNameOfCompanyOrBusiness",
    );

    await SharedPrefs.saveString(AppStrings.userToken, userToken);
    print("AppStrings.userToken ======> $userToken");
  }

  /// remove strings
  static void removeLocaleStrings({required List<String> listOfStrings}) async {
    for (String i in listOfStrings) {
      SharedPrefs.removeSharedString(i);
    }
  }

  /// pick time
  static Future<String> selectBirthDateByDatePicker({
    required BuildContext context,
    String? initDate,
  }) async {
    DateTime? initialDate;
    try {
      // Try parsing the existing text to a DateTime
      initialDate = DateFormat('yyyy-MM-dd').parse(initDate ?? "");
    } catch (_) {
      // Fallback if parsing fails or text is empty
      initialDate = null;
    }
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1947),
      lastDate: DateTime(
        DateTime.now().year,

        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (date != null) {
      /// set the controller text in string like "1999-01-12"
      return formateDateInDdMmmYyyy(inputDate: date);
    } else {
      return "";
    }
  }

  /// convert date from [YYYY-MM-DD] to [DD-MMM-YYYY]
  static String formateDateInDdMmmYyyy({required DateTime inputDate}) {
    try {
      return DateFormat("dd-MMM-yyyy").format(inputDate);
    } catch (e) {
      return "";
    }
  }

  /// convert date from [DD-MMM-YYYY] to [YYYY-MM-DD]
  static String convertDateToBackendFormat(String inputDate) {
    try {
      DateTime date = DateFormat("dd-MMM-yyyy").parse(inputDate);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      return "";
    }
  }

  /// convert date from [YYYY-MM-DD] to [DD-MMM-YYYY]
  static String convertToDisplayFormat({required String inputDate}) {
    try {
      DateTime date = DateFormat("yyyy-MM-dd").parse(inputDate);
      return DateFormat("dd-MMM-yyyy").format(date);
    } catch (e) {
      return "";
    }
  }

  /// get fcm token

  static Future<void> getAndSendFcmTokenToBackend({
    required BuildContext context,
  }) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    String uId = await SharedPrefs.getSharedString(AppStrings.userId);
    print("user Id: $uId");

    // if (token != null && context.mounted && uId != "") {
    if (token != null && uId != "") {
      print("FCM Token: $token");
      FcmTokenService fcmTokenService = FcmTokenService();
      await fcmTokenService.sendFcmTokenWithUId(
        context: context,
        uId: uId,
        fcmToken: token,
      );
    }
  }

  redirectDeletedOrInActiveUserToLoginPage({
    required BuildContext context,
  }) async {
    pushRemoveUntil(
      context: context,
      widget: LoginScreen(isToNavigateHome: true),
    );
    await SharedPrefs.clearShared();
    WidgetHelper.customSnackBar(
      title: AppStrings.accountIsDeleted,
      isError: true,
    );
  }

  /// this method is used in [WallScreen] and [IndividualWallPostScreen] to implement share functionality of wall posts
  static void shareWallPost({required String slug}) async {
    /// share post
    ShareResult refer = await SharePlus.instance.share(
      ShareParams(
        uri: Uri.parse("${AppStrings.wallPostShareUrl}$slug"),
        title: 'Hey! Check out This Amazing Post',
      ),
    );
    if (refer.status == ShareResultStatus.success) {
      WidgetHelper.customSnackBar(title: AppStrings.inviteRequestSent);
    }
  }

  ///
  static void likeWallPost({
    required bool isLiked,
    required WallProvider wallProvider,
    required int postId,
    required bool isFromWallScreen,
    required BuildContext context,
  }) {
    isLiked
        ? wallProvider.likePost(
          wallId: postId,
          isFromWallScreen: isFromWallScreen,
          context: context,
        )
        : WidgetHelper.customSnackBar(
          title: AppStrings.pleaseLoginFirst,
          isError: true,
        );
  }

  /// extract time from iso time string using in [ScreenTracker]
  static String extractTime(String urlEncodedDateTime) {
    // Decode the URL-encoded timestamp
    String decoded = Uri.decodeComponent(urlEncodedDateTime);

    // Extract the time part from the decoded datetime string
    // Example input: "2025-05-29T14:05:55.819745"
    DateTime dateTime = DateTime.parse(decoded);

    // Format into "HH:mm:ss"
    String formattedTime =
        "${_twoDigits(dateTime.hour)}:"
        "${_twoDigits(dateTime.minute)}:"
        "${_twoDigits(dateTime.second)}";
    return formattedTime;
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  /// used in [AssessmentResultScreen] to display time taken by user to finish test
  static String formatTimeDifference(DateTime startTime, DateTime? finishTime) {
    if (finishTime == null) return "N/A";

    Duration diff = finishTime.difference(startTime);

    if (diff.inHours >= 1) {
      int hours = diff.inHours;
      int minutes = diff.inMinutes % 60;
      return "${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} hr";
    } else {
      int minutes = diff.inMinutes;
      int seconds = diff.inSeconds % 60;
      return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} min";
    }
  }

  //// its a ui builder for pick image source
  static Widget buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: AppSize.size60,
            height: AppSize.size60,
            shape: BoxShape.circle,
            backGroundColor: AppColors.grey.withOpacity(0.2),
            child: Icon(icon, size: 28, color: AppColors.secondary),
          ),
          SizedBox(height: AppSize.size10),
          CustomText(text: label),
        ],
      ),
    );
  }
  //
}
