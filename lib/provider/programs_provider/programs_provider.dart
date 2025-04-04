import 'package:flutter/material.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/service/programs_service/programs_service.dart';

class ProgramsProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  ProgramsService programsService = ProgramsService();
  ProgramsModel? _programsModel;
  ProgramsModel? get programsModel => _programsModel;

  Future<void> getAllPrograms({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    _programsModel = await programsService.getAllPrograms(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
