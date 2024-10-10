import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:metric_sdk/models/models.dart';

import 'metric_sdk_platform_interface.dart';

/// An implementation of [MetricSdkPlatform] that uses method channels.
class MethodChannelMetricSdk extends MetricSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('metric_sdk');

  @override
  Future<String> launchSdk(String token) async {
    final outcome = await methodChannel.invokeMethod<String>('launchSdk', <String, dynamic>{
      'token': token,
    });
    return outcome ?? "UNKNOWN";
  }

  @override
  Future<String?> initializeSdk(SdkSettings settings) async {
    try {
      var argsMap = settings.map;

      argsMap["appName"] = settings.appTheme.appName;
      argsMap["brandLogoUrl"] = settings.appTheme.brandLogoUrl;
      argsMap["brandPrimaryColor"] = settings.appTheme.brandPrimaryColor;
      argsMap["secretKey"] = settings.authenticator.secretKey;
      argsMap["clientKey"] = settings.authenticator.clientKey;
      argsMap["environment"] = settings.environment.name;

      return await methodChannel.invokeMethod('initializeSdk', argsMap);
    }
    on PlatformException catch(e) {
      if (kDebugMode) {
        print("[Method Channel]: Failed to initialize SDK: '${e.message}'.");
      }
    }
    return null;
  }
}
