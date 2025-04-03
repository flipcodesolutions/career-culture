import 'package:flutter/material.dart';
import '../../app_const/app_colors.dart';

class GradientHelper {
  static Gradient splashScreenGradient = LinearGradient(
    colors: [AppColors.white, AppColors.primary],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
  static const Gradient profileEditGradient = LinearGradient(
    colors: [AppColors.white, AppColors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
