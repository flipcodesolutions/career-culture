import 'package:flutter/material.dart';
import 'package:mindful_youth/service/assessment_questions_service/assessment_questions_service.dart';
import '../../models/assessment_question_model/assessment_question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AssessmentQuestionsService assessmentQuestionsService =
      AssessmentQuestionsService();
  AssessmentQuestionModel? _assessmentQuestions;
  AssessmentQuestionModel? get assessmentQuestions => _assessmentQuestions;

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
      String? selectedOptionJson =
          _assessmentQuestions?.data?[index].selectedOption;

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
      _assessmentQuestions?.data?[index].selectedOption = currentOptions.join(
        ",",
      );

      notifyListeners();
    }
  }
}
