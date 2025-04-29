import 'package:flutter/widgets.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';

import '../../app_const/app_strings.dart';

class CounselingProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// selectable topics
  final topics = [
    "Depression",
    "Coping with Addiction",
    "Career Choice",
    "Mindful Living",
    "Motivation , self esteem and confidence.",
    "Personal Values & Integrity",
    "Overcoming Procrastination",
    "other",
  ];

  /// selected topics
  final List<String> selectedTopics = [];

  /// empty selection on delete
  void emptySelectedTopics() {
    selectedTopics.clear();
    notifyListeners();
  }

  /// check if at least one option
  void validateTopicsAreSelected({required BuildContext context}) async {
    if (selectedTopics.isEmpty) {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.mustSelectOneTopic,
      );
    }
  }
}
