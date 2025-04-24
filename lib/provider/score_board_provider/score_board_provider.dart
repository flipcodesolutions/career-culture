import 'package:flutter/material.dart';
import 'package:mindful_youth/models/score_model/score_board_model.dart';
import 'package:mindful_youth/service/score_board_service/score_board_service.dart';

class ScoreBoardProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ScoreBoardService scoreBoardService = ScoreBoardService();
  ScoreBoardModel? _scoreBoardModel;
  ScoreBoardModel? get scoreBoardModel => _scoreBoardModel;

  Future<void> getScoreBoard({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _scoreBoardModel = await scoreBoardService.getScoreBoard(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
