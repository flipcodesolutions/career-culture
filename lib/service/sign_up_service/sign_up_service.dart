import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_youth/models/login_model/user_signup_request_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

import '../../utils/widget_helper/widget_helper.dart';

class SignUpService {
  Future<void> registerUser({
    required BuildContext context,
    required UserSignUpRequestModel signUp,
  }) async {
    try {
      MultipartRequest request = await HttpHelper.multipart(
        uri: ApiHelper.signUp,
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_pick_${signUp.name}',
          signUp.imageFile?.first.bytes?.toList() ?? [],
          filename: 'profile_pick_${signUp.name}',
        ),
      );
      request.fields['data'] = jsonEncode(signUp);
      log('Request fields: ${jsonEncode(signUp)}');

      final streamedResponse = await request.send();
      final data = await http.Response.fromStream(streamedResponse);

      print(data.body);
      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(data.body);
        WidgetHelper.customSnackBar(
          context: context,
          title: "${jsonResponse['message']}",
          isError: !jsonResponse['success'],
        );
        return jsonResponse['success'];
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: "${streamedResponse.statusCode}",
          isError: true,
        );
        log("Error uploading assessment: ${streamedResponse.statusCode}");
      }
    } catch (e) {
      log('error while register user => $e');
      return null;
    }
  }
}
