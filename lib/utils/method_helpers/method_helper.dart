import 'dart:async';
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
}
