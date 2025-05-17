import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/refer_code_model.dart/refer_code_model.dart';
import 'package:mindful_youth/service/refer_service.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';

class ReferProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ReferService referService = ReferService();
  // ReferCodeModel? _referCodeModel;
  // ReferCodeModel? get referCodeModel => _referCodeModel;

  // Future<void> getReferCode({required BuildContext context}) async {
  //   /// set _isLoading true
  //   _isLoading = true;
  //   notifyListeners();
  //   _referCodeModel = await referService.yourReferCode(context: context);

  //   /// set _isLoading false
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<String> initReferCodeFromLocalStorage() async {
   return await SharedPrefs.getSharedString(
      AppStrings.myReferralCode,
    );

  }
}
