import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/faqs_model/faqs_model.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helpper.dart';

class FaqsService {
  Future<FAQsModel?> getFAQs({required BuildContext context}) async {
    try {
      Map<String, dynamic> response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.faqs,
      );
      if (response.isNotEmpty) {
        return FAQsModel.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      log("error while getting faqs => $e");
      return null;
    }
  }
}
