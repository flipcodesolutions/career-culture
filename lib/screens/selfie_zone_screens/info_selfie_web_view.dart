import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app_const/app_strings.dart';

class InfoSelfieWebView extends StatefulWidget {
  const InfoSelfieWebView({super.key});

  @override
  State<InfoSelfieWebView> createState() => _InfoSelfieWebViewState();
}

class _InfoSelfieWebViewState extends State<InfoSelfieWebView> {
  final WebViewController webController = WebViewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onProgress: (progress) {}))
      ..loadRequest(Uri.parse(AppStrings.selfieWebViewURL));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: webController)),
    );
  }
}
