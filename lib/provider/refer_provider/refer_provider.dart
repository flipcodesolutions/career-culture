import 'package:flutter/material.dart';
import 'package:mindful_youth/models/refer_code_model.dart/refer_code_model.dart';
import 'package:mindful_youth/service/refer_service.dart';

class ReferProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReferService referService = ReferService();
  ReferCodeModel? _referCodeModel;
  ReferCodeModel? get referCodeModel => _referCodeModel;

  Future<void> getReferCode({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _referCodeModel = await referService.yourReferCode(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
