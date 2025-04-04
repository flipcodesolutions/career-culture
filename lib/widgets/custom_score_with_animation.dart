import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_text.dart';

class CustomAnimatedScore extends StatelessWidget {
  const CustomAnimatedScore({
    super.key,
    required this.score,
    this.lastText,
    this.textStyle,
    this.animationDuration = const Duration(seconds: 3),
  });
  final String? lastText;
  final String score;
  final Duration animationDuration;
  final TextStyle? textStyle;
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
            text:
                "${formatter.format(value)} ${lastText ?? ""}", // Format number,
            style:textStyle ?? TextStyleHelper.mediumHeading,
          ),
    );
  }
}
