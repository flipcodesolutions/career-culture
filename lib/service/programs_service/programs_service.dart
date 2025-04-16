import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/models/programs/single_program_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class ProgramsService {
  /// get all programs
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

  /// get single programs by id
  Future<SingleProgramModel?> getProgramsById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.programById(id: id),
      );
      if (response.isNotEmpty) {
        SingleProgramModel model = SingleProgramModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while getting single program => $e") : null;
      return null;
    }
  }

  /// get home screen sliders
  /// get single programs by id
  Future<ProgramsModel?> getHomeScreenSliders({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.sliders,
      );
      if (response.isNotEmpty) {
        ProgramsModel model = ProgramsModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode
          ? log("error while getting sliders for home screen => $e")
          : null;
      return null;
    }
  }
}
