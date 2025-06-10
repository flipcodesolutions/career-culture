import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../utils/api_helper/api_helper.dart';
import 'package:mime/mime.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';

class AssessmentQuestionsService {
  Future<AssessmentQuestionModel?> getAssessmentQuestionsByPostId({
    required BuildContext context,
    required String postId,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getAssessmentQuestionsByPostId(id: postId),
      );
      log(response.toString());
      log(response.runtimeType.toString());
      if (response.isNotEmpty) {
        AssessmentQuestionModel model = AssessmentQuestionModel.fromJson(
          response,
        );
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while getting assessment questions => $e") : null;
      return null;
    }
  }

  Future<bool> postAssessmentQuestionsByPostId({
    required AssessmentQuestionModel? assessmentAnswer,
  }) async {
    try {
      // Create the multipart request
      MultipartRequest request = await HttpHelper.multipart(
        uri: ApiHelper.postAssessmentQuestionsByPostId,
      );

      // Set authorization header once
      final token = await SharedPrefs.getToken();
      request.headers.addAll({'Authorization': 'Bearer $token'});

      final dataList = assessmentAnswer?.data ?? [];

      for (var i = 0; i < dataList.length; i++) {
        AssessmentQuestion question = dataList[i];
        // log("=============start==============");
        // log(question.toJson().toString());
        // log("=============end==============");
        // bool isMedia = ['audio', 'image'].contains(question.type);

        // Add base fields
        request.fields['data[$i][questionId]'] = question.id.toString();
        request.fields['data[$i][type]'] = question.type ?? "";

        // Add text-based answer
        request.fields['data[$i][answer]'] = question.userAnswer.toString();

        // if (isMedia) {
        //   // Handle file-based answers
        //   List<PlatformFile> files = question.selectedFiles ?? [];

        //   for (var j = 0; j < files.length; j++) {
        //     File file = File(files[j].path ?? "");
        //     String mimeType =
        //         lookupMimeType(file.path) ?? 'application/octet-stream';

        //     // Add media file to request
        //     request.files.add(
        //       await http.MultipartFile.fromPath(
        //         question.type == "audio"
        //             ? 'data[$i][audio_files]' // This field name must match backend expectations
        //             : 'data[$i][image_files]',
        //         file.path,
        //         contentType: MediaType.parse(mimeType),
        //       ),
        //     );
        //   }
        // }
      }
      // log(" ==========??????????? ${request.fields}");
      // Send the request with timeout
      final streamed = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final resp = await http.Response.fromStream(streamed);

      if (streamed.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);
        log("${jsonResponse}");
        WidgetHelper.customSnackBar(
          title: "${jsonResponse['message']}",
          isError: !jsonResponse['success'],
        );
        return jsonResponse['success'];
      } else {
        WidgetHelper.customSnackBar(
          title: "Error: ${streamed.statusCode}",
          isError: true,
        );
        log("Upload error: ${streamed.statusCode} - ${resp.body}");
      }

      return false;
    } catch (e) {
      if (kDebugMode) log("Error during assessment upload => $e");
      return false;
    }
  }
}
