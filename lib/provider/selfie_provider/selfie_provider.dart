import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindful_youth/models/selfie_model/selfie_model.dart';
import 'package:mindful_youth/models/selfie_model/uploaded_selfies_with_status.dart';
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

  /// for selected options
  int? _selfieQuestionID;
  int? get selfieQuestionID => _selfieQuestionID;
  void setSelectedQuestion({required int? data}) {
    _selfieQuestionID = data;
    notifyListeners();
  }

  /// get uploaded selfies with status
  UploadedSelfiesWithStatusModel? _uploadedSelfiesWithSelfie;
  UploadedSelfiesWithStatusModel? get uploadedSelfiesWithSelfie =>
      _uploadedSelfiesWithSelfie;

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

  /// get selfie zone
  Future<void> getUploadedSelfieWithStatus({
    required BuildContext context,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _uploadedSelfiesWithSelfie = await selfieService
        .getUploadedSelfieWithStatus(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// get list of questions
  List<DropdownMenuEntry<int?>> dropdownMenuEntries() {
    return List.generate(
      _selfieZone?.data?.length ?? 0,
      (index) => DropdownMenuEntry(
        value: _selfieZone?.data?[index].id,
        label: _selfieZone?.data?[index].title ?? "",
      ),
    );
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

  ////
  Future<void> uploadSelfie() async {
    if (_selectedImage == null) {
      WidgetHelper.customSnackBar(
        title: AppStrings.mustProvideSelfie,
        isError: true,
      );
      return;
    }
    if (_selfieQuestionID == null || _selfieQuestionID == -1) {
      WidgetHelper.customSnackBar(
        title: AppStrings.selectQuestion,
        isError: true,
      );
      return;
    }

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    final bool success = await selfieService.uploadSelfie(
      file: _selectedImage ?? File(""),
      id: _selfieQuestionID ?? -1,
    );
    if (success) {
      WidgetHelper.customSnackBar(
        title:
            "Thank you. Your Photo Is Sent to Admin For Approval, Still You Can Upload More Photo",
      );
      _selectedImage = null;
      _selfieQuestionID = null;
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
