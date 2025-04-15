import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/screens/login/sign_up/chip_selector.dart';
import 'package:mindful_youth/screens/login/sign_up/share_contact_details.dart';
import 'package:mindful_youth/screens/login/sign_up/start_your_journey.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../screens/login/sign_up/educational_details.dart';
import '../../screens/login/sign_up/family_details.dart';
import '../../screens/login/sign_up/provide_answer.dart';

class UserProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// list of sign up process
  final List<Widget> _signUpSteps = [
    StartYourJourney(),
    ShareContactDetails(),
    EducationalDetails(),
    // FamilyDetails(),
    // ProvideAnswer(),
    // ChipSelector(),
  ];
  List<Widget> get signUpSteps => _signUpSteps;
  int _currentSignUpPageIndex = 0;
  int get currentSignUpPageIndex => _currentSignUpPageIndex;
  set setCurrentSignupPageIndex(int index) {
    _currentSignUpPageIndex = index;
    notifyListeners();
  }

  /// bool for user is logged in
  bool _isUserLoggedIn = false;
  bool get isUserLoggedIn => _isUserLoggedIn;
  set setIsUserLoggedIn(bool status) {
    _isUserLoggedIn = status;
    notifyListeners();
  }

  Future<void> checkIfUserIsLoggedIn() async {
    String token = await SharedPrefs.getToken();
    if (token.trim().isNotEmpty) {
      _isUserLoggedIn = true;
    } else {
      _isUserLoggedIn = false;
    }
  }

  /// Service and getter and setter
  // UserServices userService = UserServices();
  // LoginModel? _loginModel;
  // LoginModel? get loginModel => _loginModel;
}
