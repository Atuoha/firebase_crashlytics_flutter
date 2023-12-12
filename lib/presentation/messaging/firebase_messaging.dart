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
  }

  void sendMessage() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Messaging'),
      ),
      body: SingleChildScrollView(
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _titleTextController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                      label: Text('Title'),
                    ),
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
    );
  }
}
