// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:mindful_youth/utils/exception_helper/exception_helper.dart';
// import 'package:mindful_youth/utils/http_helper/http_helpper.dart';
// import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';

// class TestService {
//   Future<void> performTest({required BuildContext context}) async {
//     try {
//       Map<String, dynamic> response = await HttpHelper.get(
//         uri: "https://alexwohlbruck.github.io/cat-facts/",
//         context: context,
//       );
//     } on CustomHttpException catch (e) {
//       WidgetHelper.customSnackBar(
//         context: context,
//         title: e.message,
//         isError: true,
//       );
//     } catch (e) {
//       log('error while test => $e');
//     }
//   }
// }
