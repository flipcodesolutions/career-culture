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

  /// check if provided link is valid video only link
  static String? validateYoutubeLink({required String? value}) {
    if (value == null || value.trim().isEmpty) return null;

    final trimmed = value.trim();

    // Reject music domain explicitly
    if (trimmed.contains('music.youtube.com')) {
      return 'Music links are not supported';
    }

    Uri? uri;
    try {
      uri = Uri.parse(trimmed);
    } catch (_) {
      return 'Please enter a valid YouTube URL';
    }

    // Allow only these domains
    const allowedDomains = [
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
      'youtu.be',
    ];
    if (!allowedDomains.contains(uri.host)) {
      return 'Please enter a valid YouTube link';
    }

    final videoId = _extractYoutubeVideoId(uri);
    final isValidPlaylist = _isYoutubePlaylist(uri);

    // Check RD/OLAK and similar music playlist types
    final playlistId = uri.queryParameters['list'];
    final isMusicPlaylist =
        playlistId != null &&
        playlistId.startsWith(RegExp(r'(RD|OLAK|MU|RDEM|RDAMVM)'));

    if (isMusicPlaylist) {
      return 'YouTube Music links are not supported';
    }

    if (videoId != null || isValidPlaylist) return null;

    return 'Please enter a valid YouTube link';
  }

  /// get youtube video id
  static String? _extractYoutubeVideoId(Uri uri) {
    if (uri.host == 'youtu.be') {
      final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      return _isValidVideoId(id) ? id : null;
    }

    if (uri.queryParameters.containsKey('v')) {
      final id = uri.queryParameters['v'];
      return _isValidVideoId(id) ? id : null;
    }

    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      final p = segments[0];
      if (['embed', 'v', 'shorts'].contains(p)) {
        final id = segments[1];
        return _isValidVideoId(id) ? id : null;
      }
    }

    return null;
  }

  /// check if link is valid youtube playlist
  static bool _isYoutubePlaylist(Uri uri) {
    final playlistId = uri.queryParameters['list'];
    return uri.path == '/playlist' &&
        playlistId != null &&
        playlistId.length > 10;
  }

  ///
  static bool _isValidVideoId(String? id) {
    final validIdPattern = RegExp(r'^[\w-]{11}$');
    return id != null && validIdPattern.hasMatch(id);
  }

  static String? validateDateFormate({required String? value}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.needProperDateFormate;
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

  static String? validateOtp({required String? value}) {
    if (value?.trim().isEmpty == true) {
      return "Please Provide A OTP";
    }
    if ((value?.trim().length ?? 0) < 4) {
      return "Please Enter A Valid OTP !!";
    }
    return null;
  }
}
