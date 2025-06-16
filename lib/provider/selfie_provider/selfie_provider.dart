import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mindful_youth/models/selfie_model/selfie_model.dart';
import 'package:mindful_youth/service/selfies_service/selfie_service.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';

import '../../app_const/app_strings.dart';

class SelfieProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  SelfieService selfieService = SelfieService();
  GetSelfieZone? _selfieZone;
  GetSelfieZone? get selfieZone => _selfieZone;

  /// get selfie zone
  Future<void> getSelfieZone({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _selfieZone = await selfieService.getSelfieZone(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  //// upload page
  ///
  ///
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  set setSelectedImage(File? file) {
    _selectedImage = file;
    notifyListeners();
  }

  TextEditingController captionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ////
  Future<void> uploadSelfie({required int id}) async {
    if (_selectedImage == null) {
      WidgetHelper.customSnackBar(
        title: AppStrings.mustProvideSelfie,
        isError: true,
      );
      return;
    }

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    final bool success = await selfieService.uploadSelfie(
      file: _selectedImage ?? File(""),
      id: id,
    );
    if (success) {
      WidgetHelper.customSnackBar(
        title:
            "Thank you. Your Photo Is Sent to Admin For Approval, Still You Can Upload More Photo",
      );
      _selectedImage = null;
    } else {
      WidgetHelper.customSnackBar(
        title: "Oops !! Something Went Wrong",
        isError: true,
      );
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
