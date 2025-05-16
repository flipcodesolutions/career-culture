import 'package:flutter/material.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/provider/home_screen_provider/user_over_all_score.dart';
import 'package:mindful_youth/service/programs_service/programs_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// homescreen navigation index
  int _navigationIndex = 0;
  int get navigationIndex => _navigationIndex;
  set setNavigationIndex(int index) {
    _navigationIndex = index;
    notifyListeners();
  }

  /// sliders
  ProgramsService programsService = ProgramsService();
  ProgramsModel? _sliderModel;
  ProgramsModel? get sliderModel => _sliderModel;

  Future<void> getHomeScreenSlider(
    // {required BuildContext context}
  ) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _sliderModel = await programsService.getHomeScreenSliders();

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// get user over all score
  UserOverAllScoreModel? _overAllScoreModel;
  UserOverAllScoreModel? get overAllScoreModel => _overAllScoreModel;
  Future<void> getUserOverAllScore(
    // {required BuildContext context}
  ) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _overAllScoreModel = await programsService.getUserOverAllScore(
      // context: context,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
