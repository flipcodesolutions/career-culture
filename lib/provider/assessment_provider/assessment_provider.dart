import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/service/assessment_questions_service/assessment_questions_service.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import '../../models/assessment_question_model/assessment_question_model.dart';
import '../../utils/widget_helper/widget_helper.dart';

class AssessmentProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AssessmentQuestionsService assessmentQuestionsService =
      AssessmentQuestionsService();
  AssessmentQuestionModel? _assessmentQuestions;
  AssessmentQuestionModel? get assessmentQuestions => _assessmentQuestions;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  String _postId = "";
  String get postid => _postId;
  set setPostId(String postId) {
    _postId = postId;
    notifyListeners();
  }

  Future<void> getAssessmentQuestionsByPostId({
    required BuildContext context,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _assessmentQuestions = await assessmentQuestionsService
        .getAssessmentQuestionsByPostId(context: context, postId: _postId);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// will used only for checkbox to select options
  void makeOptionSelection({
    required int questionId,
    required String selection,
  }) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );

    if (index != null && index != -1) {
      // Get the current selectedOption JSON string
      String? selectedOptionJson = _assessmentQuestions?.data?[index].answer;

      // Decode it into a List<String>
      List<String> currentOptions = [];
      if (selectedOptionJson != null && selectedOptionJson.isNotEmpty) {
        try {
          currentOptions = selectedOptionJson.split(",");
        } catch (e) {
          print("Error decoding selectedOption: $e");
        }
      }

      // Toggle selection: remove if already selected, otherwise add
      if (currentOptions.contains(selection)) {
        currentOptions.remove(selection);
      } else {
        currentOptions.add(selection);
      }

      // Save it back
      _assessmentQuestions?.data?[index].answer = currentOptions.join(",");

      notifyListeners();
    }
  }

  /// select radio answer
  void makeRadioSelection({
    required int questionId,
    required String selection,
  }) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );
    if (index != null && index != -1) {
      // Get the current selectedOption JSON string
      _assessmentQuestions?.data?[index].answer = selection;
      notifyListeners();
    }
  }

  /// select text area answer
  void textAreaAnswer({required int questionId, required String selection}) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );
    if (index != null && index != -1) {
      // Get the current selectedOption JSON string
      _assessmentQuestions?.data?[index].answer = selection;
      notifyListeners();
    }
  }

  /// select files
  void makeFilesSelection({
    required int questionId,
    required List<PlatformFile>? selectedFiles,
  }) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );
    if (index != null && index != -1) {
      // Get the current selectedOption JSON string
      _assessmentQuestions?.data?[index].selectedFiles = selectedFiles;
      notifyListeners();
    }
  }

  Future<void> submitAssessmentQuestions({
    required BuildContext context,
  }) async {
    // Validation before making API call
    bool hasAllValidAnswers =
        _assessmentQuestions?.data?.every((q) {
          final isMediaType = ['audio', 'image'].contains(q.type);
          if (isMediaType) {
            return (q.selectedFiles?.isNotEmpty ?? false);
          } else {
            return (q.answer != null && q.answer?.trim().isNotEmpty == true);
          }
        }) ??
        false;

    if (!hasAllValidAnswers) {
      WidgetHelper.customSnackBar(
        context: context,
        title: "Please answer all questions and upload required files.",
        isError: true,
      );
      return;
    }

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    log(_assessmentQuestions?.toJson().toString() ?? "");
    bool success = await assessmentQuestionsService
        .postAssessmentQuestionsByPostId(
          context: context,
          assessmentAnswer: _assessmentQuestions,
        );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    if (success) {
      if (!context.mounted) return;
      pop(context);
    }
  }
}
