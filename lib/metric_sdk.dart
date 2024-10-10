import 'package:metric_sdk/models/models.dart';
import 'metric_sdk_platform_interface.dart';

class FlutterMetricSdkBridge {
  static Future<String> launchSdk(String token) {
    return MetricSdkPlatform.instance.launchSdk(token);
  }

  static Future<String?> initMetricSdk(SdkSettings settings) {
    return MetricSdkPlatform.instance.initializeSdk(settings);
  }
}
