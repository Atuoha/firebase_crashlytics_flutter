import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingScreen extends StatefulWidget {
  const FirebaseMessagingScreen({super.key});

  static const routeName = '/firebaseMessaging';

  @override
  State<FirebaseMessagingScreen> createState() =>
      _FirebaseMessagingScreenState();
}

class _FirebaseMessagingScreenState extends State<FirebaseMessagingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _bodyTextController = TextEditingController();
  String? token;

  // Instance of FlutterLocalNotificationsPlugin for local notifications
  final _localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
  }

  // request permission
  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      sound: true,
      announcement: true,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User accepted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User accepted permission provisionally');
    } else {
      print('User denied permission');
    }
  }

  // get token
  Future<void> getToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
      print('Token $token');
      saveUserToken(token: token);
    });
  }

  // init info
  Future<void> initInfo() async {
    var androidInitialization =
        const AndroidInitializationSettings('@drawable/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iosInitialization);

    _localNotifications.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {
          throw Exception('Payload is empty');
        }
      } catch (e) {
        rethrow;
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      print(
          'Title: ${remoteMessage.notification!.title}, Body: ${remoteMessage.notification!.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        remoteMessage.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: remoteMessage.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'msg',
        'msg',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: false,
      );

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await _localNotifications.show(
        0,
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
        notificationDetails,
        payload: remoteMessage.data['title'],
      );
    });
  }

  // save user token
  Future<void> saveUserToken({required String? token}) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_tokens')
          .doc('User2')
          .set(
        {'token': token},
      );
    } on FirebaseException catch (e) {
      throw Exception('An error occurred $e');
    } catch (e) {
      rethrow;
    }
  }

  // send message
  void sendMessage() {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();
    if (valid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Messaging'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameTextController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Username',
                        label: Text('Username'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'User can not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _titleTextController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                        label: Text('Title'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title can not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _bodyTextController,
                      maxLines: 3,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter Body',
                        label: Text('Body'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Body can not be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => sendMessage(),
                      child: const Text('Send Message'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
