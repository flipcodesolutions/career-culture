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
  /// Example function for a multipart request.
  Future<bool> registerUser({
    required BuildContext context,
    required UserSignUpRequestModel signUp,
  }) async {
    try {
      // Construct the URI for your API endpoint.
      final uri = Uri.parse(ApiHelper.signUp);
      // Create a new multipart request (HTTP method POST)
      final request = http.MultipartRequest('POST', uri);

      // Add file (if available) to the request.
      if (signUp.imageFile?.isNotEmpty ?? false) {
        final fileBytes = signUp.imageFile!.first.bytes?.toList() ?? [];
        if (fileBytes.isNotEmpty) {
          // The field name and filename can be customized.
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_pick_${signUp.name}',
              fileBytes,
              filename: 'profile_pick_${signUp.name}',
            ),
          );
        }
      }

      // Add the rest of the data in JSON format.
      // The field key "data" is arbitrary – adjust to what your backend expects.
      request.fields['data'] = jsonEncode(signUp.toJson());
      log('Request fields: ${jsonEncode(signUp.toJson())}');

      // Send the multipart request.
      final streamedResponse = await request.send();

      // Read and decode the response.
      final response = await http.Response.fromStream(streamedResponse);
      log('Response: ${response.body}');

      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        WidgetHelper.customSnackBar(
          context: context,
          title: "${jsonResponse['message']}",
          isError: !(jsonResponse['success'] ?? false),
        );
        return jsonResponse['success'] ?? false;
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: "Error: ${streamedResponse.statusCode}",
          isError: true,
        );
        log("Error uploading user: ${streamedResponse.statusCode}");
        return false;
      }
    } catch (e) {
      log('Error while registering user: $e');
      WidgetHelper.customSnackBar(
        context: context,
        title: "Registration failed. Please try again.",
        isError: true,
      );
      return false;
    }
  }
}
