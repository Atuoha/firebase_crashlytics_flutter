import 'dart:convert';

import 'package:firebase_crashlytics_flutter/main.dart';
import 'package:firebase_crashlytics_flutter/presentation/messaging/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessaging(RemoteMessage message) async {
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

final _localNotifications = FlutterLocalNotificationsPlugin();

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  navigationKey.currentState!.pushNamed(
    NotificationScreen.route,
    arguments: message,
  );
}

Future initPushNotification() async {
  await FirebaseMessaging.instance.requestPermission();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessaging);
}

const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Important Notification',
  description: 'Ths channel is used for important notifications',
  importance: Importance.defaultImportance,
);



Future initLocalNotifications() async {
  const android = AndroidInitializationSettings('@drawable/ic_launcher');
  const ios = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const settings = InitializationSettings(android: android, iOS: ios);

  await _localNotifications.initialize(settings,
      onDidReceiveBackgroundNotificationResponse: (
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    final message = RemoteMessage.fromMap(jsonDecode(payload!));
    handleMessage(message);
  });

  final androidPlatform =
      _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  // final iosPlatform = _localNotifications
  //     .resolvePlatformSpecificImplementation<
  //         IOSFlutterLocalNotificationsPlugin>()
  //     ?.requestPermissions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );

  await androidPlatform?.createNotificationChannel(_androidChannel);
}

class FirebaseMsgRepo {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initApp() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('fcmToken: $fcmToken');
    }
    initPushNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notifications = message.notification;
      if (notifications == null) return;

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
