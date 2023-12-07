import 'dart:convert';
import 'package:firebase_crashlytics_flutter/main.dart';
import 'package:firebase_crashlytics_flutter/presentation/messaging/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Function to handle background messages
Future<void> handleBackgroundMessaging(RemoteMessage message) async {
  // Print title, body, and payload in debug mode
  if (kDebugMode) {
    print('Title: ${message.notification!.title}');
  }
  if (kDebugMode) {
    print('Body: ${message.notification!.body}');
  }
  if (kDebugMode) {
    print('Payload: ${message.data}');
  }
}

// Instance of FlutterLocalNotificationsPlugin for local notifications
final _localNotifications = FlutterLocalNotificationsPlugin();

// Function to handle incoming messages
void handleMessage(RemoteMessage? message) {
  // If message is null, return
  if (message == null) return;

  // Navigate to NotificationScreen with the received message
  navigationKey.currentState!.pushNamed(
    NotificationScreen.route,
    arguments: message,
  );
}

// Function to initialize push notifications
Future initPushNotification() async {
  // Request permission for Firebase Messaging
  await FirebaseMessaging.instance.requestPermission();

  // Set foreground notification presentation options
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle initial message and listen for messages when app is opened or in the background
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
}

// Android notification channel for high-importance notifications
const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Important Notification',
  description: 'This channel is used for important notifications',
  importance: Importance.defaultImportance,
);

// Function to initialize local notifications
Future initLocalNotifications() async {
  // Android initialization settings
  const android = AndroidInitializationSettings('@drawable/ic_launcher');

  // iOS initialization settings
  const ios = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  // Combined initialization settings for both Android and iOS
  const settings = InitializationSettings(android: android, iOS: ios);

  // Initialize FlutterLocalNotificationsPlugin with settings
  await _localNotifications.initialize(settings,
      onDidReceiveBackgroundNotificationResponse: (
    NotificationResponse notificationResponse,
  ) {
    // Handle background notification response by decoding payload and handling message
    final String? payload = notificationResponse.payload;
    final message = RemoteMessage.fromMap(jsonDecode(payload!));
    handleMessage(message);
  });

  // Resolve Android platform-specific implementation and create notification channel
  final androidPlatform =
      _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlatform?.createNotificationChannel(_androidChannel);
}

// Class for handling Firebase Messaging operations
class FirebaseMsgRepo {
  // Instance of FirebaseMessaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Method to initialize Firebase Messaging for the app
  Future<void> initNotifications() async {
    // Request permission for Firebase Messaging
    await _firebaseMessaging.requestPermission();

    // Get FCM token and print it in debug mode
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('fcmToken: $fcmToken');
    }

    // Initialize push notifications
    initPushNotification();

    // Initialize local notifications
    initLocalNotifications();

    // Listen for incoming messages and show local notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notifications = message.notification;
      if (notifications == null) return;

      // Show local notification with Android and iOS details
      _localNotifications.show(
        notifications.hashCode,
        notifications.title,
        notifications.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: _androidChannel.importance,
            icon: '@drawable/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentBanner: true,
            presentList: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }
}
