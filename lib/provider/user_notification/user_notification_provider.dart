import 'package:flutter/material.dart';
import 'package:mindful_youth/models/user_notification/user_notification_model.dart';
import 'package:mindful_youth/service/user_notification_service/user_notification_service.dart';

class UserNotificationProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  UserNotificationService userNotificationService = UserNotificationService();
  UserNotifications? _userScrollNotification;
  UserNotifications? get userScrollNotification => _userScrollNotification;

  /// get user notifications
  Future<void> getUserNotification({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _userScrollNotification = await userNotificationService.getUserNotification(
      context: context,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

  /// sent backend request that user have opened the
  Future<void> sentBackendThatNotificationIsOpened({
    required BuildContext context,
    required String notificationId,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    await userNotificationService.sentUserOpenedNotification(
      context: context,
      notificationId: notificationId,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
