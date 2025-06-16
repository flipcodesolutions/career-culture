import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mindful_youth/models/selfie_model/selfie_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class SelfieService {
  /// get selfie zones
  Future<GetSelfieZone?> getSelfieZone({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getSelfieZones,
      );
      if (response.isNotEmpty) {
        return GetSelfieZone.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting selfie zones => $e");
      return null;
    }
  }

  /// upload selfie
  Future<bool> uploadSelfie({required File file, required int id}) async {
    MultipartRequest request = await HttpHelper.multipart(
      uri: ApiHelper.uploadSelfies,
    );
    request.headers.addAll({'accept': 'application/json'});
    request.fields['selfieZoneId'] = id.toString();
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final mimeSplit = mimeType.split('/');
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        file.path,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        filename: DateTime.now().toIso8601String(),
      ),
    );
    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        print('Upload successful: $responseBody');
        return jsonResponse['success'];
      } else {
        print('Upload failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log("error while uploading selfie => $e");
      return false;
    }
  }
}
