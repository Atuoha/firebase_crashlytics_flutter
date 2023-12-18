import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    requestPermission();
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
