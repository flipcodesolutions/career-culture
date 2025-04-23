import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/service/user_servcies/login_service.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:provider/provider.dart';
import '../../models/login_model/sent_otp_model.dart';
import '../../models/login_model/user_signup_confirm_model.dart';

class LoginProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginService loginService = LoginService();
  UserModel? _loginResponseModel;
  UserModel? get loginResponseModel => _loginResponseModel;

  /// mobile number controller
  final TextEditingController mobileController = TextEditingController();
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

  /// sent otp to mobile number
  SentOtpModel? _otpModel;
  SentOtpModel? get otpModel => _otpModel;
  TextEditingController otpController = TextEditingController();
  Future<bool> sentOtpToMobileNumber({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _otpModel = await loginService.sentOtpToMobile(
      context: context,
      mobileNumber: mobileController.text,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return _otpModel?.success == true;
  }

  Future<void> verifyOtpToMobileNumber({
    required BuildContext context,
    required bool isNavigateHome,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _loginResponseModel = await loginService.verifyOtpOfMobile(
      context: context,
      mobileNumber: mobileController.text,
      otp: otpController.text,
    );
    if (_loginResponseModel?.success == true) {
      if (_loginResponseModel?.data?.isNewUser == true) {
        // if (!context.mounted) return;
        SignUpProvider signUpProvider = context.read<SignUpProvider>();
        signUpProvider.contactNo1.text = mobileController.text;
        signUpProvider.setIsContactNo1Verified = true;
        signUpProvider.setIsUpdatingProfile = false;
        push(context: context, widget: SignUpScreen());
      } else {
        mobileController.clear();
        otpController.clear();
        _otpModel = null;

        if (!context.mounted) return;
        context.read<UserProvider>().setIsUserLoggedIn = true;
        isNavigateHome
            ? pushRemoveUntil(
              context: context,
              widget: MainScreen(setIndex: 0),
              transition: FadeForwardsPageTransitionsBuilder(),
            )
            : {pop(context), pop(context)};
      }
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// check if email exit or not
  Future<void> checkEmailExit({
    required BuildContext context,
    required String email,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _loginResponseModel = await loginService.checkEmailExit(
      context: context,
      email: email,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    if (_loginResponseModel?.success == true) {
      if (_loginResponseModel?.data?.isNewUser == true) {
        if (!context.mounted) return;
        SignUpProvider signUpProvider = context.read<SignUpProvider>();
        signUpProvider.email.text = loginResponseModel?.data?.email ?? '';
        signUpProvider.setIsUpdatingProfile = false;
        notifyListeners();
        signUpProvider.setIsEmailVerified = true;
        push(context: context, widget: SignUpScreen());
      } else {
        if (!context.mounted) return;
        context.read<UserProvider>().setIsUserLoggedIn = true;
        pushRemoveUntil(
          context: context,
          widget: MainScreen(setIndex: 0),
          transition: FadeForwardsPageTransitionsBuilder(),
        );
      }
    }
  }

  /// delete user
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
