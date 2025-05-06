// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> onBackGroundMessage(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   FirebaseMessagingUtils.handleMessage(message);
// }

// class FirebaseMessagingUtils {
//   static final String NOTIFICATION_CHANNEL = 'notification_channel';
//   static final String SCHEDULE_CHANNEL = 'schedule_channel';
//   static final firebaseMessaging = FirebaseMessaging.instance;
//   static final localNotifications = FlutterLocalNotificationsPlugin();
//   static final androidChannel = AndroidNotificationChannel(
//     NOTIFICATION_CHANNEL,
//     'General Alerts',
//     importance: Importance.high,
//   );

//   static Future<void> initNotifications() async {
//     await firebaseMessaging.requestPermission();

//     initPushNotifications();
//     initLocalNotifications();
//   }

//   static Future<void> initPushNotifications() async {
//     await firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(onBackGroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       // print('onMessgaeFireBase ${message.toString()}');
//       FirebaseMessagingUtils.handleMessage(message);
//       FirebaseMessagingUtils.showLocalNotification(message);
//     });

//     // final fcmToken = await firebaseMessaging.getToken();
//     // await SharedPrefs.saveFCMToken(fcmToken ?? '');
//     // print('Firebase FCM Token $fcmToken');
//   }

//   static Future<void> initLocalNotifications() async {
//     const ios = DarwinInitializationSettings();
//     const android = AndroidInitializationSettings('mipmap/ic_launcher');
//     const settings = InitializationSettings(android: android, iOS: ios);

//     await localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {},
//     );

//     await _requestPermissions();
//   }

//   static Future<void> _requestPermissions() async {
//     if (Platform.isIOS) {
//       await localNotifications
//           .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin
//           >()
//           ?.requestPermissions(alert: true, badge: true, sound: true);
//     } else {
//       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//           localNotifications
//               .resolvePlatformSpecificImplementation<
//                 AndroidFlutterLocalNotificationsPlugin
//               >();

//       await androidImplementation?.requestNotificationsPermission();
//     }
//   }

//   static void handleMessage(RemoteMessage? message) {
//     if (message != null) {
//       if (message.notification?.body == "Please Take New Appointment") {
//         // print('${message.notification?.body}');
//         return;
//       }
//       // print('cant handle');
//     }
//   }

//   static void showLocalNotification(RemoteMessage remoteMessage) {
//     // print('showLocalNotification ${remoteMessage.notification}');
//     RemoteNotification? notification = remoteMessage.notification;
//     if (notification != null) {
//       localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             androidChannel.id,
//             androidChannel.name,
//             channelDescription: androidChannel.description,
//           ),
//         ),
//         payload: jsonEncode(remoteMessage.toMap()),
//       );
//     }
//   }

//   static Future<bool> checkIfNotificationsAreEnabled() async {
//     if (Platform.isAndroid) {
//       final bool granted =
//           await localNotifications
//               .resolvePlatformSpecificImplementation<
//                 AndroidFlutterLocalNotificationsPlugin
//               >()
//               ?.areNotificationsEnabled() ??
//           false;
//       return granted;
//     } else {
//       final bool granted =
//           await localNotifications
//               .resolvePlatformSpecificImplementation<
//                 IOSFlutterLocalNotificationsPlugin
//               >()
//               ?.requestPermissions(alert: true, badge: true, sound: true) ??
//           false;
//       return granted;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma(
  'vm:entry-point',
) // Necessary annotation for background execution:contentReference[oaicite:7]{index=7}
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in the background isolate
  await Firebase.initializeApp();
  // Display the notification using the service (will show a local notification)
  await NotificationService.instance._showNotification(message);
}

/// A singleton service class that manages Firebase Cloud Messaging and local notifications.
class NotificationService {
  // Private constructor for singleton pattern.
  NotificationService._privateConstructor();

  /// Singleton instance
  static final NotificationService instance =
      NotificationService._privateConstructor();

  // Firebase Messaging instance.
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Flutter Local Notifications plugin instance.
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Android notification channel (high importance).
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

  // Indicates if local notifications have been initialized.
  bool _initialized = false;

  /// Initialize the notification service.
  ///
  /// This sets up Firebase messaging listeners, requests permissions, and
  /// initializes local notifications. Call this early in `main()`.
  Future<void> initialize() async {
    // Setup background message handler (must be done before requesting permissions):contentReference[oaicite:10]{index=10}.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request notification permissions (especially needed on iOS):contentReference[oaicite:11]{index=11}.
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notification settings (Android channel, iOS settings).
    await _setupLocalNotifications();

    // Get the token each time the app launches.
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    // TODO: Optionally send the token to your backend server here.

    // Monitor token refresh.
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      // TODO: Send new token to backend if needed.
    });

    // Handle messages when the app is in the foreground:contentReference[oaicite:12]{index=12}.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.messageId}');
      _showNotification(message);
    });

    // Handle user interaction when the app is brought to foreground from background/terminated:contentReference[oaicite:13]{index=13}.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
    // Check if the app was opened via a notification (terminated state).
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  /// Internal helper to initialize local notifications (only once).
  Future<void> _setupLocalNotifications() async {
    if (_initialized) return;

    // Create an Android notification channel for high importance notifications.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    // Initialization settings for Android and iOS.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    // Initialize the plugin. Handle taps via onDidReceiveNotificationResponse.
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iOSSettings),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle local notification tap (if needed).
        // You can add logic to navigate to specific screens using payload from response.payload.
        print('Local notification tapped with payload: ${response.payload}');
      },
    );

    _initialized = true;
  }

  /// Displays a local notification using flutter_local_notifications.
  ///
  /// This is called for incoming FCM messages when the app is in foreground or background.
  Future<void> _showNotification(RemoteMessage message) async {
    // If the message contains a notification payload, use that for title/body.
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If there's no notification info (e.g., data-only message), you may customize as needed.
    if (notification == null) {
      print('No notification payload in message: ${message.data}');
      return;
    }

    // Details for Android notifications.
    final NotificationDetails platformChannelDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: android?.smallIcon, // Use app icon by default
      ),
      iOS: const DarwinNotificationDetails(),
    );

    // Show the notification.
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelDetails,
      payload: jsonEncode(message.data), // Pass any payload data if needed
    );
  }

  /// Handle notification tap: navigate or process message data.
  void _handleMessageTap(RemoteMessage message) {
    print('Notification opened: ${message.data}');
    // TODO: Implement navigation or state update based on message data, e.g.:
    // if (message.data['type'] == 'chat') { navigate to chat screen with message.data; }
  }
}
