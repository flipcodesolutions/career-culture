import 'package:flutter/material.dart';

class ShadowHelper {
  static List<BoxShadow> scoreContainer = [
    BoxShadow(blurRadius: 3, spreadRadius: -5, offset: Offset(0, 5)),
  ];
  static List<BoxShadow> simpleShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.05),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
