import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/screens/login/sign_up/share_contact_details.dart';
import 'package:mindful_youth/screens/login/sign_up/start_your_journey.dart';
import '../../screens/login/sign_up/educational_details.dart';
import '../../screens/login/sign_up/family_details.dart';
import '../../screens/login/sign_up/provide_answer.dart';

class UserProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// list of sign up process
  List<Widget> _signUpSteps = [
    StartYourJourney(),
    ShareContactDetails(),
    EducationalDetails(),
    FamilyDetails(),
    ProvideAnswer(),
  ];
  List<Widget> get signUpSteps => _signUpSteps;
  int _currentSignUpPageIndex = 0;
  int get currentSignUpPageIndex => _currentSignUpPageIndex;
  set setCurrentSignupPageIndex(int index) {
    _currentSignUpPageIndex = index;
    notifyListeners();
  }

  /// Service and getter and setter
  // UserServices userService = UserServices();
  // LoginModel? _loginModel;
  // LoginModel? get loginModel => _loginModel;
}
