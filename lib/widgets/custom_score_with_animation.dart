import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_text.dart';

class CustomAnimatedScore extends StatelessWidget {
  const CustomAnimatedScore({
    super.key,
    required this.score,
    this.animationDuration = const Duration(seconds: 3),
  });

  final String score;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    int targetScore = int.tryParse(score) ?? 0; // Convert score to int
    final formatter =
        NumberFormat.decimalPattern(); // Formatter for thousands separator
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: targetScore),
      duration: animationDuration,
      builder:
          (context, value, child) => CustomText(
            text: formatter.format(value), // Format number,
            style: TextStyleHelper.mediumHeading,
          ),
    );
  }
}
