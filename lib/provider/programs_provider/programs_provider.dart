import 'package:flutter/material.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/service/programs_service/programs_service.dart';

class ProgramsProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// if provider is Loading
  bool _isGridView = false;
  bool get isGridView => _isGridView;
  set setGridView(bool isGrid) {
    _isGridView = isGrid;
    notifyListeners();
  }

  /// Service and getter and setter
  ProgramsService programsService = ProgramsService();
  ProgramsModel? _programsModel;
  ProgramsModel? get programsModel => _programsModel;

  /// current Selected program
  ProgramsInfo? _currentProgramInfo;
  ProgramsInfo? get currentProgramInfo => _currentProgramInfo;
  set setCurrentProgramInfo(ProgramsInfo info) {
    _currentProgramInfo = info;
    notifyListeners();
  }

  Future<void> getAllPrograms({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    _programsModel = await programsService.getAllPrograms(context: context);
    _isLoading = false;
    notifyListeners();
  }
}
