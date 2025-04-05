import 'package:flutter/material.dart';
import '../../app_const/app_colors.dart';

class GradientHelper {
  static Gradient videoPlayer = LinearGradient(
    colors: [AppColors.black.withOpacity(0.6), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
