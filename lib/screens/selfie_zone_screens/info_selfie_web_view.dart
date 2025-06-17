import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_text.dart';

class InfoSelfieWebView extends StatefulWidget {
  const InfoSelfieWebView({super.key});

  @override
  State<InfoSelfieWebView> createState() => _InfoSelfieWebViewState();
}

class _InfoSelfieWebViewState extends State<InfoSelfieWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CustomText(text: "Web View")));
  }
}
