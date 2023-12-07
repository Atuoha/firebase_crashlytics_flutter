import 'package:firebase_crashlytics_flutter/presentation/messaging/messaging.dart';
import 'package:flutter/material.dart';

import '../services/analytics_service/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int saveCount = 0;
  int downloadCount = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.analytics.setAnalyticsCollectionEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Firebase Analytics App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Save Count: ',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: saveCount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Download Count: ',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: downloadCount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.ltr,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FirebaseMessagingScreen(),
                  ),
                ),
                label: const Text('Messaging'),
                icon: Icon(Icons.sms_outlined),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "save",
            key: const Key('save'),
            onPressed: () async {
              await AnalyticsService.analytics.logEvent(
                name: 'number_of_saves',
                parameters: {
                  'data': saveCount,
                },
              );
              setState(() {
                saveCount++;
              });
            },
            child: const Icon(Icons.save),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "download",
            key: const Key('download'),
            onPressed: () async {
              await AnalyticsService.analytics.logEvent(
                name: 'number_of_downloads',
                parameters: {
                  'data': downloadCount,
                },
              );
              setState(() {
                downloadCount++;
              });
            },
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
