import 'package:firebase_crashlytics_flutter/repositories/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingScreen extends StatefulWidget {
  const FirebaseMessagingScreen({super.key});

  @override
  State<FirebaseMessagingScreen> createState() =>
      _FirebaseMessagingScreenState();
}

class _FirebaseMessagingScreenState extends State<FirebaseMessagingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Messaging'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Text'),
          )
        ],
      ),
    );
  }
}
