import 'package:flutter/material.dart';
import '../../app_const/app_colors.dart';

class GradientHelper {
  static Gradient videoPlayer = LinearGradient(
    colors: [AppColors.black.withOpacity(0.6), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  /// body program gradient
  static Gradient bodyGradient = LinearGradient(
    colors: [AppColors.body1, AppColors.body2],
  );

  /// mind program gradient
  static Gradient mindGradient = LinearGradient(
    colors: [AppColors.mind1, AppColors.mind2],
  );

  /// soul program gradient
  static Gradient soulGradient = LinearGradient(
    colors: [AppColors.soul1, AppColors.soul2],
  );
}
