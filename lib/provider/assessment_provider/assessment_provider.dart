import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/service/assessment_questions_service/assessment_questions_service.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
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
  void emptyAssessmentQuestions() {
    _assessmentQuestions = null;
    notifyListeners();
  }

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
    bool isInReviewMode = false,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _assessmentQuestions = await assessmentQuestionsService
        .getAssessmentQuestionsByPostId(context: context, postId: _postId);
    if (isInReviewMode) {
      _assessmentQuestions?.data?.forEach(
        /// this will set the previously answer to show user
        (e) => e.setPreviouslyAnswerToCurrentModel(),
      );
    }

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
          _assessmentQuestions?.data?[index].userAnswer;

      // Decode it into a List<String>
      List<String> currentOptions = [];
      if (selectedOptionJson != null && selectedOptionJson.isNotEmpty) {
        try {
          currentOptions = selectedOptionJson.split("|");
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
      _assessmentQuestions?.data?[index].userAnswer = currentOptions.join("|");

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
      _assessmentQuestions?.data?[index].userAnswer = selection;
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
      _assessmentQuestions?.data?[index].userAnswer = selection;
      // notifyListeners();
    }
  }

  /// select files
  void makeFilesSelection({
    required int questionId,
    required List<PlatformFile>? selectedFiles,
    required int maxFileSize,
  }) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );
    if (index != null && index != -1) {
      // Get the current selectedOption JSON string
      if (selectedFiles?.any((e) => e.size >= 1024 * 1024 * maxFileSize) ==
          true) {
        WidgetHelper.customSnackBar(
          title: AppStrings.imagesShouldBeLessThan2Mb(size: "$maxFileSize MB"),
          isError: true,
        );
        return;
      }
      _assessmentQuestions?.data?[index].selectedFiles = selectedFiles;
      notifyListeners();
    }
  }

  /// clear file selection
  void clearFilesSelection({required int questionId}) {
    int? index = _assessmentQuestions?.data?.indexWhere(
      (e) => e.id == questionId,
    );
    if (index != null && index != -1) {
      _assessmentQuestions?.data?[index].selectedFiles?.clear();
      notifyListeners();
    }
  }

  /// prepare for test
  DateTime? startTime;
  DateTime? finishTime;
  String? score;
  int point = 10;
  int correctAnswer = 0;
  List<String> mediaTypes = ["video", "image", "audio"];
  //// used to validate video text field
  GlobalKey<FormState> videoTextFieldKey = GlobalKey<FormState>();

  /// to check if test time to start or stop
  bool _isTestStarted = false;
  bool get isTestStarted => _isTestStarted;

  void startTest() {
    if (!_isTestStarted) {
      startTime = DateTime.now();
      _isTestStarted = true;
    }
    notifyListeners();
  }

  /// get the number of correct answer
  String noOfCorrectAnswer() {
    return "$correctAnswer / ${_assessmentQuestions?.data?.where((e) => !mediaTypes.contains(e.type)).toList().length}";
  }

  //// get the string how many coins earned with test
  String coinsEarned() {
    return "${point * correctAnswer}";
  }

  /// get the String how much time test took to complete
  String totalTimeOfTest() {
    return MethodHelper.formatTimeDifference(
      startTime ?? DateTime.now(),
      finishTime,
    );
  }

  /// after user finish with test , check and generate result from the answers and also send the user answer to backend
  Future<bool> finishTest() async {
    /// check if all questions are answered
    if (_assessmentQuestions?.data
            ?.where((e) => mediaTypes.contains(e.type) != true)
            .toList()
            .every(
              (q) =>
                  q.userAnswer != null &&
                  q.userAnswer?.trim().isNotEmpty == true,
            ) ==
        false) {
      WidgetHelper.customSnackBar(
        title: AppStrings.mustGiveAllAnswer,
        isError: true,
      );
      return false;
    }

    /// check how many answer is correct
    int noOfCorrectAnswer = 0;

    _assessmentQuestions?.data
        ?.where((e) => mediaTypes.contains(e.type) != true)
        .toList()
        .forEach((e) {
          if (e.type == "checkbox") {
            // Parse, trim, and SORT both correct and user answers
            final List<String>? correctAnswers =
                e.correctAnswer; // <-- Crucial: Sort the correct answers
            correctAnswers?.sort();
            final List<String> userAnswers =
                e.userAnswer?.split("|").map((s) => s.trim()).toList() ?? [];
            userAnswers.sort(); // <-- Crucial: Sort the user's answers

            // Now, compare the sorted lists using listEquals
            // The 'package:collection/collection.dart' provides a robust listEquals
            if (listEquals(correctAnswers, userAnswers)) {
              noOfCorrectAnswer++;
            }
          } else {
            if (e.userAnswer == e.correctAnswer?.first) {
              noOfCorrectAnswer++;
            }
          }
        });

    if (_isTestStarted) {
      correctAnswer = noOfCorrectAnswer;
      finishTime = DateTime.now();

      /// set _isLoading true
      _isLoading = true;
      notifyListeners();
      await submitAssessmentQuestions();

      /// set _isLoading false
      _isLoading = false;
      notifyListeners();
      _isTestStarted = false;
    }
    notifyListeners();
    return true;
  }

  /// reset test
  void resetTest() {
    score = null;
    startTime = null;
    finishTime = null;
    _assessmentQuestions = null;
    _formKey.currentState?.reset();
    _isTestStarted = false;
    notifyListeners();
  }

  /// sent back the answer user has picked to show them
  Future<void> submitAssessmentQuestions(
    // {required BuildContext context,}
  ) async {
    // Validation before making API call
    bool hasAllValidAnswers =
        _assessmentQuestions?.data
            ?.where((e) => mediaTypes.contains(e.type) != true)
            .every((q) {
              return (q.userAnswer != null &&
                  q.userAnswer?.trim().isNotEmpty == true);
            }) ??
        false;

    if (!hasAllValidAnswers) {
      WidgetHelper.customSnackBar(
        title: "Please answer all questions and upload required files.",
        isError: true,
        autoClose: false,
      );
      return;
    }

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    log(_assessmentQuestions?.toJson().toString() ?? "");
    bool success = await assessmentQuestionsService
        .postAssessmentQuestionsByPostId(
          // context: context,
          assessmentAnswer: _assessmentQuestions,
        );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// sent back the answer user has picked to show them
  Future<bool> submitAssessmentMediaQuestions({
    required BuildContext context,
  }) async {
    bool isAnyMediaProvided = false;
    bool isVideoLinkProvided = false;

    if (videoTextFieldKey.currentState?.validate() != true) {
      return false;
    }

    isVideoLinkProvided =
        _assessmentQuestions?.data
            ?.where((e) => e.type == "video")
            .any((e) => e.userAnswer?.isNotEmpty == true) ??
        false;

    isAnyMediaProvided =
        _assessmentQuestions?.data
            ?.where((e) => e.type == "audio" || e.type == "image")
            .any((e) => (e.selectedFiles ?? []).isNotEmpty) ??
        false;

    if (!isVideoLinkProvided && !isAnyMediaProvided) {
      WidgetHelper.customSnackBar(
        title: "Please Select At Least One Media to Share",
        isError: true,
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    log(_assessmentQuestions?.toJson().toString() ?? "");

    bool success = await assessmentQuestionsService
        .postAssessmentMediaQuestionsByPostId(
          assessmentAnswer: _assessmentQuestions,
        );
    videoTextFieldKey.currentState?.reset();
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
