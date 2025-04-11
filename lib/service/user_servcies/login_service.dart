import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/login_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';

class LoginService {
  Future<LoginResponseModel?> loginUser({
    required BuildContext context,
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
        LoginResponseModel model = LoginResponseModel.fromJson(response);
        await SharedPrefs.saveToken(model.data?.token ?? "");
        return model;
      }
      return null;
    } catch (e) {
      log('error while loggin in user => $e');
      return null;
    }
  }
}
