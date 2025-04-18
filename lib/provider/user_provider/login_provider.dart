import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/login_model.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/service/user_servcies/login_service.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

import '../../models/login_model/user_signup_confirm_model.dart';

class LoginProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginService loginService = LoginService();
  UserSignUpConfirmModel? _loginResponseModel;
  UserSignUpConfirmModel? get loginResponseModel => _loginResponseModel;

  Future<bool> login({
    required BuildContext context,
    required String emailOrPassword,
    required String password,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _loginResponseModel = await loginService.loginUser(
      context: context,
      emailOrPassword: emailOrPassword,
      password: password,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();

    return _loginResponseModel?.success == true;
  }

  Future<void> deleteUser({
    required BuildContext context,
    required String uId,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    bool success = await loginService.deleteUser(context: context, uId: uId);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    if (success) {
      if (!context.mounted) return;
      context.read<UserProvider>().setIsUserLoggedIn = false;
      SharedPrefs.clearShared();

      pushRemoveUntil(
        context: context,
        widget: LoginScreen(isToNavigateHome: true),
        transition: FadeForwardsPageTransitionsBuilder(),
      );
    }
  }
}
