import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class AllEventService {
  Future<AllEventModel?> getAllEvents({
    required BuildContext context,
    required String id,
  }) async {
    try {
      log(ApiHelper.getAllEvents(id: id));
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getAllEvents(id: id),
      );
      if (response.isNotEmpty) {
        AllEventModel model = AllEventModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while getting all events => $e") : null;
      return null;
    }
  }

  ///
  Future<AllEventModel?> getAllUserEvents({
    required BuildContext context,
    required String id,
  }) async {
    try {
      log(ApiHelper.getAllEvents(id: id));
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.myParticipation,
      );
      if (response.isNotEmpty) {
        AllEventModel model = AllEventModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while getting all user events => $e") : null;
      return null;
    }
  }

  Future<AllEventModel?> eventParticipation({
    required BuildContext context,
    required String id,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.post(
        context: context,
        uri: ApiHelper.eventParticipation,
        body: {"eventId": id},
      );
      if (response.isNotEmpty) {
        log(response.toString());
        AllEventModel model = AllEventModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      kDebugMode ? log("error while participate in event => $e") : null;
      return null;
    }
  }
}
