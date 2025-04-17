import 'package:flutter/material.dart';
import 'package:mindful_youth/models/login_model/login_model.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/service/user_servcies/login_service.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier with NavigateHelper {
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

      /// save in local storage as well
      ///
      MethodHelper.saveUserInfoInLocale(
        userName: _loginResponseModel?.data?.user?.name ?? "",
        userEmail: _loginResponseModel?.data?.user?.email ?? "",
        isEmailVerified: _loginResponseModel?.data?.user?.isEmailVerified ?? "",
        isContactVerified:
            _loginResponseModel?.data?.user?.isContactVerified ?? "",
        role: _loginResponseModel?.data?.user?.role ?? "",
        isApproved: _loginResponseModel?.data?.user?.isApproved ?? "",
        status: _loginResponseModel?.data?.user?.status ?? "",
        id: _loginResponseModel?.data?.user?.id?.toString() ?? "",
        images: _loginResponseModel?.data?.userProfile?.images ?? "",
        userId:
            _loginResponseModel?.data?.userProfile?.userId?.toString() ?? "",
        userContactNo1:
            _loginResponseModel?.data?.userProfile?.contactNo1 ?? "",
        userContactNo2:
            _loginResponseModel?.data?.userProfile?.contactNo2 ?? "",
        userGender: _loginResponseModel?.data?.userProfile?.gender ?? "",
        dateOfBirth: _loginResponseModel?.data?.userProfile?.dateOfBirth ?? "",
        addressLine1:
            _loginResponseModel?.data?.userProfile?.addressLine1 ?? "",
        addressLine2:
            _loginResponseModel?.data?.userProfile?.addressLine2 ?? "",
        userCity: _loginResponseModel?.data?.userProfile?.city ?? "",
        userState: _loginResponseModel?.data?.userProfile?.state ?? "",
        userCountry: _loginResponseModel?.data?.userProfile?.country ?? "",
        userDistrict: _loginResponseModel?.data?.userProfile?.district ?? "",
        study: _loginResponseModel?.data?.userEducation?.study ?? "",
        degree: _loginResponseModel?.data?.userEducation?.degree ?? "",
        university: _loginResponseModel?.data?.userEducation?.university ?? "",
        workingStatus:
            _loginResponseModel?.data?.userEducation?.workingStatus ?? "",
        userNameOfCompanyOrBusiness:
            _loginResponseModel?.data?.userEducation?.nameOfCompanyOrBusiness ??
            "",
        userToken: _loginResponseModel?.data?.token ?? "",
      );

      return true;
    }
    return false;
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
