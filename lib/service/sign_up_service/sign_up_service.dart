import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/login_model/user_signup_request_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../models/login_model/user_signup_confirm_model.dart';
import '../../utils/widget_helper/widget_helper.dart';

class SignUpService {
  Future<UserModel?> registerUser({
    required BuildContext context,
    required UserSignUpRequestModel signUp,
  }) async {
    // try {
    MultipartRequest request = await HttpHelper.multipart(
      uri: ApiHelper.signUp,
    );
    if (signUp.imageFile.isNotEmpty) {
      final fileBytes = signUp.imageFile.first.bytes?.toList() ?? [];
      log("File size (bytes): ${fileBytes.length}");
      log("File name: profile_pick_${signUp.name}");

      if (fileBytes.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "images",
            fileBytes,
            filename:
                'profile_pic_${signUp.name?.replaceAll(" ", "_")}.${signUp.imageFile.first.extension}',
          ),
        );
      }
    }
    request.fields['name'] = signUp.name ?? "";
    request.fields['email'] = signUp.email ?? "";
    request.fields['is_email_verified'] = signUp.isEmailVerified ?? "";
    request.fields['is_contact_verified'] = signUp.isContactVerified ?? "";
    request.fields['phone'] = signUp.phone ?? "";
    // request.fields['contactNo1'] = signUp.contactNo1 ?? "";
    request.fields['contactNo2'] = signUp.contactNo2 ?? "";
    request.fields['gender'] = signUp.gender ?? "";
    request.fields['dateOfBirth'] = signUp.dateOfBirth ?? "";
    request.fields['addressLine1'] = signUp.addressLine1 ?? "";
    request.fields['addressLine2'] = signUp.addressLine2 ?? "";
    request.fields['city'] = signUp.city ?? "";
    request.fields['state'] = signUp.state ?? "";
    request.fields['country'] = signUp.country ?? "";
    request.fields['district'] = signUp.district ?? "";
    request.fields['study'] = signUp.study ?? "";
    request.fields['degree'] = signUp.degree ?? "";
    request.fields['university'] = signUp.university ?? "";
    request.fields['workingStatus'] = signUp.workingStatus ?? "";
    request.fields['convener_id'] = signUp.convenerId.toString();
    request.fields['nameOfCompanyOrBusiness'] =
        signUp.nameOfCompanyOrBusiness ?? "";

    final streamedResponse = await request.send();
    final data = await http.Response.fromStream(streamedResponse);
    if (streamedResponse.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(data.body);
      WidgetHelper.customSnackBar(
        context: context,
        title: "${jsonResponse['message']}",
        isError: !jsonResponse['success'],
      );
      UserModel model = UserModel.fromJson(jsonResponse);
      return model;
    } else {
      WidgetHelper.customSnackBar(
        context: context,
        title: "${streamedResponse.statusCode}",
        isError: true,
      );
      log("Error sign up: ${streamedResponse.statusCode}");
      return null;
    }
    // } catch (e) {
    //   log('error while register user => $e');
    //   return null;
    // }
  }

  ///
  Future<UserModel?> updateUserInfo({
    required BuildContext context,
    required UserSignUpRequestModel signUp,
  }) async {
    try {
      String uId = await SharedPrefs.getSharedString(AppStrings.userId);
      String token = await SharedPrefs.getSharedString(AppStrings.userToken);
      MultipartRequest request = await HttpHelper.multipart(
        uri: ApiHelper.updateUserInfo(uId: uId),
      );
      if (signUp.imageFile.isNotEmpty) {
        final fileBytes = signUp.imageFile.first.bytes?.toList() ?? [];
        log("File size (bytes): ${fileBytes.length}");
        log("File name: profile_pick_${signUp.name}");

        if (fileBytes.isNotEmpty) {
          request.files.add(
            http.MultipartFile.fromBytes(
              "images",
              fileBytes,
              filename:
                  'profile_pic_${signUp.name?.replaceAll(" ", "_")}.${signUp.imageFile.first.extension}',
            ),
          );
        }
      }
      request.fields['name'] = signUp.name ?? "";
      request.fields['email'] = signUp.email ?? "";
      request.fields['is_email_verified'] = signUp.isEmailVerified ?? "";
      request.fields['is_contact_verified'] = signUp.isContactVerified ?? "";
      request.fields['phone'] = signUp.phone ?? "";
      // request.fields['contactNo1'] = signUp.contactNo1 ?? "";
      request.fields['contactNo2'] = signUp.contactNo2 ?? "";
      request.fields['gender'] = signUp.gender ?? "";
      request.fields['dateOfBirth'] = signUp.dateOfBirth ?? "";
      request.fields['addressLine1'] = signUp.addressLine1 ?? "";
      request.fields['addressLine2'] = signUp.addressLine2 ?? "";
      request.fields['city'] = signUp.city ?? "";
      request.fields['state'] = signUp.state ?? "";
      request.fields['country'] = signUp.country ?? "";
      request.fields['district'] = signUp.district ?? "";
      request.fields['study'] = signUp.study ?? "";
      request.fields['degree'] = signUp.degree ?? "";
      request.fields['university'] = signUp.university ?? "";
      request.fields['workingStatus'] = signUp.workingStatus ?? "";
      request.fields['nameOfCompanyOrBusiness'] =
          signUp.nameOfCompanyOrBusiness ?? "";

      final streamedResponse = await request.send();
      final data = await http.Response.fromStream(streamedResponse);
      if (streamedResponse.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(data.body);
        WidgetHelper.customSnackBar(
          context: context,
          title: "${jsonResponse['message']}",
          isError: !jsonResponse['success'],
        );
        UserModel model = UserModel.fromJson(jsonResponse);
        model.data?.token = token;
        return model;
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: "${streamedResponse.statusCode}",
          isError: true,
        );
        log("Error sign up: ${streamedResponse.statusCode}");
        return null;
      }
    } catch (e) {
      log('error while register user => $e');
      return null;
    }
  }
}
