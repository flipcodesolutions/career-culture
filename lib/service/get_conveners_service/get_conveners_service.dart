import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/convener_list_model.dart';
import 'package:mindful_youth/utils/api_helper/api_helper.dart';
import 'package:mindful_youth/utils/http_helper/http_helpper.dart';

class GetConvenersService {
  Future<ConvenerListModel?> getConvenerList({
    required BuildContext context,
  }) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getConvener,
      );
      if (response.isNotEmpty) {
        ConvenerListModel model = ConvenerListModel.fromJson(response);
        return model;
      }
      return null;
    } catch (e) {
      log("error while getting convener list => $e");
      return null;
    }
  }
}
