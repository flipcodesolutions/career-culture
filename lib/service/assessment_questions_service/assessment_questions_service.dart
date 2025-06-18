import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mindful_youth/models/assessment_question_model/assessment_question_model.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../utils/api_helper/api_helper.dart';
import 'package:mime/mime.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';

class AssessmentQuestionsService {
  List<String> mediaTypes = ['video', "audio", "image"];
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

      final dataList =
          assessmentAnswer?.data
              ?.where((e) => mediaTypes.contains(e.type) != true)
              .toList() ??
          [];

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

  Future<bool> postAssessmentMediaQuestionsByPostId({
    required AssessmentQuestionModel? assessmentAnswer,
  }) async {
    final token = await SharedPrefs.getToken();
    final mediaQs =
        assessmentAnswer?.data
            ?.where((q) => ['image', 'audio', 'video'].contains(q.type))
            .toList() ??
        [];

    if (mediaQs.isEmpty) {
      WidgetHelper.customSnackBar(
        title: 'No media questions to upload.',
        isError: false,
      );
      return true;
    }

    final endpointMap = {
      'image': ApiHelper.postAssessmentQuestionsImageByPostId,
      'audio': ApiHelper.postAssessmentQuestionsAudioByPostId,
      'video': ApiHelper.postAssessmentQuestionsVideoByPostId,
    };

    bool allPassed = true;

    for (final q in mediaQs) {
      final ep = endpointMap[q.type];
      if (ep == null) continue;

      // ◀️ Only call the API if there's actually something to send:
      if (q.type == 'video' && (q.userAnswer?.isNotEmpty ?? false) == false) {
        log('Skipping video#${q.id}: no URL provided');
        continue;
      }
      if ((q.type == 'image' || q.type == 'audio') &&
          (q.selectedFiles?.isNotEmpty ?? false) == false) {
        log('Skipping ${q.type}#${q.id}: no files selected');
        continue;
      }

      final success = await _uploadSingleQuestion(
        question: q,
        endpoint: ep,
        authToken: token,
      );
      if (!success) allPassed = false;
    }

    return allPassed;
  }

  Future<bool> _uploadSingleQuestion({
    required AssessmentQuestion question,
    required String endpoint,
    required String authToken,
  }) async {
    final req = await HttpHelper.multipart(uri: endpoint);
    req.headers.addAll({'Authorization': 'Bearer $authToken'});

    // Mandatory fields
    req.fields['questionId'] = question.id.toString();
    req.fields['type'] = question.type ?? '';
    final bool isAudio = question.type == "audio";
    if (question.type == 'video') {
      // video: the URL/string
      req.fields['answer'] = question.userAnswer!;
    } else {
      // image/audio: attach each selected file under 'answer'
      for (final file in question.selectedFiles!) {
        File? uploadFile;
        String filename = file.name;
        Uint8List bytes = file.bytes ?? Uint8List(0);

        if (isAudio) {
          final mp3 = await MethodHelper.convertPcmToMp3(pcmBytes: bytes);
          if (mp3 != null) {
            uploadFile = mp3;
            bytes = await mp3.readAsBytes();
            filename = 'audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
          } else {
            log("MP3 conversion failed for question ${question.id}");
            continue;
          }
        }

        final mime = lookupMimeType(filename) ?? 'application/octet-stream';
        log("mime $mime, file type ${file.extension}, final name: $filename");

        req.files.add(
          http.MultipartFile.fromBytes(
            'answer',
            bytes,
            filename: filename,
            contentType: MediaType.parse(mime),
          ),
        );
      }
    }

    // Logging
    log('Uploading to $endpoint');
    req.fields.forEach((k, v) => log(' Field: $k = $v'));
    for (var f in req.files) {
      log(' File: field=${f.field}, name=${f.filename}, size=${f.length}');
    }

    try {
      final streamed = await req.send().timeout(const Duration(seconds: 30));
      final resp = await http.Response.fromStream(streamed);

      if (streamed.statusCode != 200) {
        throw HttpException('Status ${streamed.statusCode}: ${resp.body}');
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
        title: 'Error uploading question ${question.id}: $e',
        isError: true,
      );
      if (kDebugMode) log('Upload error [$endpoint]: $e');
      return false;
    }
  }
}
