import 'package:flutter/material.dart';
import 'package:mindful_youth/models/on_boarding_model/on_borading_model.dart';
import 'package:mindful_youth/screens/on_boarding_screen/on_boarding_single_screen.dart';
import 'package:mindful_youth/service/on_boarding_service/on_boarding_service.dart';

class OnBoardingProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// if provider is Loading
  int _currentPage = 0;
  int get currentPage => _currentPage;
  set setCurrentPage(int pageIndex) {
    _currentPage = pageIndex;
    notifyListeners();
  }

  /// Service and getter and setter
  OnBoardingService onBoardingService = OnBoardingService();
  OnBoardingModel? _onBoardingModel;
  OnBoardingModel? get onBoardingModel => _onBoardingModel;

  Future<void> getOnBoarding(
    {required BuildContext context}
    ) async {
    if (!context.mounted) return;
    _isLoading = true;
    notifyListeners();

    _onBoardingModel = await onBoardingService.getOnBoardings(context: context);
    _isLoading = false;
    notifyListeners();
  }

  List<OnBoardingSinglePage> onBoardingSinglePageList() {
    List<OnBoardingSinglePage> pageList = [];

    _onBoardingModel?.data?.forEach(
      (element) => pageList.add(OnBoardingSinglePage(onBoardingInfo: element)),
    );

    return pageList;
  }
}
