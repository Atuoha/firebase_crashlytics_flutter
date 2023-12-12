import 'package:firebase_crashlytics_flutter/presentation/analytics_screen.dart';
import 'package:firebase_crashlytics_flutter/presentation/messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Firebase Crashlytics App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => throw Exception(),
              child: const Text('Throw Exception'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => const FormatException('An error occurred'),
              child: const Text('Throw Exception with Feedback'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              ),
              child: const Text('Firebase Analytics'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FirebaseMessagingScreen(),
                ),
              ),
              child: const Text('Firebase Messaging'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('INCREMENT'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
