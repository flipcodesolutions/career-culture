import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:mindful_youth/screens/login/login_screen.dart';
import '../../app_const/app_colors.dart';
import '../shared_prefs_helper/shared_prefs_helper.dart';
import '../widget_helper/widget_helper.dart';

class HttpHelper {
  static final client = RetryClient(
    http.Client(),
    retries: 3,
    when: (res) => res.statusCode >= 500,
    whenError:
        (err, stack) => err is http.ClientException || err is SocketException,
  );
  static bool isDebugMode = kDebugMode;
  // Generalized response handler
  static Future<Map<String, dynamic>> processResponse({
    required Response response,
    required BuildContext context,
    bool showSnackBar = true,
  }) async {
    try {
      // if (!context.mounted) return {};
      if (isDebugMode) {
        log(response.body);
      }
      Map<String, dynamic> data = jsonDecode(response.body);

      // Handle 500 Internal Server Error
      if (response.statusCode == 500) {
        WidgetHelper.customSnackBar(
          isError: true,
          title: "Internal Server Error (${response.statusCode})",
          color: AppColors.error,
        );
        throw Exception("Server error");
      }

      // Handle unauthorized access (401)
      if (response.statusCode == 401) {
        WidgetHelper.customSnackBar(
          isError: true,
          title:
              "Session expired. Please log in again. (${response.statusCode})",
          color: AppColors.error,
        );
        await SharedPrefs.clearShared();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
        return {}; // Empty map since user is logged out
      }

      // Ensure status is 200 even for validation errors
      if (response.statusCode == 200) {
        if (data.containsKey('success') && !data['success']) {
          showSnackBar
              ? WidgetHelper.customSnackBar(
                isError: true,
                title:
                    "${data['message']} ${response.statusCode}" ??
                    "Something went wrong (${response.statusCode})",
                color: AppColors.error,
              )
              : null;
          return data; // Return data even if unsuccessful
        }
        return data; // If success is true, return the data
      }

      // Handle unexpected errors
      showSnackBar
          ? WidgetHelper.customSnackBar(
            isError: true,
            title: "Unexpected Error (${response.statusCode})",
            color: AppColors.error,
          )
          : null;
      return {};
    } catch (e) {
      if (isDebugMode) {
        log("Error processing response: $e");
      }
      showSnackBar
          ? WidgetHelper.customSnackBar(
            isError: true,
            title: "Something went wrong (${response.statusCode})",
            color: AppColors.error,
          )
          : null;
      return {};
    }
  }

  // GET method
  static Future<Map<String, dynamic>> get({
    required BuildContext context,
    required String uri,
    Map<String, String>? headers,
    bool showSnackBar = true,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      log(uri);
      var response = await client.get(url, headers: headers ?? header);

      // if (context.mounted) {
      return processResponse(
        response: response,
        context: context,
        showSnackBar: showSnackBar,
      );
      // }
    } catch (e) {
      if (isDebugMode) {
        log("GET request error: $e");
      }
    }
    return {}; // Return an empty map on failure
  }

  // POST method
  static Future<Map<String, dynamic>> post({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
    bool showSnackBar = true,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};
      var url = Uri.parse(uri);
      var response = await client.post(
        url,
        body: body,
        headers: headers ?? header,
        encoding: encoding,
      );

      if (isDebugMode) {
        log('post ===> ${response.statusCode} && ${response.body}');
      }

      // if (!context.mounted) return {};
      return processResponse(
        response: response,
        context: context,
        showSnackBar: showSnackBar,
      );
    } catch (e) {
      isDebugMode ? log("POST request error: $e") : null;
    }
    return {};
  }

  // PUT method
  static Future<Map<String, dynamic>> put({
    required String uri,
    Object? body,
    Map<String, String>? headers,
    required BuildContext context,
    Encoding? encoding,
    bool showSnackBar = true,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      var response = await client.put(
        url,
        body: body,
        headers: headers ?? header,
        encoding: encoding,
      );

      // if (!context.mounted) return {};
      return processResponse(
        response: response,
        context: context,
        showSnackBar: showSnackBar,
      );
    } catch (e) {
      if (isDebugMode) {
        log("PUT request error: $e");
      }
    }
    return {};
  }

  // DELETE method
  static Future<Map<String, dynamic>> delete({
    required BuildContext context,
    required String uri,
    Object? body,
    Map<String, String>? headers,
    bool showSnackBar = true,
  }) async {
    try {
      var token = await SharedPrefs.getToken();
      var header = {'Authorization': 'Bearer $token'};

      var url = Uri.parse(uri);
      var response = await client.delete(
        url,
        headers: headers ?? header,
        body: body,
      );

      // if (!context.mounted) return {};
      return processResponse(
        response: response,
        context: context,
        showSnackBar: showSnackBar,
      );
    } catch (e) {
      if (isDebugMode) {
        log("DELETE request error: $e");
      }
    }
    return {};
  }

  // Multipart method
  static Future<MultipartRequest> multipart({required String uri}) async {
    try {
      var token = await SharedPrefs.getToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        // "content-type": "application/json",
        // "Content-Type": "multipart/form-data",
      };

      MultipartRequest request = http.MultipartRequest('POST', Uri.parse(uri));
      request.headers.addAll(headers);

      return request;
    } catch (e) {
      if (isDebugMode) {
        log("Multipart request error: $e");
      }
      throw Exception("Multipart request failed");
    }
  }
}
