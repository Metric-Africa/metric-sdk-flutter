import 'package:metric_sdk/models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'metric_sdk_method_channel.dart';

abstract class MetricSdkPlatform extends PlatformInterface {
  /// Constructs a MetricSdkPlatform.
  MetricSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static MetricSdkPlatform _instance = MethodChannelMetricSdk();

  /// The default instance of [MetricSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelMetricSdk].
  static MetricSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MetricSdkPlatform] when
  /// they register themselves.
  static set instance(MetricSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> launchSdk(String token) {
    throw UnimplementedError('launchSdk() has not been implemented.');
  }

  Future<String?> initializeSdk(SdkSettings settings){
     throw UnimplementedError('initializeSdk() has not been implemented.');
  }
}
