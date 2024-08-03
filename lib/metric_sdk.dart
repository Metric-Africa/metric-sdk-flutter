import 'package:metric_sdk/models/models.dart';

import 'metric_sdk_platform_interface.dart';

class MetricSdk {

  Future<String> launchSdk(String token) {
    return MetricSdkPlatform.instance.launchSdk(token);
  }

  void initMetricSdk(SdkSettings settings) {
    return MetricSdkPlatform.instance.initializeSdk(settings);
  }
}
