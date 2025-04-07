import 'package:flutter/material.dart';

import '../../models/assessment_question_model/assessment_question_model.dart';

class AssessmentProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<QuestionModel>? _assessmentQuestions = [
    QuestionModel(
      id: 1,
      questionText: 'What is the capital of France?',
      options: ['Paris', 'London', 'Berlin', 'Rome'],
    ),
    QuestionModel(
      id: 2,
      questionText: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
    ),
    QuestionModel(
      id: 3,
      questionText: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
    ),
    QuestionModel(
      id: 4,
      questionText: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
    ),
    QuestionModel(
      id: 4,
      questionText: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
    ),
  ];
  List<QuestionModel>? get assessmentQuestions => _assessmentQuestions;
  set setAssessmentQuestions(List<QuestionModel> assessmentQuestions) {
    _assessmentQuestions = assessmentQuestions;
    notifyListeners();
  }

  void updateAnswerSelection({
    required int selectedIndex,
    required int questionId,
  }) {
    final index = _assessmentQuestions?.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      _assessmentQuestions?[index ?? -1].selectedAnswer = selectedIndex;
      notifyListeners();
    }
  }

  int answerSelection({required int questionId}) {
    final index = _assessmentQuestions?.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      return _assessmentQuestions?[index ?? -1].selectedAnswer ?? -1;
    }
    return -1;
  }
}
