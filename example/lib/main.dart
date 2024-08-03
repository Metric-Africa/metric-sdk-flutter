import 'package:flutter/material.dart';
import 'dart:async';

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

  final _metricSdkPlugin = MetricSdk();

  @override
  void initState() {
    super.initState();
    initMetricSdk();
  }

  // Initialize metric SDK once
  void initMetricSdk() {
    _metricSdkPlugin.initMetricSdk(
        SdkSettings(
            appTheme: AppTheme(
                appName: "appName",
                logoUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/1280px-Google_2015_logo.svg.png",
                primaryColor: Colors.lightBlue
            ),
            authenticator: ClientAuthenticator(
                secretKey: "Secret key here...",
                clientKey: "Client key here..."
            ),
            environment: Environment.dev
        )
    );
  }

  // Trigger metric sdk using token
  _launchMetricSdk() async {
    String outcome = await _metricSdkPlugin.launchSdk("LPO3G6XLU");

    if (!mounted) return;
    setState(() {
      _sdkResult = outcome;
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
