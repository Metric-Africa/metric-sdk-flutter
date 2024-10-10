import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metric_sdk/metric_sdk.dart';
import 'package:metric_sdk/models/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _sdkResult = "Uninitialized";

  @override
  void initState() {
    super.initState();
    initMetricSdk();
  }

  // Initialize metric SDK once
  void initMetricSdk() async {
    try {
      final response =  await FlutterMetricSdkBridge.initMetricSdk(
        SdkSettings(
            appTheme: AppTheme(
                appName: "Metric Plugin Example App",
                brandLogoUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/1280px-Google_2015_logo.svg.png",
                brandPrimaryColor: "#007AFF"
            ),
            authenticator: ClientAuthenticator(
                secretKey: "2ykkOj4SqMQJDDgNz6UO",
                clientKey: "ewtGzevNi8Pck6X9FrQvjWcXymBhneO8ESJns9l7VKPjC"
            ),
            environment: Environment.dev
        ));
      if (kDebugMode) {
        print("[App]: '$response'");
      }
    }
    on PlatformException catch (e) {
      if (kDebugMode) {
        print("[App]: Failed to initialize SDK: '${e.message}'.");
      }
    }
  }

  // Trigger metric sdk using token
  _launchMetricSdk() async {
    String outcome = await FlutterMetricSdkBridge.launchSdk("LPO3G6XLU");

    if (!mounted) return;
    setState(() {
      _sdkResult = outcome.isEmpty ? "success" : outcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Metric plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('SDK result: $_sdkResult'),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: _launchMetricSdk,
                child: const Text("Launch SDK"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
