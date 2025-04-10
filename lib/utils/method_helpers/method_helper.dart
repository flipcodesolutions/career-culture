import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MethodHelper {
  /// launch urls
  static Future<bool> launchUrlInBrowser({required String url}) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      print('❌ Invalid or unsupported URL: $url');
      return false;
    }

    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
        browserConfiguration: BrowserConfiguration(showTitle: true),
        webViewConfiguration: WebViewConfiguration(
          enableDomStorage: true,
          enableJavaScript: true,
        ),
      );
      return true;
    } else {
      print('❌ Cannot launch URL: $url');
      return false;
    }
  }

  /// will extract options from string
  static List<String> parseOptions(String? jsonString) {
    try {
      if (jsonString?.isNotEmpty == true) {
        return jsonString?.split(',') ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print('Failed to parse options: $e');
      return [];
    }
  }

  // Debounce function to prevent multiple API calls
  static void Function() debounce(
    VoidCallback action, {
    int milliseconds = 500,
  }) {
    Timer? _timer;

    return () {
      print('ksdnsjv');
      // Cancel any previous timer if it exists
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }

      // Start a new timer with a delay
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    };
  }

  static Widget buildFilePreview(PlatformFile file) {
    final mimeType = file.extension?.toLowerCase();

    if (mimeType == 'jpg' ||
        mimeType == 'jpeg' ||
        mimeType == 'png' ||
        mimeType == 'gif') {
      return Image.file(
        File(file.path!),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (mimeType == 'pdf') {
      return Icon(Icons.picture_as_pdf, color: Colors.red, size: 40);
    } else if (mimeType == 'mp4' || mimeType == 'mov' || mimeType == 'avi') {
      return Icon(Icons.videocam, color: Colors.blue, size: 40);
    } else if (mimeType == 'mp3' || mimeType == 'wav') {
      return Icon(Icons.audiotrack, color: Colors.green, size: 40);
    } else if (mimeType == 'doc' || mimeType == 'docx') {
      return Icon(Icons.description, color: Colors.blueGrey, size: 40);
    } else {
      return Icon(Icons.insert_drive_file, color: Colors.grey, size: 40);
    }
  }
}
