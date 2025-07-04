import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../utils/method_helpers/method_helper.dart';
import '../../utils/widget_helper/widget_helper.dart';

class LoginProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginService loginService = LoginService();
  UserModel? _loginResponseModel;
  UserModel? get loginResponseModel => _loginResponseModel;
  set setLoginResponseModel(UserModel? userModel) {
    _loginResponseModel = userModel;
    notifyListeners();
  }

  void logout() {
    _loginResponseModel = null;
    mobileController.text = "";
    _otpModel = null;
    otpController.text = "";
    cancelTimerOtpResend();
  }

  /// mobile number controller
  final TextEditingController mobileController = TextEditingController();
  // Future<bool> login({
  //   required BuildContext context,
  //   required String emailOrPassword,
  //   required String password,
  //   required UserProvider userProvider,
  // }) async {
  //   /// set _isLoading true
  //   _isLoading = true;
  //   notifyListeners();
  //   _loginResponseModel = await loginService.loginUser(
  //     context: context,
  //     emailOrPassword: emailOrPassword,
  //     password: password,
  //     userProvider: userProvider,
  //   );

  //   /// set _isLoading false
  //   _isLoading = false;
  //   notifyListeners();

  //   return _loginResponseModel?.success == true;
  // }

  /// sent otp to mobile number
  SentOtpModel? _otpModel;
  SentOtpModel? get otpModel => _otpModel;
  set sentOtpModel(SentOtpModel? otpModel) {
    _otpModel = otpModel;
    notifyListeners();
  }

  TextEditingController otpController = TextEditingController();
  Future<bool> sentOtpToMobileNumber({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _otpModel = await loginService.sentOtpToMobile(
      context: context,
      mobileNumber: mobileController.text,
    );
    if (_otpModel?.success == true) {
      initTimerOtpResend();
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return _otpModel?.success == true;
  }

  ///
  int resendOtpSecond = 60;
  Timer? resendOtpTimer;
  void resendOtpLogic() {
    if (resendOtpSecond > 0) {
      resendOtpSecond--;
      notifyListeners();
    } else {
      cancelTimerOtpResend();
    }
  }

  /// cancel timer
  void cancelTimerOtpResend() {
    resendOtpTimer?.cancel();
    resendOtpSecond = 0;
    notifyListeners();
  }

  /// init timer to count for 60sec
  void initTimerOtpResend() {
    resendOtpSecond = 60;
    notifyListeners();
    resendOtpTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => resendOtpLogic(),
    );
    notifyListeners();
  }

  Future<void> verifyOtpToMobileNumber({
    required BuildContext context,
    required bool isNavigateHome,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();

    /// this is line is for to get rid of data user just entered but did'nt finished and goes back , without this line will pre load the data what user filled lastly
    await WidgetHelper.clearUserStorage(skipKeys: {});
    _loginResponseModel = await loginService.verifyOtpOfMobile(
      context: context,
      mobileNumber: mobileController.text,
      otp: otpController.text,
    );
    if (_loginResponseModel?.success == true) {
      cancelTimerOtpResend();
      if (_loginResponseModel?.data?.isNewUser == true) {
        SignUpProvider signUpProvider = context.read<SignUpProvider>();
        signUpProvider.setIsUpdatingProfile = false;
        signUpProvider.setIsRegisteredFromBackEnd =
            _loginResponseModel?.data?.user?.id != null ||
            _loginResponseModel?.data?.user?.studentId?.isNotEmpty == true;
        push(context: context, widget: SignUpScreen());
      } else {
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
      // mobileController.clear();
      otpController.clear();
      _otpModel = null;
      notifyListeners();
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

    /// this is line is for to get rid of data user just entered but did'nt finished and goes back , without this line will pre load the data what user filled lastly
    await WidgetHelper.clearUserStorage(skipKeys: {});
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
        signUpProvider.setIsUpdatingProfile = false;
        signUpProvider.setIsRegisteredFromBackEnd =
            _loginResponseModel?.data?.user?.id != null ||
            _loginResponseModel?.data?.user?.studentId?.isNotEmpty == true;
        notifyListeners();
        signUpProvider.setIsEmailVerified = true;
        push(context: context, widget: SignUpScreen());
      } else {
        if (_loginResponseModel?.data?.user?.status != "active") {
          MethodHelper().redirectDeletedOrInActiveUserToLoginPage(
            context: context,
          );
          return;
        }
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
    bool success = await loginService.deleteUser(uId: uId, context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    if (success) {
      if (!context.mounted) return;
      UserProvider userProvider = context.read<UserProvider>();
      userProvider.setIsUserLoggedIn = false;
      SharedPrefs.clearShared();
      userProvider.logout();
      context.read<SignUpProvider>().refreshSignUpProvider();
      await FirebaseAuth.instance.signOut();
      logout();
      pushRemoveUntil(
        context: context,
        widget: LoginScreen(isToNavigateHome: true),
        transition: FadeForwardsPageTransitionsBuilder(),
      );
      mobileController.clear();
      otpController.clear();
      _loginResponseModel = null;
      sentOtpModel = null;
    }
  }
}
