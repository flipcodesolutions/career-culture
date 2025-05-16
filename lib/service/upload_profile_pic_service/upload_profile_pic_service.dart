import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'dart:typed_data';
import '../../models/user_profile_upload_model/user_profile_upload_model.dart';
import '../../utils/widget_helper/widget_helper.dart';

class UploadProfilePicService {
  Future<UserProfileUploadModel?> uploadProfilePic({
    required BuildContext context,
    required XFile? image,
  }) async {
    try {
      MultipartRequest request = await HttpHelper.multipart(
        uri: ApiHelper.uploadProfilePic,
      );
      Uint8List bytes = await image?.readAsBytes() ?? Uint8List(0);
      String name = await SharedPrefs.getSharedString(AppStrings.userName);
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename:
              'profile_pic_${name.replaceAll(" ", "_")}.${image?.mimeType ?? ""}',
        ),
      );
      StreamedResponse streamedResponse = await request.send();
      final data = await http.Response.fromStream(streamedResponse);
      if (streamedResponse.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(data.body);
        WidgetHelper.customSnackBar(
          // context: context,
          title: "${jsonResponse['message']}",
          isError: !jsonResponse['success'],
        );
        UserProfileUploadModel model = UserProfileUploadModel.fromJson(
          jsonResponse,
        );
        await SharedPrefs.saveString(
          AppStrings.images,
          model.data?.imagePath ?? "",
        );
        return model;
      } else {
        WidgetHelper.customSnackBar(
          // context: context,
          title: "${streamedResponse.statusCode}",
          isError: true,
        );
        log("Error sign up: ${streamedResponse.statusCode}");
        return null;
      }
    } catch (e) {
      log("error while uploading profile pic => $e");
      return null;
    }
  }
}
