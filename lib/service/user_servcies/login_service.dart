import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/sent_otp_model.dart';
import 'package:mindful_youth/models/login_model/user_signup_confirm_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../provider/user_provider/user_provider.dart';

class LoginService {
  Future<UserModel?> loginUser({
    required BuildContext context,
    required UserProvider userProvider,
    required String emailOrPassword,
    required String password,
  }) async {
    try {
      var body = {"email": emailOrPassword, "password": password};
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.login,
        body: body,
        context: context,
      );
      if (response.isNotEmpty) {
        log(response.toString());
        UserModel model = UserModel.fromJson(response);
        if (model.success == true) {
          userProvider.setIsUserLoggedIn = true;
          SharedPrefs.saveToken(model.data?.token ?? "");
        }
        await SharedPrefs.saveToken(model.data?.token ?? "");
        return model;
      }
      return null;
    } catch (e) {
      log('error while loggin in user => $e');
      return null;
    }
  }

  ///
  Future<UserModel?> checkEmailExit({
    required BuildContext context,
    required String email,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.verifyEmail,
        context: context,
        body: {"email": email},
      );
      if (response.isNotEmpty) {
        UserModel model = UserModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log('error while checking email if exit => $e');
      return null;
    }
  }

  //// delete user
  Future<bool> deleteUser({
    required BuildContext context,
    required String uId,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        uri: ApiHelper.deleteUser(uId: uId),
        context: context,
      );
      if (response.isNotEmpty && response['success'] == true) {
        await SharedPrefs.clearShared();
        return true;
      }
      return false;
    } catch (e) {
      log('error while loggin in user => $e');
      return false;
    }
  }

  ///
  ///
  Future<SentOtpModel?> sentOtpToMobile({
    required BuildContext context,
    required String mobileNumber,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.sentOtpToMobile,
        body: {"contactNo": mobileNumber},
        context: context,
      );
      if (response.isNotEmpty && response['success'] == true) {
        SentOtpModel model = SentOtpModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log('error while verify to phone => $e');
      return null;
    }
  }

  Future<UserModel?> verifyOtpOfMobile({
    required BuildContext context,
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.verifyOtpOfMobile,
        body: {"contactNo": mobileNumber, "otp": otp},
        context: context,
      );
      if (response.isNotEmpty && response['success'] == true) {
        UserModel model = UserModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log('error while verify to phone => $e');
      return null;
    }
  }
}
