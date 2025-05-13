import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/refer_code_model.dart/refer_code_model.dart';

class ReferService {
  /// refer code
  Future<ReferCodeModel?> yourReferCode({required BuildContext context}) async {
    try {
      // Map<String, dynamic> response = await HttpHelper.get(
      //   context: context,
      //   uri: ApiHelper.referCode,
      // );
      Map<String, dynamic> response = await Future.delayed(
        Duration(seconds: 5),
        () =>
            ReferCodeModel(
              success: true,
              message: "Got Refer Code",
              data: ReferCodeModelData(referCode: "CC1234", points: "200"),
            ).toJson(),
      );
      if (response.isNotEmpty) {
        return ReferCodeModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log("error while getting refer code => $e");
      return null;
    }
  }
}
