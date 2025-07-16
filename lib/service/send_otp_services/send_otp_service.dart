import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
import 'package:mindful_youth/models/login_model/sent_otp_model.dart';
import 'package:mindful_youth/models/login_model/verify_otp_model.dart';
// import 'package:mindful_youth/models/login_model/user_signup_confirm_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';

class SendOtpService {
  Future<SendEmailOtpModel?> sendEmailOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.sendEmailOtp,
        context: context,
        body: {"email": email},
      );
      if (response.isNotEmpty) {
        SendEmailOtpModel model = SendEmailOtpModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log("error while sending email otp => $e");
      return null;
    }
  }

  /// verify mobile otp
  Future<bool> verifyEmailOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.verifyOtpOfEmail,
        context: context,
        body: {"email": email, "otp": otp},
      );
      if (response.isNotEmpty) {
        return response['data']['isEmailVerify'];
      }
      return false;
    } catch (e) {
      log("error while verify email otp => $e");
      return false;
    }
  }

  Future<SentOtpModel?> sendMobileOtp({
    required BuildContext context,
    required String contactNo,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.sentOtpToMobile,
        context: context,
        body: {"contactNo": contactNo},
      );
      if (response.isNotEmpty) {
        SentOtpModel model = SentOtpModel.fromJson(response);
        WidgetHelper.customSnackBar(title: model.message ?? "");
        return model;
      }
      return null;
    } catch (e) {
      log("error while sending mobile otp => $e");
      return null;
    }
  }

  /// verify mobile otp
  Future<OtpVerifyModel?> verifyMobileOtp({
    required BuildContext context,
    required String contactNo,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.verifyOtpOfMobile,
        context: context,
        body: {"contactNo": contactNo, "otp": otp},
      );
      if (response.isNotEmpty) {
        // OtpVerifyModel model = OtpVerifyModel.fromJson(response);
        // return model.data?.isNewUser ?? false;
        return OtpVerifyModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log("error while verify mobile otp => $e");
      return null;
    }
  }
}
