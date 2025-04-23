import 'dart:convert';
import 'dart:developer';
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
      // Build replyList as before
      final replyList = <Map<String, dynamic>>[];
      for (AssessmentQuestion question in assessmentAnswer?.data ?? []) {
        replyList.add({
          'questionId': question.id,
          'type': question.type,
          'answer':
              (question.type == 'audio' ||
                      question.type == 'video' ||
                      question.type == 'video')
                  ? 'string'
                  : question.answer,
        });
      }

      // Flatten it into form-fields
      for (var i = 0; i < replyList.length; i++) {
        final item = replyList[i];
        final isMedia = item['type'] == 'audio' || item['type'] == 'video';

        request.fields['data[$i][questionId]'] = item['questionId'].toString();
        request.fields['data[$i][type]'] = item['type'];

        if (!isMedia) {
          // Only set 'answer' as a field for non-media types
          request.fields['data[$i][answer]'] = item['answer'].toString();
        }

        // Attach file if it's a media type
        if (isMedia) {
          final files = (assessmentAnswer?.data?[i].selectedFiles ?? []);
          for (var j = 0; j < files.length; j++) {
            final file = files[j];
            print('mime type for $j ==> ${lookupMimeType(file.path ?? "")} ');
            final bytes = await file.bytes;
            request.files.add(
              http.MultipartFile.fromBytes(
                'data[$i][answer]', // This must match Laravel's expectation
                bytes?.toList() ?? [],
                filename: 'q${item['questionId']}_file_$j',
                contentType: MediaType.parse(
                  lookupMimeType(file.path ?? "") ?? "",
                ),
              ),
            );
          }
        }
      }

      log(jsonEncode(request.fields));
      // send & handle response as before...
      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);

      print(resp.body);
      if (streamed.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);
        WidgetHelper.customSnackBar(
          context: context,
          title: "${jsonResponse['message']}",
          isError: !jsonResponse['success'],
        );
        return jsonResponse['success'];
      } else {
        WidgetHelper.customSnackBar(
          context: context,
          title: "${streamed.statusCode}",
          isError: true,
        );
        log("Error uploading assessment: ${streamed.statusCode}");
      }

      return false;
    } catch (e) {
      kDebugMode ? log("error while uploading assessment answer => $e") : null;
      return false;
    }
  }
}
