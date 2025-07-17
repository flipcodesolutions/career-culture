import 'package:flutter/material.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/chapter_container.dart';
import 'package:mindful_youth/service/chapter_service/chapter_service.dart';
import '../../../models/programs/user_progress_model.dart';

class ChapterProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  ChapterService chapterService = ChapterService();
  ChaptersModel? _chaptersModel;
  ChaptersModel? get chaptersModel => _chaptersModel;

  Future<void> getChapterById({
    required BuildContext context,
    required String id,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _chaptersModel = null;
    _chaptersModel = await chapterService.getChapterById(
      context: context,
      id: id,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  List<ChapterContainer> renderChapterList({
    required UserProgressModel? userProgressModel,
    required bool isUserLoggedIn,
  }) {
    List<ChapterContainer> list = [];
    if (_chaptersModel?.data?.isEmpty == true) {
      return list;
    }
    for (int i = 1; i <= (_chaptersModel?.data?.length ?? 0); i++) {
      list.add(ChapterContainer(chaptersInfo: _chaptersModel!.data![i - 1]));
    }
    // _chaptersModel?.data?.forEach(
    //   (e) => list.add(ChapterContainer(chaptersInfo: e)),
    // );
    return list;
  }

  Future<void> getAllChapters({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _chaptersModel = null;
    _chaptersModel = await chapterService.getAllChapters(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }


  
}
