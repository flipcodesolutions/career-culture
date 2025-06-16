import 'package:flutter/material.dart';
import 'package:mindful_youth/models/faqs_model/faqs_model.dart';
import 'package:mindful_youth/screens/faq_screen/faq_screen.dart';
import 'package:mindful_youth/service/faqs_service.dart/faqs_service.dart';

class FaqsProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  FaqsService faqsService = FaqsService();
  FAQsModel? _faqsModel;
  FAQsModel? get faqsModel => _faqsModel;

  /// get [FAQsModel] to show in [FaqScreen]
  Future<void> getFAQs({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _faqsModel = await faqsService.getFAQs(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  ///
  void toggleIsOpen({required int id}) {
    final index = _faqsModel?.data?.indexWhere((e) => e.id == id);
    if (index != null && index != -1) {
      final item = _faqsModel?.data?[index];
      item?.isOpen = !item.isOpen;
      notifyListeners();
    }
  }
}
