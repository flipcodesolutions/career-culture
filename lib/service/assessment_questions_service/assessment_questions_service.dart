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

////
Future<bool> postAssessmentMediaQuestionsByPostId({
  required AssessmentQuestionModel? assessmentAnswer,
}) async {
  final token = await SharedPrefs.getToken();

  // group your questions by type
  final byType = <String, List<AssessmentQuestion>>{
    'image':
        assessmentAnswer?.data?.where((q) => q.type == 'image').toList() ?? [],
    'video':
        assessmentAnswer?.data?.where((q) => q.type == 'video').toList() ?? [],
    'audio':
        assessmentAnswer?.data?.where((q) => q.type == 'audio').toList() ?? [],
  };
  // map types to endpoints & form field names
  final config = <String, Map<String, dynamic>>{
    'image': {
      'endpoint': ApiHelper.postAssessmentQuestionsImageByPostId,
      'fieldName': 'image_files',
    },
    'video': {
      'endpoint': ApiHelper.postAssessmentQuestionsVideoByPostId,
      'fieldName': 'video_files',
    },
    'audio': {
      'endpoint': ApiHelper.postAssessmentQuestionsAudioByPostId,
      'fieldName': 'audio_files',
    },
  };

  // upload each type in series, bail out on first failure
  for (var type in ['image', 'video', 'audio']) {
    final List<AssessmentQuestion> qs = byType[type] ?? [];
    final String ep = (config[type]!['endpoint'] as String);
    final String field = config[type]!['fieldName'] as String;

    final ok = await _uploadMediaType(
      questions: qs,
      endpoint: ep,
      fieldName: field,
      authToken: token,
    );
    if (!ok) return false;
  }

  return true;
}

/// COMMON HELPER FOR EACH TYPE
Future<bool> _uploadMediaType({
  required List<AssessmentQuestion> questions,
  required String endpoint,
  required String fieldName, // e.g. "answer" or "image_files"
  required String authToken,
}) async {
  if (questions.isEmpty) return true; // nothing to upload ⇒ success

  final req = await HttpHelper.multipart(uri: endpoint);
  req.headers['Authorization'] = 'Bearer $authToken';

  for (var i = 0; i < questions.length; i++) {
    final q = questions[i];
    req.fields['data[$i][questionId]'] = q.id.toString();
    req.fields['data[$i][type]'] = q.type ?? '';
    req.fields['data[$i][answer]'] = q.userAnswer ?? '';
    if (q.type != "video") {
      for (var file in q.selectedFiles ?? <PlatformFile>[]) {
        final path = file.path;
        if (path == null || path.isEmpty) continue;

        final mime = lookupMimeType(path) ?? 'application/octet-stream';
        req.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            path,
            contentType: MediaType.parse(mime),
          ),
        );
      }
    }
  }

  try {
    final streamed = await req.send().timeout(const Duration(seconds: 30));
    final resp = await http.Response.fromStream(streamed);

    if (streamed.statusCode != 200) {
      throw HttpException(
        'Upload failed (${streamed.statusCode}): ${resp.body}',
      );
    }

    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    if (json['success'] != true) {
      throw Exception('Server error: ${json['message']}');
    }

    WidgetHelper.customSnackBar(
      title: json['message'] as String? ?? 'Upload successful',
      isError: false,
    );
    return true;
  } catch (e) {
    WidgetHelper.customSnackBar(
      title: 'Error uploading ${endpoint}: ${e.toString()}',
      isError: true,
    );
    if (kDebugMode) log('Upload error for ${endpoint}: $e');
    return false;
  }
}
