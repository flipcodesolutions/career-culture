import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindful_youth/models/counseling_model/counseling_models.dart';
import 'package:mindful_youth/service/counseling_service/counseling_service.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../app_const/app_strings.dart';

class CounselingProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // /// selectable topics
  // final topics = [
  //   "Depression",
  //   "Coping with Addiction",
  //   "Career Choice",
  //   "Mindful Living",
  //   "Motivation , self esteem and confidence.",
  //   "Personal Values & Integrity",
  //   "Overcoming Procrastination",
  //   "other",
  // ];

  /// selected topics
  // final List<String> selectedTopics = [];

  /// empty selection on delete
  // void emptySelectedTopics() {
  //   selectedTopics.clear();
  //   notifyListeners();
  // }

  /// check if at least one option
  // void validateTopicsAreSelected({required BuildContext context}) async {
  //   if (selectedTopics.isEmpty) {
  //     WidgetHelper.customSnackBar(
  //       context: context,
  //       title: AppStrings.mustSelectOneTopic,
  //     );
  //   }
  // }

  /// Service and getter and setter
  CounselingService counselingService = CounselingService();
  CounselingDatesAndSlotsModel? _counselingDatesAndSlots;
  CounselingDatesAndSlotsModel? get counselingDatesAndSlots =>
      _counselingDatesAndSlots;

  /// get dates and slots for counseling
  Future<void> getCounselignDatesAndSlots({
    required BuildContext context,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _counselingDatesAndSlots = await counselingService
        .getSlotsAndDateForCounseling(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  void initControllerFromLocalStorage() async {
    nameController.text = await SharedPrefs.getSharedString(
      AppStrings.userName,
    );
    emailController.text = await SharedPrefs.getSharedString(
      AppStrings.userEmail,
    );
    contactController.text = await SharedPrefs.getSharedString(
      AppStrings.userContactNo1,
    );
  }

  /// picked slot
  String _pickedMode = "";
  String get pickedMode => _pickedMode;

  /// picked slot
  String _pickedDate = "";
  String get pickedDate => _pickedDate;
  bool isDatePicked = false;

  /// picked slot
  String _pickedSlot = "";
  String get pickedSlot => _pickedSlot;

  /// get filtered dates to show
  List<DropdownMenuEntry<String>> getDatesForCounseling() {
    List<String> dates = [];
    _counselingDatesAndSlots?.data?.forEach((e) {
      if (!dates.contains(e.date)) {
        dates.add(e.date ?? "");
      }
    });
    dates.sort();
    return dates.isNotEmpty
        ? List.generate(
          dates.length,
          (index) =>
              DropdownMenuEntry(value: dates[index], label: dates[index]),
        )
        : [DropdownMenuEntry(value: "", label: AppStrings.noDateFound)];
  }

  ///
  /// get filtered dates to show
  List<DropdownMenuEntry<String>> getSlotsForCounseling() {
    List<String> slots = [];
    _counselingDatesAndSlots?.data?.forEach((e) {
      if (e.date == _pickedDate) {
        slots.add(e.time ?? "");
      }
    });
    slots.sort();
    return slots.isNotEmpty
        ? List.generate(
          slots.length,
          (index) =>
              DropdownMenuEntry(value: slots[index], label: slots[index]),
        )
        : [DropdownMenuEntry(value: "", label: AppStrings.noSlotsFound)];
  }

  bool checkIfPicked() {
    return [_pickedDate, _pickedSlot, _pickedMode].any((val) => val.isEmpty);
  }

  void selectModeForCounseling({required String? pickedMode}) {
    _pickedMode = pickedMode ?? "";
    notifyListeners();
  }

  void selectDateForCounseling({required String? pickedDate}) {
    _pickedDate = pickedDate ?? "";
    isDatePicked = _pickedDate.isNotEmpty == true;
    log(isDatePicked.toString());
    notifyListeners();
  }

  void selectSlotForCounseling({required String? pickedSlot}) {
    _pickedSlot = pickedSlot ?? "";
    notifyListeners();
  }

  void createCounselingAppointment({required BuildContext context}) async {
    if (!checkIfPicked()) {
      /// create counseling
      /// set _isLoading true
      _isLoading = true;
      notifyListeners();
      bool success = await counselingService.createCounselingAppointment(
        context: context,
        appointmentDate: pickedDate,
        slot: pickedSlot,
        mode: pickedMode,
      );

      /// set _isLoading false
      _isLoading = false;
      notifyListeners();
      if (success) {
        if (context.mounted) {
          pop(context);
          WidgetHelper.customSnackBar(
            title: AppStrings.counselingAppointmentRequested,
            autoClose: false,
          );
        }
      }
    } else {
      WidgetHelper.customSnackBar(
        title: AppStrings.somethingWentWrong,
        isError: true,
      );
    }
  }
}
