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
  void initializeSdk(SdkSettings settings) {
    methodChannel.invokeMethod('initializeSdk', <String, dynamic>{
      'appName': settings.appTheme.appName,
      'logo': settings.appTheme.logoUrl,
      'primaryColor': settings.appTheme.primaryColor.value,
      'secretKey': settings.authenticator.secretKey,
      'clientKey': settings.authenticator.clientKey,
      'environment': settings.environment.name,
    });
  }
}
