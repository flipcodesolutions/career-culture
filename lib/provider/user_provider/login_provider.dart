import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/login_model.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/service/user_servcies/login_service.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginService loginService = LoginService();
  LoginResponseModel? _loginResponseModel;
  LoginResponseModel? get loginResponseModel => _loginResponseModel;

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
    if (_loginResponseModel?.success == true) {
      context.read<UserProvider>().setIsUserLoggedIn = true;
      SharedPrefs.saveToken(_loginResponseModel?.data?.token ?? "");
      return true;
    }
    return false;
  }
}
