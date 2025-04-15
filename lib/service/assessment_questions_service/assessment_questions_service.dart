import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../utils/api_helper/api_helper.dart';

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
    required BuildContext context,
    required AssessmentQuestionModel? assessmentAnswer,
  }) async {
    try {
      MultipartRequest request = await HttpHelper.multipart(
        uri: ApiHelper.postAssessmentQuestionsByPostId,
      );
     
      List<Map<String, dynamic>> replyList = [];

      for (AssessmentQuestion question in assessmentAnswer?.data ?? []) {
        // Build each question's data
        replyList.add({
          'questionId': question.id,
          'type': question.type,
          'answer':
              (question.type == "audio" || question.type == "video")
                  ? ""
                  : question.answer,
        });

        // Attach files if any
        for (var i = 0; i < (question.selectedFiles?.length ?? 0); i++) {
          final file = question.selectedFiles![i];
          final fileBytes = await file.bytes;
          final fileName = file.path?.split('/').last;

          request.files.add(
            http.MultipartFile.fromBytes(
              'question_${question.id}_file_$i',
              fileBytes?.toList() ?? [],
              filename: fileName,
            ),
          );
        }
      }

      // ✅ This is the key step
      request.fields['data'] = jsonEncode({"data": replyList});

      log('Request fields: ${jsonEncode({"data": replyList})}');

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

      return false;
    } catch (e) {
      kDebugMode ? log("error while uploading assessment answer => $e") : null;
      return false;
    }
  }
}
