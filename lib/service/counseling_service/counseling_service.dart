import 'dart:developer';
// import 'package:flutter/material.dart';
import 'package:mindful_youth/models/counseling_model/counseling_models.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';

import '../../app_const/app_strings.dart';

class CounselingService {
  Future<CounselingDatesAndSlotsModel?> getSlotsAndDateForCounseling(
    // {required BuildContext context,}
  ) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        // context: context,
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

  /// create counseling appointment
  Future<bool> createCounselingAppointment({
    // required BuildContext context,
    required String appointmentDate,
    required String slot,
    required String mode,
  }) async {
    try {
      String uId = await SharedPrefs.getSharedString(AppStrings.userId);
      Map<String, dynamic> response = await HttpHelper.post(
        uri: ApiHelper.createCounselingAppointment,
        // context: context,
        body: {
          "user_id": uId,
          "appointment_date": appointmentDate,
          "slot": slot,
          "mode": mode,
        },
      );
      if (response.isNotEmpty) {
        return response['success'];
      }
      return false;
    } catch (e) {
      log("error while creating counseling appointment => $e");
      return false;
    }
  }
}
