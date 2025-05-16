import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/score_model/score_board_model.dart';
import 'package:mindful_youth/service/score_board_service/score_board_service.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';

class ScoreBoardProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ScoreBoardService scoreBoardService = ScoreBoardService();
  ScoreBoardModel? _scoreBoardModel;
  ScoreBoardModel? get scoreBoardModel => _scoreBoardModel;

  ScoreBoardModel? _userScore;
  ScoreBoardModel? get userScore => _userScore;

  Future<void> getScoreBoard(
    // {required BuildContext context}
  ) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _scoreBoardModel = await scoreBoardService.getScoreBoard();
    if (_scoreBoardModel?.success == true) {
      String id = await SharedPrefs.getSharedString(AppStrings.id);
      print("got this id to check ===> $id");
      getUserScoreWithTabIndex(id: id);
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  void getUserScoreWithTabIndex({required String id}) {
    List<Today> todayList =
        _scoreBoardModel?.data?.today
            ?.where((e) => e.userId.toString() == id)
            .toList() ??
        [];
    List<Weekly> weeklyList =
        _scoreBoardModel?.data?.weekly
            ?.where((e) => e.userId.toString() == id)
            .toList() ??
        [];
    List<Monthly> monthlyList =
        _scoreBoardModel?.data?.monthly
            ?.where((e) => e.userId.toString() == id)
            .toList() ??
        [];

    _userScore = ScoreBoardModel(
      data: ScoreBoardModelData(
        today: todayList,
        weekly: weeklyList,
        monthly: monthlyList,
      ),
    );

    notifyListeners();
  }
}
