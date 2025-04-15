import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
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
}
