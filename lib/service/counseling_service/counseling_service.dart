import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/counseling_model/counseling_models.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class CounselingService {
  Future<CounselingDatesAndSlotsModel?> getSlotsAndDateForCounseling({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getCounselingDatesAndSlots,
      );
      if (response.isNotEmpty) {
        return CounselingDatesAndSlotsModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log('error while getting counseling dates and slots => $e');
      return null;
    }
  }
}
