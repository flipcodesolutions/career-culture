import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
import 'package:mindful_youth/models/login_model/sent_otp_model.dart';
import 'package:mindful_youth/models/login_model/user_signup_confirm_model.dart';
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
        WidgetHelper.customSnackBar(
          context: context,
          title: model.message ?? "",
        );
        return model;
      }
      return null;
    } catch (e) {
      log("error while sending email otp => $e");
      return null;
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
        WidgetHelper.customSnackBar(
          context: context,
          title: model.message ?? "",
        );
        return model;
      }
      return null;
    } catch (e) {
      log("error while sending mobile otp => $e");
      return null;
    }
  }

  /// verify mobile otp
  Future<UserModel?> verifyMobileOtp({
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
        UserModel model = UserModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log("error while verify mobile otp => $e");
      return null;
    }
  }
}
