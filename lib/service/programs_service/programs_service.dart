import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ProgramsService {
  Future<ProgramsModel?> getAllPrograms({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.programs,
      );
      if (response.isNotEmpty) {
        ProgramsModel model = ProgramsModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while getting programs => $e") : null;
      return null;
    }
  }
}
