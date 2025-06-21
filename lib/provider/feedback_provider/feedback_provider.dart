import 'package:flutter/material.dart';
import 'package:mindful_youth/service/feedback_service/feedback_service.dart';

class FeedbackProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  FeedbackService service = FeedbackService();
  Future<bool> feedback({
    required BuildContext context,
    required String mentorId,
    required String counselingDate,
    required String slotTime,
    required String rating,
    required String goal,
    required String message,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    final bool success = await service.feedback(
      context: context,
      mentorId: mentorId,
      counselingDate: counselingDate,
      slotTime: slotTime,
      rating: rating,
      goal: goal,
      message: message,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
