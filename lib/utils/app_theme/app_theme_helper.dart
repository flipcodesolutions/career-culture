import 'package:flutter/services.dart';
import '../../app_const/app_colors.dart';

class AppThemeHelper {
  /// change the top status bar color
  static const SystemUiOverlayStyle systemTopStatusBar = SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: true,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
