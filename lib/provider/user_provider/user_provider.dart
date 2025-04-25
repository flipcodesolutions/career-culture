import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/screens/login/sign_up/share_contact_details.dart';
import 'package:mindful_youth/screens/login/sign_up/start_your_journey.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../screens/login/sign_up/educational_details.dart';

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

  /// bool for user is logged in
  bool _isUserApproved = false;
  bool get isUserApproved => _isUserApproved;
  set setIsUserApproved(bool status) {
    _isUserApproved = status;
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

  Future<void> checkIfUserIsApproved() async {
    String status = await SharedPrefs.getSharedString(AppStrings.userApproved);
    if (status.trim().isNotEmpty && status == "yes") {
      _isUserApproved = true;
    } else {
      _isUserApproved = false;
    }
  }
}
