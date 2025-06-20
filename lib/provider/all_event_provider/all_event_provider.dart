import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';
import 'package:mindful_youth/models/all_events_model.dart/user_participated_events.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import '../../app_const/app_strings.dart';
import '../../models/all_events_model.dart/participant_confirmation_model.dart';
import '../../service/all_event_service/all_event_service.dart';

class AllEventProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  AllEventService eventService = AllEventService();
  AllEventModel? _eventModel;
  AllEventModel? get eventModel => _eventModel;
  MyEventsModel? _myEventsModel;
  MyEventsModel? get myEventsModel => _myEventsModel;

  Future<void> getAllEvents({
    required BuildContext context,
    String id = "",
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _eventModel = await eventService.getAllEvents(context: context, id: id);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  ///
  Future<void> eventParticipate({
    required BuildContext context,
    String id = "",
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    EventParticipantConfirmation? confirmation = await eventService
        .eventParticipation(context: context, id: id);
    if (confirmation?.success == true) {
      WidgetHelper.customSnackBar(title: AppStrings.participateDone);
    }
    pop(context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  ///
  Future<void> getAllUserEvents({
    required BuildContext context,
    String id = "",
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _myEventsModel = await eventService.getAllUserEvents(
      context: context,
      id: id,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// get events by condition
  List<EventModel> getEventsByModel({required bool isMyEvents}) {
    return isMyEvents
        ? _myEventsModel?.data
                ?.where((e) => e.event != null)
                .map((e) => e.event)
                .cast<EventModel>()
                .toList() ??
            <EventModel>[]
        : _eventModel?.data ?? <EventModel>[];
  }

  ///
  /// get events by condition
  List<EventModel?> getUpcomingEvents() {
    print("🔍 Fetching upcoming events...");

    final filteredEvents =
        _eventModel?.data
            ?.where((e) {
              final isValid = e.startDate != null && e.startDate!.isNotEmpty;
              print(
                "📅 Checking startDate for '${e.title}': ${e.startDate} -> Valid: $isValid",
              );
              return isValid;
            })
            .map((e) => e)
            .where((event) {
              final isFuture = MethodHelper.isTodayOrFutureDate(
                dateString: event.startDate ?? "",
              );
              print(
                "📆 Filtering '${event.title}' | startDate: ${event.startDate} -> Is future/today: $isFuture",
              );
              return isFuture;
            })
            .toList();

    if (filteredEvents == null || filteredEvents.isEmpty) {
      print("⚠️ No upcoming events found.");
      return <EventModel>[];
    }

    print("✅ ${filteredEvents.length} upcoming event(s) found. Sorting...");
    filteredEvents.sort((a, b) {
      final result = (a.startDate ?? "").compareTo(b.startDate ?? "");
      print(
        "🔃 Comparing '${a.title}' (${a.startDate}) ↔ '${b.title}' (${b.startDate}) => $result",
      );
      return result;
    });

    final result =
        filteredEvents.length > 3
            ? filteredEvents.take(3).toList()
            : filteredEvents;
    print(
      "🎯 Returning top ${result.length} event(s): ${result.map((e) => e?.title).toList()}",
    );

    return result;
  }
}
